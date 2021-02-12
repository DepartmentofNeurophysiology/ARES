function img_thresholded = threshold_background_to_zero (input_image, threshold_value)
% This function takes an image and sets every pixel P, which value is below
% a threshold, to P = 0.

[Heigth, Width] = size(input_image);

img_thresholded = input_image;
for i_pixel = 1:Heigth
    for j_pixel = 1:Width
        if (input_image(i_pixel, j_pixel) < threshold_value)
            img_thresholded(i_pixel, j_pixel) = 0;
        end
    end
end

end