function [selected_background_ROI] = select_random_background_sample (images_stack_info, selected_ROI, options)
% This function selects a number of random pixels from outside the ROI,
% and gives as an output a new binary ROI image, where the selected pixels 
% have value = 1, and the rest is = 0.
% INPUTS:
% - "images_stack_info", a struct variable containing the infos about 
%   the image_stack. It is automatically produced by the toolbox when
%   loading or modifying the images_stack used.
% - "selected_ROI" is an ROI mask, that is, a 2D logic matrix:
%   the pixels corresponding to 0 in the ROI matrix will be ignored 
%   in the analysis.
% - "options": a struct containing the options for running the function.
%   it can be generated via the User Interface, or provided as input.
% OUTPUT:
% - "selected_background_ROI": a "background ROI", where a number of pixels
%   have been randomly selected from the background and were assigned a
%   value of 1.


%% Initializing.
if nargin < 3
    options.number_of_background_pixels = 500;
end
number_of_background_pixels =  options.number_of_background_pixels;
image_Height = images_stack_info.Height;
image_Width = images_stack_info.Width;
fprintf('Computing the background signal (using #%d pixels)...\n...\n', number_of_background_pixels)


%% Select background pixels
% Select N = number_of_background_pixels random pixels in the background.
FLAG_loop = 1;
counter_included_pixels = 0;    
selected_background_ROI = zeros(image_Height, image_Width);
while FLAG_loop == 1
    random_Heigth = randi([1, image_Height]);
    random_Width = randi([1, image_Width]);
    % If the pixel is outside of the ROI, and it has not been included  yet
    if selected_ROI(random_Heigth, random_Width) == 0 && selected_background_ROI(random_Heigth, random_Width) == 0
        selected_background_ROI(random_Heigth, random_Width) = 1;
        counter_included_pixels = counter_included_pixels + 1;
    end
    if counter_included_pixels == number_of_background_pixels
        selected_background_ROI = logical(selected_background_ROI);
        break
    end
end