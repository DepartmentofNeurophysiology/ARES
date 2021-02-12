function [ output_image ] = erode_ROI_border( input_image )
% This function will take a logic image (where pixels only have value of 0
% or 1), and set to zero every pixel whom first neighbour pixel is = 0.

% Algorithm works this way: in a first loop the pixels to be removed are
% identified (values set to 0.5). In a second loop the pixels tagged are
% actually set to 0.
% The two loops system is to avoid that setting a pixel = 0 in the first
% loop would trigger a cascade of pixels set to 0.

[Height, Width] = size(input_image);
tmp_image = double(input_image);
output_image = input_image;

%% Pixel check loop
for i_pixel = 2:(Height - 1)
    for j_pixel = 2:(Width - 1)
        if (input_image(i_pixel, j_pixel) == 1)
            if (input_image(i_pixel-1, j_pixel) == 0 || input_image(i_pixel+1, j_pixel) == 0 || input_image(i_pixel, j_pixel-1) == 0 || input_image(i_pixel, j_pixel+1) == 0)
                tmp_image(i_pixel, j_pixel) = 0.5;
            end
        end
    end
end

%% Pixel removal loop
for i_pixel = 1:Height
    for j_pixel = 1:Width
        if (tmp_image(i_pixel, j_pixel) == 0.5)
            output_image(i_pixel, j_pixel) = 0;
        end
    end
end

end

