function display_image_grayscale (image_to_display)
% DISPLAY_IMAGE Summary of this function goes here
%   Detailed explanation goes here
% Print image
image_to_display = double(image_to_display);
cmin = min(min(image_to_display));
cmax = max(max(image_to_display));
figure(); 
clf; 
imshow(image_to_display);
caxis([cmin cmax]); 
colorbar;
return
end

