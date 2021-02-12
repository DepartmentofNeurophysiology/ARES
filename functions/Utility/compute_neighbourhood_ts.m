function neighbourhood_TS = compute_neighbourhood_ts(images_stack, selected_ROI, current_pixel, opts_neighbourhood_ts)
% This function takes the neighbourhood of the selected pixel, and computes
% the average time series of the neighbourhood.
%
% NOTE about excluding non-ROI pixels:
% In case the user choses to exclude the non-ROI pixels from the 
% neighbourhoods, then the pixels at the ROI border will be undersampled
% respect to the others.
%
% Excluding non-ROI pixels is suggested in case the user wants to use a 
% large neighbourhood (high neighbourhood_order), or the diffraction is 
% believed to be very small.
% The use of the neighbourhood instead of the single pixel is infact based
% on the assumtion that due to light diffusion phenomena, neighbouring
% pixels will have correlated time courses.

neighbourhood_order = opts_neighbourhood_ts.neighbourhood_order;
FLAG_ignore_outside_ROI = opts_neighbourhood_ts.FLAG_ignore_outside_ROI;

[image_Height, image_Width, ~] = size(images_stack);
i_pixel = current_pixel(1, 1);
j_pixel = current_pixel(1, 2);

number_of_neighbour_pixels_tmp = ((neighbourhood_order*2) + 1)^2;
% Get the average time series of the neighbourhood of the selected pixel.
neighbourhood_TS(:) = double(images_stack(i_pixel, j_pixel, 1:end));
for i = -neighbourhood_order:1:neighbourhood_order
    for j = -neighbourhood_order:1:neighbourhood_order
        if (i_pixel + i > 0) && (i_pixel + i < image_Height) && (j_pixel + j > 0) && (j_pixel + j < image_Width)
            if FLAG_ignore_outside_ROI == 1 % Only if the user wants to ignore the pixels outside the ROI.
                if (selected_ROI(i_pixel + i, j_pixel + j) == 1) % Use only ROI pixels.
                    current_neighbour_TS(:) = double(images_stack(i_pixel + i, j_pixel + j, 1:end));
                    neighbourhood_TS = neighbourhood_TS + current_neighbour_TS;
                else
                    number_of_neighbour_pixels_tmp = number_of_neighbour_pixels_tmp - 1;
                end
            else % If the user wants to user the pixels outside the ROI.
                current_neighbour_TS(:) = double(images_stack(i_pixel + i, j_pixel + j, 1:end));
                neighbourhood_TS = neighbourhood_TS + current_neighbour_TS;
            end
        end
    end
end
neighbourhood_TS = neighbourhood_TS./number_of_neighbour_pixels_tmp;
