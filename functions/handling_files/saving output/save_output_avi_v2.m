function save_output_avi_v2 (ARES_film, ARES_film_info, ElectroData_Whole_TS, options, user_selected_projection)
% This function saves an images stack loaded in MATLAB (a 3d matrix) into a
% .avi film. The area not included in the ROI can be either of a different
% colour than the ROI area (also black), or it can be occupied by a
% projection. The latter will be the one used in the ROI production, or it
% can be given manually by the user.

if nargin >= 5
    if ~isempty(user_selected_projection)
        ARES_film_info.raw_imgs_projection = user_selected_projection;
    end
end
if nargin < 4 || isempty(options)
    options.avi_background_static_image = 1;
end


%% Initialize.
ARES_film_info.FLAG_normalize_avi_output = options.FLAG_normalize_avi_output;
overlay_ROI = ARES_film_info.ROI_mask;
number_of_frames = ARES_film_info.number_of_frames;
fprintf ('\nWriting output as .avi film...\n...\n');

if options.overlay_EPhys == 1
    E_Phys = ElectroData_Whole_TS.EPhys;
    E_Phys_time = ElectroData_Whole_TS.time;
end


%% File names.
% Making file extention.
extention_mat = '.mat';
% Making file names.
if options.FLAG_user_ask_file_name == 1
    ARES_film_file_name_tmp = options.output_FileName;
else
    ARES_film_file_name_tmp = sprintf('AR_%sResFilm', ARES_film_info.residuals_mode);
    ARES_film_file_name_tmp = sprintf('%s_%s', ARES_film_info.original_stack_FileName, ARES_film_file_name_tmp);
end
ARES_film_file_name_info_tmp = sprintf('%s_info', ARES_film_file_name_tmp);
ARES_film_file_name_info = strcat(ARES_film_file_name_info_tmp, extention_mat);
video_name = ARES_film_file_name_tmp;
video_profile = 'Uncompressed AVI'; % 'Uncompressed AVI' or 'Indexed AVI'


%% Prepare .avi 
% Initialize and open video object.
analysed_colour_video_obj = VideoWriter(video_name, video_profile);
open(analysed_colour_video_obj);
fig_tmp = figure;

if options.avi_background_static_image == 1
    % Create a figure and 2 axes.
    axis_1 = axes('Parent', fig_tmp);
    axis_2 = axes('Parent', fig_tmp);

    % Hide the axes
    set(axis_1,'Visible','off');
    set(axis_2,'Visible','off');
    % Background image.
    raw_projection = ARES_film_info.raw_imgs_projection;
    raw_projection = raw_projection./nanmax(nanmax(raw_projection));
    img_background = imshow(raw_projection,'Parent',axis_1);
end

% Create E-Phys axis, if required.
if options.overlay_EPhys == 1
    axis_3 = axes('Parent', fig_tmp);
    axis_3.Position = [0.65 0.1 0.3 0.2];% [left bottom width height];
%     set(axis_3,'Visible','off');
    E_Phys_time_resolution = E_Phys_time(2) - E_Phys_time(1);
    E_Phys_length_per_frame = double(int32(numel(E_Phys_time)/number_of_frames));
end

%% Write every frame.
for i_frame = 1:number_of_frames
    current_frame = ARES_film(:,:,i_frame);
    if options.FLAG_normalize_avi_output == 1
        current_max = ARES_film_info.ARES_time_axis_projection_max_noninf(1,i_frame);
        current_min = ARES_film_info.ARES_time_axis_projection_min_noninf(1,i_frame);
        current_frame = (current_frame - current_min)./(current_max - current_min);
    end
    if options.overlay_EPhys == 1
        current_start = 1 + (E_Phys_length_per_frame*(i_frame - 1));
        current_end = E_Phys_length_per_frame*(i_frame);
        E_Phys_current_segment = E_Phys(current_start:current_end, 1);
        E_Phys_current_time = E_Phys_time(current_start:current_end, 1);
    end
    imagesc(current_frame);
    C = imfuse(current_frame, raw_projection, 'falsecolor','Scaling','independent','ColorChannels',[1 1 2]);
    if options.avi_background_static_image == 1
        img_actual = imshow(C, 'Parent', axis_2, 'InitialMagnification', 'fit');
        plot(E_Phys_current_time, E_Phys_current_segment, 'r')

        truesize;
        % Set transparency
        set(img_background,'AlphaData', 1);
        set(img_actual,'AlphaData', 0.25); % 0.5
    else
        imshow(C, 'InitialMagnification', 'fit');
        truesize;
    end
    % Write Frame
    frame = getframe;
    writeVideo(analysed_colour_video_obj, frame);
end

% Finalize and close video object.
close(analysed_colour_video_obj);
close % Close the figure used to produce the film.

% Save info file.
save(ARES_film_file_name_info, 'ARES_film_info');

fprintf('\nFilm saved successfully in .avi format.\n\n')

end