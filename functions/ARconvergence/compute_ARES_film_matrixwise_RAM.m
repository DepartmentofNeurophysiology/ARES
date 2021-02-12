function [ARES_film, ARES_film_info] = compute_ARES_film_matrixwise_RAM (img, images_stack_info, selected_ROI, tag_array, opts_ARES_film)
% Compute pixelwise Autoregression Residuals Film.
% 
% This function computes a film where each single pixel value in a frame,
% is the average (or max) of the residuals time series of the 
% autoregression of that pixel time series, 
% computed on a sliding window over multiple frames.
% AutoRegression means that a pixel time series is regressed using 
% its own past. The autoregressive model used is linear by default, but it
% can be changed into exponential.
% The residuals of the AutoRegression are a measure of how well the 
% fluorescence signal can be predicted by its past, or in other words, of 
% the signal unpredictability. The noise part gets cancelled 
% by the averaging of the residuals time series.
% 
% Differently than the "compute_ARES_film_matrixwise" function, here the 
% raw images are not entirely loaded in the RAM, but they are loaded as 
% needed in the computation, saving quite a bit of RAM use, but slightly 
% slowing down the computation. This is the function we recommand to use.
%
% ~~~ INPUT VARIABLES ~~~ %
% 
% - "img", is a struct containing info on the tif images to load.
%   each tif file to load should contain a single image.
%   the main function "calcium_imaging_guided_analysis" will, if needed,
%   ask the user to create a folder where to automatically create 
%   the separated .tif images in the correct format.
% - "images_stack_info", a struct variable containing the infos about 
%   the image_stack. It is automatically produced by the toolbox when
%   loading or modifying the images_stack used.
% - (Optional) "selected_ROI" is an ROI mask, that is, a 2D logic matrix:
%   the pixels corresponding to 0 in the ROI matrix will be ignored 
%   in the analysis.
%   If not specified as input, will consider an ROI with all elements = 1.
% - (Optional) "tag_array" is an array containing tags for each of the
%   film frames: tags might take different values, but every tag different
%   than 1 will be skipped in these computations.
%   For more info on the tag_array vector check the corresponding 
%   generating function "tag_intertrial_frames" included the toolbox.
%   If tag_array is not specified as input variable, an array with every
%   value = 1 will be used, therefore all frames will be included in the
%   computations.
% - (Optional) "opts_ARES_film" is a struct variable containing 
%   all the options available to compute the ARES film.
%   If this is not present, default values will be used.
% 
%    .window_type: is the type of sliding window applied to the pixel 
%    time series. It can assume the values (strings):
%    'rectangular', 'gaussian', 'hanning', 'hamming', 'blackman'.
%    .window_g_std: in case 'gaussian' is selected as window_type, 
%    its standard deviation can be specified.
%    .window_advance_step: is the number of frames which the window will
%    advance of, after computing a single frame output.
%    .window_length: is the length of the window used in frames (or time
%    points, it's the same thing!): the shorter the time window, the 
%    more sensitive to variation AND noise the analysis will be.
%    .process_order: is the order of the Autoregressive Process used to
%    model the time series. In Ca2+ experiments, a smaller process_order
%    will capture faster dynamics (depending on the Ca2+ indicator used,
%    the most appropriate process order might vary).
%    process_order >= window_length - 1 is forbidden as it's not
%    possible to model a time series with a process with an order equal
%    or higher than the number of time points.
%    .matrix_dimension: the time series of multiple pixels are chuncked 
%    into a single matrix for increased computational speed.
%    .absolute_value: if 1, compute the absolute value of the residuals.
%    .FLAG_demean: if 1, demeans each time series before computing the 
%    AutoRegression.
%    .reg_mode: 'linear' or 'exponential', decides if to compute 
%    a liner or exponential regression.
%    .residuals_mode: decides if to take the residuals avg or max as 
%    pixel value (max is not fully tested but left as an option).
%	 .opts_neighbourhood_ts.neighbourhood_order: if different than 0,
% 	 each pixel time series will be replaced with its neighbourhood 
%	 average: the neighbourhood order being decided by the value
%	 assigned to this variable.
%    .opts_ARES_film.opts_neighbourhood_ts.FLAG_ignore_outside_ROI:
%	 if = 1, also pixels outside the ROI will be taken into account
% 	 in computing the neighbourhood average time series; set = 0 if
%	 you want to skip them (note: in this case the pixels on the ROI
%	 border will be undersampled).
% 
%   DEFAULT VALUES for "opts_ARES_film" are: 
%       opts_ARES_film.window_type = 'rectangular';
%       opts_ARES_film.window_g_std = 6;
%       opts_ARES_film.window_advance_step = 1;
%       opts_ARES_film.window_length = 25;
%       opts_ARES_film.process_order = 2;
%       opts_ARES_film.matrix_dimension = 50;
%       opts_ARES_film.absolute_value = 0;
%       opts_ARES_film.FLAG_demean = 0;
%       opts_ARES_film.reg_mode = 'linear';
%       opts_ARES_film.residuals_mode = 'avg'
%		opts_ARES_film.opts_neighbourhood_ts.neighbourhood_order = 0;
%		opts_ARES_film.opts_neighbourhood_ts.FLAG_ignore_outside_ROI = 0;
% ~~~ OUTPUT VARIABLES ~~~ %
% 
% - "AR_SR_film" is the 3D matrix containing all the analized frames.
% - "AR_SR_film_info" is a struct containing infos about the film and 
%                      analysis performed.
% 
% ~~~ NOTES ~~~ %
% To save the output in either a .mat file, .tif stack, or .avi film, use
% the save_output_mat, save_output_tif_stack, save_output_avi functions.
% ---------------------------------------------------------------------- %


%%  Checking inputs and setting default values.
% Checking for allowed number of inputs.
if (nargin < 2 || nargin > 5) 
    error('Wrong number of inputs, check function INPUT section for more info.');
end


% Declaring basic image stack related variables.
number_of_frames = images_stack_info.number_of_frames;
image_Height = images_stack_info.Height;
image_Width = images_stack_info.Width;
first_image_to_load = images_stack_info.first_frame;

% Checking inputs and loading defaults.
if (nargin < 5) || ~exist('opts_ARES_film', 'var')
    fprintf('Options variable missing.\n');
    opts_ARES_film.window_type = 'rectangular';
    opts_ARES_film.window_g_std = 6;
    opts_ARES_film.window_advance_step = 1;
    opts_ARES_film.window_length = 25;
    opts_ARES_film.process_order = 2;
    opts_ARES_film.matrix_dimension = 50;
    opts_ARES_film.absolute_value = 0;
    opts_ARES_film.FLAG_demean = 0;
    opts_ARES_film.reg_mode = 'linear'; % linear or exponential
    opts_ARES_film.residuals_mode = 'avg'; % avg or max
    opts_ARES_film.opts_neighbourhood_ts.neighbourhood_order = 0; % Do not bin pixels together.
    opts_ARES_film.opts_neighbourhood_ts.FLAG_ignore_outside_ROI = 0; % Include pixels outside the ROI in the neighbourhood.
    fprintf('Default options loaded: Check function INPUT section for more info.\n\n');
end
if (nargin < 4) || isempty(tag_array) % In this case, generate a tag_array = 1.
    fprintf('Tag array missing: will use every frame. Check function INPUT section for more info.\n\n');
    tag_array = ones(1, number_of_frames);
end
if (nargin < 3) || isempty(selected_ROI) % In this case, generate a ROI = 1.
    fprintf('ROI missing: will use every pixel. Check function INPUT section for more info.\n\n');
    selected_ROI = ones(image_Height, image_Width);
end

% Declaring variables.
process_order = opts_ARES_film.process_order;
window_type = opts_ARES_film.window_type;
window_g_std = opts_ARES_film.window_g_std;
window_advance_step = opts_ARES_film.window_advance_step;
window_length = opts_ARES_film.window_length;
matrix_dimension = opts_ARES_film.matrix_dimension;
absolute_value = opts_ARES_film.absolute_value;
FLAG_demean = opts_ARES_film.FLAG_demean;
reg_mode = opts_ARES_film.reg_mode;
residuals_mode = opts_ARES_film.residuals_mode;
opts_neighbourhood_ts = opts_ARES_film.opts_neighbourhood_ts;

% Integrity checks.
assert (process_order < window_length, 'Process order must be smaller than the length of the time window used.');


%% ~~~ Counting Number of pixels in ROI ~~~ %%
number_of_pixels_in_ROI = 0;
for i_pixel = 1:image_Height
    for j_pixel = 1:image_Width
        if (selected_ROI(i_pixel, j_pixel) == 1)
            number_of_pixels_in_ROI = number_of_pixels_in_ROI + 1;
        end
    end
end


%% ~~~ Setting the window ~~~ %%
window_used = set_window (window_type, window_length, window_g_std);


%% ~~~ Computing Average Regression Residuals film ~~~ %%
fprintf('\n\n --- Attention: the computation might take a long time!!! --- \n\n');

% Computing number of frames skipped and film length.
number_of_frames_skipped = 0;
for i_image = 1:(number_of_frames - window_length)
    if tag_array(1, i_image) ~= 1 || tag_array(1, i_image + window_length) ~= 1
        number_of_frames_skipped = number_of_frames_skipped + 1;
    end
end
film_length = numel(1:window_advance_step:(number_of_frames - number_of_frames_skipped)) - window_length;

% Computing number of matrix regression needed.
number_of_matrix_regressions = double(idivide(number_of_pixels_in_ROI, int32(matrix_dimension), 'ceil'));

% Initializing variables.
ARES_img = NaN(image_Height, image_Width);
ARES_film = NaN(image_Height, image_Width, film_length);
ARES_time_projection_avg = zeros(1, film_length);
ARES_time_projection_max = zeros(1, film_length);
ARES_time_projection_min = zeros(1, film_length);
ARES_time_projection_avg_noninf = zeros(1, film_length);
ARES_time_projection_max_noninf = zeros(1, film_length);
ARES_time_projection_min_noninf = zeros(1, film_length);
counter_inf_res_array = zeros(1, film_length);
counter_nan_res_array = zeros(1, film_length);
current_pixel_TS = zeros (1, window_length); % This initialization is needed for versions of matlab older than 2015a
current_TS_matrix = zeros (matrix_dimension, window_length);
matrix_to_pixel_correspondence = cell(matrix_dimension, 1);

% Initializing waitbar.
prog_bar = waitbar(0, 'Cylon virus detected!', 'Name', 'Computing Autoregression Film...',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)'); % There is no virus, this is a dummy string, I hope you get the quote.
% setappdata(prog_bar, 'canceling', 0);


% Load 1st image.
img_tmp = img;
current_image = imread (img_tmp.files(first_image_to_load).name);
images_stack(:,:,1) = current_image;
% Load the other n = window_length-1 images
for j_image = 1:window_length
    current_image = imread (img_tmp.files(j_image+first_image_to_load-1).name);
    images_stack(:,:, j_image) = current_image;
end

counter_frame = 1;
tic

for i_image = 1:window_advance_step:(number_of_frames - window_length - 1)
    counter_inf_res = 0; % Counter for infinite value in current frame, mainly for debugging
    counter_nan_res = 0; % Counter for NaN value in current frame, mainly for debugging
    i_pixel = 1;
    j_pixel = 1;
    if i_image ~= 1 % Advance time window.
        % Remove the first n = window_advance_step entries
        images_stack_tmp = images_stack;
        images_stack(:,:,1:(window_length-window_advance_step)) = images_stack_tmp(:,:,(1+window_advance_step):end);
        clear images_stack_tmp;
        % Load the next n = window_advance_step entries from the images
        for i = 1:window_advance_step
            current_image = imread (img_tmp.files(i_image+first_image_to_load+window_length+i-1).name);
            images_stack(:,:, (window_length-window_advance_step+i)) = current_image;
        end
    end
        
    % Increasing the index until only activity frames are considered.
    if (tag_array(1, i_image) == 1 && tag_array(1, i_image + window_length) == 1)
        
        % Update waitbar
        waitbar(counter_frame/film_length, prog_bar, sprintf('Computing Frame: %d / %d', counter_frame, film_length));
        if getappdata(prog_bar, 'canceling')
            delete(prog_bar);
            warning('Operation cancelled by user.');
            return
        end
        
        % Loop over matrices (groups) of pixel time series.
        AR_matrix_counter = 1;
        while AR_matrix_counter <= number_of_matrix_regressions
            pixel_counter = 1;
            % Assort the pixel time series into matrices for faster
            % regression.
            while i_pixel <= image_Height && pixel_counter <= matrix_dimension
                while j_pixel <= image_Width && pixel_counter <= matrix_dimension
                    if (selected_ROI(i_pixel, j_pixel) == 1) % Use only ROI pixels.
                        matrix_to_pixel_correspondence{pixel_counter, 1} = [i_pixel, j_pixel];
                        if opts_neighbourhood_ts.neighbourhood_order ~= 0 % Use neighbourhood time series instead of single pixel, if required.
                            neighbourhood_TS = compute_neighbourhood_ts(images_stack, selected_ROI, [i_pixel, j_pixel], opts_neighbourhood_ts);
                            current_pixel_TS = neighbourhood_TS.*window_used;
                        else
                            current_pixel_TS(:) = double(images_stack(i_pixel, j_pixel, 1:end));
                            current_pixel_TS = current_pixel_TS.*window_used;
                        end
                        current_TS_matrix(pixel_counter, :) = current_pixel_TS;
                        pixel_counter = pixel_counter + 1;
                    end
                    j_pixel = j_pixel + 1;
                end
                if pixel_counter > matrix_dimension
                    FLAG_full_matrix = 1;
                else
                    FLAG_full_matrix = 0;
                end
                if FLAG_full_matrix == 0  % Move to next line
                    i_pixel = i_pixel + 1;
                    j_pixel = 1;
                else
                    break;  % Matrix is full, move onto regression.
                end
            end
            
            % Computing AR process residuals for the selected matrix.
            for pixel_counter = 1:matrix_dimension
                Residuals = AutoRegress_TS_residuals (current_TS_matrix(pixel_counter, :), process_order, FLAG_demean, reg_mode);
                % Re-assorting Residuals to correspondent pixels
                current_pixel = matrix_to_pixel_correspondence{pixel_counter, 1};
                if absolute_value == 1
                    current_pixel_res = abs(Residuals); %(pixel_counter, :); % commented part was for matrix wise use
                elseif absolute_value == 0
                    current_pixel_res = Residuals; %(pixel_counter, :); % commented part was for matrix wise use
                else
                    error ('absolute_value option must be either 0 or 1.');
                end
                if strcmpi(residuals_mode, 'avg') == 1 % Take mean of the residuals time series
                    current_pixel_res_proj = nanmean(current_pixel_res(1, current_pixel_res(1,:)<inf));
                elseif strcmpi(residuals_mode, 'max') == 1 % Take max of the residuals time series
                    current_pixel_res_proj = nanmax(current_pixel_res(1, current_pixel_res(1,:)<inf));
                else
                    error ('residuals_mode must be either max or avg.');
                end
                % Save processed frame.
                ARES_img(current_pixel(1,1), current_pixel(1,2)) = current_pixel_res_proj;
                % Infinities/NaNs counters.
                mean_res = mean(current_pixel_res);
                if isinf(mean_res)
                    counter_inf_res = counter_inf_res + 1;
                elseif isnan(mean_res)
                    counter_nan_res = counter_nan_res + 1;
                end
            end
            AR_matrix_counter = AR_matrix_counter + 1;
        end
        % Save processed frame into the film.
        ARES_film(:,:,counter_frame) = ARES_img(:,:);
        
        % Computing projections.
        ARES_img_tmp = nonzeros(ARES_img);
        ARES_time_projection_avg(1, counter_frame) = nanmean(ARES_img_tmp);
        ARES_time_projection_max(1, counter_frame) = nanmax(ARES_img_tmp);
        ARES_time_projection_min(1, counter_frame) = nanmin(ARES_img_tmp);
        ARES_img_tmp = reshape(ARES_img_tmp, [1, numel(ARES_img_tmp)]);
        ARES_time_projection_avg_noninf(1, counter_frame) = nanmean(ARES_img_tmp(1, ARES_img_tmp(1,:)<inf));
        ARES_time_projection_max_noninf(1, counter_frame) = nanmax(ARES_img_tmp(1, ARES_img_tmp(1,:)<inf));
        ARES_time_projection_min_noninf(1, counter_frame) = nanmin(ARES_img_tmp(1, ARES_img_tmp(1,:)<inf));
        % Count infinities or nan values per frame.
        counter_inf_res_array(1, counter_frame) = counter_inf_res;
        counter_nan_res_array(1, counter_frame) = counter_nan_res;
        if counter_frame == 2
            time_2nd_frame = toc;
            time_estimated = (time_2nd_frame/2)*film_length - 2*time_2nd_frame;
            time_est_hour = floor(time_estimated/(60*60));
            time_est_m = floor( (time_estimated - time_est_hour*(60*60)) /60);
            time_est_s = floor(rem( (time_estimated - time_est_hour*(60*60)), 60));
            fprintf('\nEstimated time to complete: %dh:%dm:%ds.\n', time_est_hour, time_est_m, time_est_s);
        end
        % Update frame counter.
        counter_frame = counter_frame + 1;
        
    end
end
computation_time = toc;
time_comp_hour = floor(computation_time/(60*60));
time_comp_m = floor( (computation_time - time_comp_hour*(60*60)) /60);
time_comp_s = floor(rem( (computation_time - time_comp_hour*(60*60)), 60));
computation_time_per_frame = computation_time/film_length;
delete(prog_bar);
fprintf('\nAutoregression residuals film computed correctly.\n');
fprintf('\nTime elapsed: %dh:%dm:%ds.\n', time_comp_hour, time_comp_m, time_comp_s);


%% Making info structure
% Getting date
formatOut = 'dd-mmm-yyyy';
date_str = datestr(now,formatOut);    % Take current date in format "formatOut"
date_str = regexprep(date_str, '-', '');    % Remove the "-" from the string

ARES_film_info.date_analysed = date_str;
ARES_film_info.original_stack_FileName = images_stack_info.FileName_short;
ARES_film_info.process_order = process_order;
ARES_film_info.absolute_value = absolute_value;
ARES_film_info.regression_mode = reg_mode;
ARES_film_info.residuals_mode = residuals_mode;
ARES_film_info.FLAG_RemoveOrInterpolateFrames = images_stack_info.FLAG_RemoveOrInterpolate;
ARES_film_info.FLAG_Remove_Intertrial = images_stack_info.FLAG_Remove_Intertrial;
ARES_film_info.FLAG_demean = FLAG_demean;
ARES_film_info.RAW_normalized = images_stack_info.normalized;
ARES_film_info.number_of_frames = film_length;
ARES_film_info.number_of_frames_skipped = number_of_frames_skipped;
ARES_film_info.first_frame = images_stack_info.first_frame;
ARES_film_info.min = min(ARES_time_projection_min);
ARES_film_info.max = max(ARES_time_projection_max);
ARES_film_info.avg = mean(ARES_time_projection_avg);
ARES_film_info.noninf_max = ARES_film_info.max;
ARES_film_info.noninf_avg = ARES_film_info.avg;
% Check for infinities.
if isinf(ARES_film_info.max)
    ARES_film_info.noninf_max = max(ARES_time_projection_max(1, ARES_time_projection_max(1,:)<inf));
    ARES_film_info.noninf_avg = mean(ARES_time_projection_avg(1, ARES_time_projection_avg(1,:)<inf));
end
ARES_film_info.ARES_time_axis_projection_avg = ARES_time_projection_avg;
ARES_film_info.ARES_time_axis_projection_max = ARES_time_projection_max;
ARES_film_info.ARES_time_axis_projection_min = ARES_time_projection_min;
ARES_film_info.ARES_time_axis_projection_avg_noninf = ARES_time_projection_avg_noninf;
ARES_film_info.ARES_time_axis_projection_max_noninf = ARES_time_projection_max_noninf;
ARES_film_info.ARES_time_axis_projection_min_noninf = ARES_time_projection_min_noninf;
ARES_film_info.counter_inf_res_array = counter_inf_res_array;
ARES_film_info.counter_nan_res_array = counter_nan_res_array;
ARES_film_info.ROI_mask = selected_ROI;
ARES_film_info.number_of_pixels_in_ROI = number_of_pixels_in_ROI;
ARES_film_info.raw_imgs_projection_type = images_stack_info.stack_projection_type;
ARES_film_info.raw_imgs_projection = images_stack_info.stack_projection;
ARES_film_info.raw_imgs_projection_info = images_stack_info.stack_proj_info;
ARES_film_info.tag_array = tag_array;
ARES_film_info.type_of_window_used = window_type;
if strcmp (window_type, 'gaussian')
    ARES_film_info.window_g_std = window_g_std;
end
ARES_film_info.length_of_window_used = window_length;
ARES_film_info.step_of_window_advance = window_advance_step;
ARES_film_info.computation_time = computation_time;
ARES_film_info.computation_time_per_frame = computation_time_per_frame;

fprintf('It is advised to save the output to avoid having to redo the computations!\n');


end
