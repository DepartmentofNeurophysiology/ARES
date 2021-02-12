function movie_info = get_movie_info (movie_filename)
% This function gets a .avi movie and returns the required info structure
% to convert it into a .tif stack.
% INPUT:
%   movie_filename: is a string containing the name of the avi or mov file
%   to be converted in tif. Example: 'recordings.avi'.
% OUTPUT: 
%   movie_info: is a struct containing the number of frames, the file name,
%   the file extention, and the movie object variable, used later
%   for the conversion into tif.

movie_info_obj = VideoReader(movie_filename);
movie_frames_number = double(int16((movie_info_obj.FrameRate)*(movie_info_obj.Duration)));
movie_info_obj = VideoReader(movie_filename);       % For some reason this repeat is necessary or in some versions it might bug.
[~, movie_info.Name_NoExtension, movie_info.Extensions] = fileparts(movie_filename);
movie_info.NumberOfFrames = movie_frames_number;
movie_info.movie_info_obj = movie_info_obj;

end
