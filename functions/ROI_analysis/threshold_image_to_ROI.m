function [ ROI_image, ROI_image_info ] = threshold_image_to_ROI (image_to_threshold, std_multiplier)
% This function will create an ROI from an image and the mean and standard
% deviation of its pixel values.
% 
% ~~~ INPUT VARIABLES ~~~ %
% 
% - "image_to_threshold", the image to which the threshold will be applied
% to compute the ROI. Usually it's some sort of projection, but any image
% would do.
%  - "std_multiplier", the threshold is computed as
%  std_multiplier*standard_deviation of the pixel values in the image.

%% Check input and declare variables
if nargin < 1 || nargin > 2
    error('Wrong number of inputs, check function INPUT section for more info.');
end

if nargin < 2
    std_multiplier = 1;
end

[img_Height, img_Width] = size(image_to_threshold);

img_std = std(std(double(image_to_threshold)));
img_mean = mean(mean(double(image_to_threshold)));
img_min = min(min(double(image_to_threshold)));
img_max = max(max(double(image_to_threshold)));

number_of_pixels_in_image = img_Height * img_Width;
threshold_value = std_multiplier * img_std;

%% Compute ROI from threshold
ROI_image = zeros(img_Height, img_Width);
number_of_pixels_in_ROI = 0;
for i_pixel = 1:img_Height
    for j_pixel = 1:img_Width
        if (image_to_threshold(i_pixel, j_pixel) >= img_mean + threshold_value);
            ROI_image(i_pixel, j_pixel) = 1;
            number_of_pixels_in_ROI = number_of_pixels_in_ROI + 1;
        end
    end
end
percentage_of_image_selected = number_of_pixels_in_ROI*100/number_of_pixels_in_image;

%% Make info variable
ROI_image_info.number_of_pixels_in_ROI = number_of_pixels_in_ROI;
ROI_image_info.percentage_of_image_selected = percentage_of_image_selected;
end

