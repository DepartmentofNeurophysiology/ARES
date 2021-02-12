function img = get_img_series_info (img_directory, main_program_directory)
% Get info about image series.
% INPUT:
% - img_directory: the directory where the images are located.
% - main_program_directory: the main directory of the toolbox.
% OUTPUT: 
% - img: a structure file containing multiple generic infos about the
% image files; it is required for several other computations made by the
% toolbox.
% NOTE: it accepts only files in .tif format; please make sure that in the
% folder indicated as containing the images, does NOT contain unwanted
% images.

if strcmpi(img_directory, main_program_directory) == 0
    cd(img_directory);
    img.files = dir('*.tif');
    img.files_number = numel(img.files);
    img.info = imfinfo(img.files(1).name);
    img.dimensions = [img.info.Height, img.info.Width];
    cd (main_program_directory);
else
    img.files = dir('*.tif');
    img.files_number = numel(img.files);
    img.info = imfinfo(img.files(1).name);
    img.dimensions = [img.info.Height, img.info.Width];
end

img.img_directory = img_directory;
end
