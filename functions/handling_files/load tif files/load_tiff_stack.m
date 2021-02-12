function [images_stack, images_info] = load_tiff_stack (file_name)
% Use to load an entire stack from a single tif file.
% NOTE: use function "convert_tif_images_to_stack.m" to convert 
% a series of tif images into a single file, or get_movie_info and then 
% movie_to_frames_tif to convert from a .avi film.
% INPUT: 
%   - file_name: the file name of the stack to load in the workspace
% OUTPUT:
%   - image_stack: the loaded tiff stack; 
%   - images_info: a struct containing the info on the stack;

disp(strcat(file_name, ' was selected.'));
fprintf('...\n...\nLoading tif stack in MATLAB, please wait...\n...\n');
images_info = imfinfo(file_name);
images_width = images_info(1).Width;
images_height = images_info(1).Height;
images_number = numel(images_info);
images_stack = zeros(images_height, images_width, images_number, 'uint16');

pause (0.25);

TifLink = Tiff(file_name, 'r');
for i_image=1:images_number
   TifLink.setDirectory(i_image);
   images_stack(:,:,i_image)=TifLink.read();
end

TifLink.close();
fprintf('File loaded in the Workspace.\n\n');

end