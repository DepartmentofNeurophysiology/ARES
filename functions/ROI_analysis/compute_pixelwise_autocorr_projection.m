function [pixelwise_autocorr_projection, pixelwise_autocorr_projection_info] = compute_pixelwise_autocorr_projection (images_stack, images_stack_info, projection_type, tag_array, opts_autocorr_matrix_on_stack)
% This function computes the pixelwise Autocorrelation frame projection 
% avg/max/min over the entire stack.
% The element ij is the average/max/min value of the autocorrelation 
% vector, computed on the time series of the pixel ij of the image stack.
% INPUTs: 
% - The image_stack: 3D (Height:Width:frame) matrix of int or double.
% - The images_stack_info: struct, containing the infos on the image_stack.
% - (Optional) projection_type: string which can be either
%   'avg','max','min'. It determines if the output image would be the avg,
%   max or min projection of the autocorrelation vector.
% - (Optional) tag_array is a logic array where frames to exclude are 
%   tagged with 0, and frames to include with 1. If not specified, 
%   every frame will be marked with 1.
% - (Optional) opts_autocorr_matrix_on_stack is a struct containing 
%              the following variable: 
%              - number_of_lags indicates the intervals used to compute 
%                the autocorrelation (see NOTES for more info)
% DEFAULT VALUES are: 
% what_to_compute = 'avg';
% number_of_lags = number_of_frames - 1;
% NOTE: 
% - Setting number_of_lags = 1 would produce as output the pixelwise
%   autocorrelation between the entire stack.
% - Setting number_of_lags = number_of_frames - 1 would produce as
%   output the average/max/min pixelwise autocorrelation between 
%   consecutive frames.


%% Initialization & input check.
number_of_frames = images_stack_info.number_of_frames;
image_Height = images_stack_info.Height;
image_Width = images_stack_info.Width;

% Input check.
assert((nargin <= 5) && (nargin >= 2), 'Wrong number of inputs, check function INPUT section for more info. \n')

if nargin < 5
    number_of_lags = number_of_frames - 1;
    fprintf('Default loaded: Computing the selected projection of the pixelwise autocorrelation between consecutive frames.\n');
else % In case user specified a number of lags, use it.
    number_of_lags = opts_autocorr_matrix_on_stack.number_of_lags;
end

% If there is no tag array, create one with all elements = 1.
if nargin < 4
    tag_array = ones(1, number_of_frames);
    fprintf('Default loaded: All frames will be considered.\n');
else
    if isempty(tag_array)
        tag_array = ones(1, number_of_frames);
        fprintf('Default loaded: All frames will be considered.\n');    
    end
end

if nargin < 3
    projection_type = 'avg';
    fprintf('Default loaded: Computing the average projection of pixelwise autocorrelation.\n');
else
    if isempty(projection_type)
        projection_type = 'avg';
        fprintf('Default loaded: Computing the average projection of pixelwise autocorrelation.\n');
    end
end

if (number_of_lags == (number_of_frames - 1))
    fprintf('\nComputing the selected projection of the pixelwise autocorrelation between consecutive frames.\nTagged frames will be skipped.\n...\n');
end


% Computing number of frames to skip (skip the one tagged -1)
number_of_frames_skipped = 0;
for i_image = 1:number_of_frames
    if ((tag_array(1, i_image)) == -1)
        number_of_frames_skipped = number_of_frames_skipped + 1;
    end
end
% Adjust the number of lags according to the number of frames skipped.
number_of_lags = number_of_lags - number_of_frames_skipped;


%%  Computing autocorrelation projection
pixelwise_autocorr_projection = zeros(image_Height, image_Width);
current_pixel_time_series = zeros(1, number_of_frames - number_of_frames_skipped);

tic
for i_pixel = 1:image_Height
    for j_pixel = 1:image_Width
        for i_image = 1:number_of_frames
            if (tag_array(1, i_image) == 1)
                % Get current pixel time series
                current_pixel_time_series(1, i_image) = images_stack(i_pixel, j_pixel, i_image);
            end
        end
        A_corr_temp = autocorr (current_pixel_time_series, number_of_lags);
        A_corr_temp(1, 1) = NaN;
        switch projection_type
            case 'avg'
                A_corr_avg_temp = nanmean(A_corr_temp);
            case 'max'
                A_corr_avg_temp = nanmax(A_corr_temp);
            case 'min'
                A_corr_avg_temp = nanmin(A_corr_temp);
        end
        pixelwise_autocorr_projection(i_pixel, j_pixel) = A_corr_avg_temp;
    end
end
delete(prog_bar);
computation_time = toc;
fprintf('Time elapsed: %f seconds.\n\n', computation_time);


%% Computing info file.
pixelwise_autocorr_projection_info.projection_type = projection_type;
pixelwise_autocorr_projection_info.std = std2(pixelwise_autocorr_projection);
pixelwise_autocorr_projection_info.avg = mean(mean(pixelwise_autocorr_projection));
pixelwise_autocorr_projection_info.max = max(max(pixelwise_autocorr_projection));
pixelwise_autocorr_projection_info.min = min(min(pixelwise_autocorr_projection));

end
