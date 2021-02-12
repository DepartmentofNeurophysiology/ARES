function [img_stack_projection, img_stack_proj_info] = compute_img_stack_projection(images_stack, projection_type)
% This function computes one between the pixelwise average\max\min of the
% images stack.
% INPUTs:  
%   - images_stack
%   - projection_type: it's a string that can be either 'avg', 'max',
%   'min'; it indicates which kind of projection is to be computed.
% OUTPUTs:
%   - img_stack_projection
%   - img_stack_proj_info
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %

%% ~~~ Checking inputs and declaring variables ~~~ %%
switch nargin
    case 1
    case 2
        projection_type = 'avg';
    otherwise
        error('Wrong number of inputs, check function INPUT section for more info.\n');
end

[image_Height, image_Width, number_of_frames] = size (images_stack);


%% ~~~ Computing the projection ~~~ %%
img_projection_tmp = images_stack(:,:,1);
img_projection_tmp = double(img_projection_tmp);
switch projection_type
    case 'avg'
        for i_frame = 2:number_of_frames
            current_image = images_stack(:,:,i_frame);
            img_projection_tmp = img_projection_tmp + double(current_image);
        end
        img_stack_projection = img_projection_tmp./number_of_frames;
    case 'max'
        for i_frame = 2:number_of_frames
            current_image = images_stack(:,:,i_frame);
            for i_pixel = 1:image_Height  % for each pixel...
                for j_pixel = 1:image_Width     % for each pixel...
                    if (current_image(i_pixel, j_pixel) > img_projection_tmp(i_pixel, j_pixel))   % consider the greatest
                        img_projection_tmp(i_pixel, j_pixel) = current_image(i_pixel, j_pixel);
                    end
                end
            end
        end
        img_stack_projection = double(img_projection_tmp);
    case 'min'
        for i_frame = 2:number_of_frames
            current_image = images_stack(:,:,i_frame);
            for i_pixel = 1:image_Height  % for each pixel...
                for j_pixel = 1:image_Width     % for each pixel...
                    if (current_image(i_pixel, j_pixel) < img_projection_tmp(i_pixel, j_pixel))   % consider the greatest
                        img_projection_tmp(i_pixel, j_pixel) = current_image(i_pixel, j_pixel);
                    end
                end
            end
        end
        img_stack_projection = double(img_projection_tmp);
    otherwise
        error(['The 3rd input variable (projection_type) must be ', ... ,
            'a string with values either "avg", "max", "min".']);
end
% number_of_pixels_in_image = numel(img_stack_projection);
% img_stack_proj_vect = reshape (img_stack_projection, 1, number_of_pixels_in_image);
% [number_of_elements_per_bin, bin_locations] = hist(img_stack_proj_vect, int16(number_of_pixels_in_image/100));
% bar(bin_locations, number_of_elements_per_bin);

%% ~~~ Making info file ~~~ %%
img_stack_proj_info.type = projection_type;
img_stack_proj_info.std = std2(double(img_stack_projection));
img_stack_proj_info.min = min(min(double(img_stack_projection)));
img_stack_proj_info.max = max(max(double(img_stack_projection)));
img_stack_proj_info.avg = mean(mean(double(img_stack_projection)));

return
end