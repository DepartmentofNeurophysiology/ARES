function [ARES_background] = compute_ARES_background_matrixwise (images_stack, images_stack_info, selected_ROI, tag_array, opts_ARES_film)
% Compute pixelwise Autoregression Residuals Film.
% This function computes the background for the ARES signal. 
% For more information on ARES, check "compute_ARES_film_matrixwise".
% The background ARES time series is computed by selecting a random sample
% of pixels from outside the ROI, computing ARES for each of them, then
% taking the average time series.

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

% Checking inputs and loading defaults.
if (nargin < 5) || isempty(opts_ARES_film)
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
    fprintf('Default options loaded: Check function INPUT section for more info.\n\n');
end
if (nargin < 4) || isempty(tag_array) % In this case, generate a tag_array = 1.
    fprintf('Tag array missing. Will use every frame. Check function INPUT section for more info.\n\n');
    tag_array = ones(1, number_of_frames);
end
if (nargin < 3) || isempty(selected_ROI) % In this case, generate a ROI = 1.
    fprintf('ROI matrix missing. Will use every pixel. Check function INPUT section for more info.\n\n');
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


%% ~~~ Computing Averge Regression Residuals film ~~~ %%

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
ARES_time_projection_avg = zeros(1, film_length);
ARES_time_projection_max = zeros(1, film_length);
ARES_time_projection_min = zeros(1, film_length);
ARES_time_projection_avg_noninf = zeros(1, film_length);
ARES_time_projection_std_noninf = zeros(1, film_length);
ARES_time_projection_max_noninf = zeros(1, film_length);
ARES_time_projection_min_noninf = zeros(1, film_length);
counter_inf_res_array = zeros(1, film_length);
counter_nan_res_array = zeros(1, film_length);
current_pixel_time_series = zeros (1, window_length); % This initialization is needed for versions of matlab older than 2015a
current_time_series_matrix = zeros (matrix_dimension, window_length);
matrix_to_pixel_correspondence = cell(matrix_dimension, 1);

% Initializing waitbar.
prog_bar = waitbar(0, 'Cylon virus detected!', 'Name', 'Computing Autoregression Background...',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(prog_bar, 'canceling', 0);

counter_frame = 1;
tic
for i_image = 1:window_advance_step:(number_of_frames - window_length)
    counter_inf_res = 0; % Counter for infinite value in current frame
    counter_nan_res = 0; % Counter for NaN value in current frame
    i_pixel = 1;
    j_pixel = 1;
    % Increasing the index until only activity frames are considered.
    if (tag_array(1, i_image) == 1 && tag_array(1, i_image + window_length) == 1)
        
        % Update waitbar
        waitbar(counter_frame/film_length, prog_bar, sprintf('Computing Background Frame: %d / %d', counter_frame, film_length));
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
                        current_pixel_time_series(:) = double(images_stack(i_pixel, j_pixel, i_image:(i_image + window_length - 1)));
                        current_pixel_time_series = current_pixel_time_series.*window_used;
                        current_time_series_matrix(pixel_counter, :) = current_pixel_time_series;
                        matrix_to_pixel_correspondence{pixel_counter, 1} = [i_pixel, j_pixel];
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
                Residuals = AutoRegress_TS_residuals (current_time_series_matrix(pixel_counter, :), process_order, FLAG_demean, reg_mode);
                % Reassorting Residuals to correspondent pixels
                current_pixel = matrix_to_pixel_correspondence{pixel_counter, 1};
                if absolute_value == 1
                    current_pixel_res = abs(Residuals); %(pixel_counter, :); % commented part was for matrix wise use
                elseif absolute_value == 0
                    current_pixel_res = Residuals; %(pixel_counter, :); % commented part was for matrix wise use
                else
                    error ('absolute_value option must be either 0 or 1.');
                end
                if strcmpi(residuals_mode, 'avg') == 1
                    current_pixel_res_proj = nanmean(current_pixel_res(1, current_pixel_res(1,:)<inf));
                elseif strcmpi(residuals_mode, 'max') == 1
                    current_pixel_res_proj = nanmax(current_pixel_res(1, current_pixel_res(1,:)<inf));
                else
                    error ('residuals_mode must be either "max" or "avg".');
                end
                ARES_img(current_pixel(1,1), current_pixel(1,2)) = current_pixel_res_proj;
                mean_res = mean(current_pixel_res);
                if isinf(mean_res)
                    counter_inf_res = counter_inf_res + 1;
                elseif isnan(mean_res)
                    counter_nan_res = counter_nan_res + 1;
                end
            end
            AR_matrix_counter = AR_matrix_counter + 1;
        end
        
        % Computing projections.
        ARES_img_tmp = nonzeros(ARES_img);
        ARES_time_projection_avg(1, counter_frame) = nanmean(ARES_img_tmp);
        ARES_time_projection_max(1, counter_frame) = nanmax(ARES_img_tmp);
        ARES_time_projection_min(1, counter_frame) = nanmin(ARES_img_tmp);
        ARES_img_tmp = reshape(ARES_img_tmp, [1, numel(ARES_img_tmp)]);
        ARES_time_projection_avg_noninf(1, counter_frame) = nanmean(ARES_img_tmp(1, ARES_img_tmp(1,:)<inf));
        ARES_time_projection_std_noninf(1, counter_frame) = nanstd(ARES_img_tmp(1, ARES_img_tmp(1,:)<inf));
        ARES_time_projection_max_noninf(1, counter_frame) = nanmax(ARES_img_tmp(1, ARES_img_tmp(1,:)<inf));
        ARES_time_projection_min_noninf(1, counter_frame) = nanmin(ARES_img_tmp(1, ARES_img_tmp(1,:)<inf));
        % Count infinities or nan values per frame.
        counter_inf_res_array(1, counter_frame) = counter_inf_res;
        counter_nan_res_array(1, counter_frame) = counter_nan_res;
        % Update frame counter.
        counter_frame = counter_frame + 1;
        
    end
end
computation_time = toc;
computation_time_per_frame = computation_time/film_length;
delete(prog_bar);
fprintf('Time elapsed: %f seconds.\n\n', computation_time);


%% Making info structure
ARES_background.avg_time_projection = ARES_time_projection_avg_noninf;
ARES_background.std_time_projection = ARES_time_projection_std_noninf;
ARES_background.max_time_projection = ARES_time_projection_max_noninf;
ARES_background.min_time_projection = ARES_time_projection_min_noninf;
ARES_background.background_ROI = selected_ROI;
ARES_background.noninf_avg = mean(ARES_time_projection_avg_noninf);
ARES_background.noninf_max = max(ARES_time_projection_max_noninf);
ARES_background.noninf_min = min(ARES_time_projection_min_noninf);

end
