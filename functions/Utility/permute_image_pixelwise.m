function image_permuted = permute_image_pixelwise( image_to_permute )
% This function randomly permutes an image, pixelwise


[img_Height, img_Width] = size(image_to_permute);
number_of_pixels = img_Height*img_Width;
image_permuted = image_to_permute;
reshape(image_permuted, [1, number_of_pixels]);

for i = 1:20
    image_permuted = image_permuted(randperm(number_of_pixels));
end
image_permuted = reshape(image_permuted, [img_Height, img_Width]);

end

