function [tag_array, tag_fig_handle, images_stack, images_stack_info] = remove_interpolate_frames_guided (images_stack, images_stack_info, options)
% This is the main function that groups the pre processing part regarding 
% the removal or interpolation of un-necessary frames.
% It is necessary for the Guided User Interaction.

FLAG_remove_external_frames = options.FLAG_remove_external_frames;
FLAG_Remove_Intertrial = options.FLAG_Remove_Intertrial;


%% Tag intertrial frames.
[tag_array, tag_fig_handle, time_axis_avg_projection, ~] = tag_stim_non_stim_frames (images_stack, images_stack_info, 1, 0);
images_stack_info.time_axis_avg_projection = time_axis_avg_projection;


%% Remove external frames.
if strcmpi(FLAG_remove_external_frames, 'User') == 1
    [~, ~, frame_start, frame_end] = external_frames (images_stack, tag_array, 0);
    prompt = {'First frame to consider:','Last frame to consider:'};
    user_answer = inputdlg(prompt,'Input', 1, {num2str(frame_start), num2str(frame_end)});
    first_frame = str2double(user_answer{1,1});
    last_frame = str2double(user_answer{2,1});
    if last_frame - first_frame < options.opts_ARES_film.window_length
        error ('Insufficient number of frames for analysis. Include more frames or reduce window size.')
    end
    images_stack = images_stack(:,:, first_frame:last_frame);
    external_frames_removed = images_stack_info.number_of_frames - (last_frame - first_frame);
    images_stack_info.number_of_frames = last_frame - first_frame + 1;
    images_stack_info.external_frames_removed = external_frames_removed;
    fprintf('%d external frames, selected by user, were removed.\n\n', external_frames_removed);
elseif strcmpi(FLAG_remove_external_frames, 'Auto') == 1
    [images_stack, external_frames_removed, first_frame, last_frame] = external_frames (images_stack, tag_array, 1);
    images_stack_info.external_frames_removed = external_frames_removed;
    images_stack_info.number_of_frames = last_frame - first_frame + 1;
    fprintf('%d external frames were removed automatically.\n\n', external_frames_removed);
elseif strcmpi(FLAG_remove_external_frames, 'None') == 1
    first_frame = 1;
else
    error ('FLAG_remove_external_frames must be either "User", "Auto", or "None".')
end
images_stack_info.first_frame = first_frame;
if ishandle(tag_fig_handle); close(tag_fig_handle); clear tag_fig_handle; end;


%% Remove Inter Trial frames.
if strcmpi(FLAG_Remove_Intertrial, 'Auto') == 1
    % Re-Tag frames, with User Interface.
    [tag_array, tag_fig_handle, time_axis_avg_projection, tag_threshold_up] = tag_stim_non_stim_frames (images_stack, images_stack_info, 1, 1, [], options);
    images_stack_info.time_axis_avg_projection = time_axis_avg_projection;
    % Frames removal.
    [images_stack, images_stack_info, number_of_removed_frames] = intertrial_down_frames (images_stack, tag_array, images_stack_info, options);
    images_stack_info.intertrial_frames_removed = number_of_removed_frames;
    % Re-Tag frames.
    close(tag_fig_handle);
    [tag_array, tag_fig_handle, time_axis_avg_projection, ~] = tag_stim_non_stim_frames (images_stack, images_stack_info, 1, 0, tag_threshold_up, options);
    images_stack_info.time_axis_avg_projection = time_axis_avg_projection;
elseif strcmpi(FLAG_Remove_Intertrial, 'None') == 1
    % Re-Tag frames, without intertrial removal.
    [tag_array, tag_fig_handle, time_axis_avg_projection, ~] = tag_stim_non_stim_frames (images_stack, images_stack_info, 1, 0, [], options);
    images_stack_info.time_axis_avg_projection = time_axis_avg_projection;
else
    error('Wrong value for the option "FLAG_Remove_Intertrial".')
end
images_stack_info.FLAG_Remove_Intertrial = FLAG_Remove_Intertrial;


%% Remove short intertrial and intersweep intervals?

% Tag intersweep frames using derivative.
starting_derivative_modifier = options.tag_derivative_threshold_modifier;
darkness_max_length = options.tag_darkness_max_length; % Maximum consecutive dark frames to be interpolated in the 2nd interpolation run (derivative based).;
[tag_dark] = tag_dark_frames_derivative_GUI (images_stack_info, starting_derivative_modifier, darkness_max_length);

string_tmp = 'Do you want to remove or interpolate the frames tagged as with no stimulation?';
window_title = 'How to deal with the remaining non-stimulation frames?';
RemoveOrInterpolate = questdlg(string_tmp, window_title, 'Remove', 'Interpolate', 'Ignore', 'Ignore');
% if ishandle(tag_fig_handle); close tag_fig_handle; clear tag_fig_handle; end;

% Handle tagged frames.
switch RemoveOrInterpolate
    case 'Remove'
        % Remove tagged frames from images_stack and update stack infos.
        tag_dark = - tag_dark; % Make it negative.
        [images_stack, images_stack_info] = remove_tagged_frames (images_stack, images_stack_info, tag_dark);
        number_of_frames_removed = numel(tag_array) - images_stack_info.number_of_frames;
        tag_array = ones(1, images_stack_info.number_of_frames); % Every remaining frame will be considered.
        fprintf('\n%d remaining frames removed.\n', number_of_frames_removed);
    case 'Interpolate'
        % Interpolate tagged frames with mean of their neighbours, and update stack infos.
        tag_dark = - tag_dark; % Make it negative.
        [images_stack, counter_interpolated_frames] = interpolate_frames (images_stack, images_stack_info, tag_dark, options);
        fprintf('%d frames interpolated.\n\n', counter_interpolated_frames);
        tag_array = ones(1, images_stack_info.number_of_frames);
    case 'Ignore'
        % Ignore tagged frames.
        tag_array = ones(1, images_stack_info.number_of_frames);
        fprintf('\nTag array set to consider all frames.\n');
    otherwise
        error('Something went wrong with the user selecting what to do with tagged frames.');
end
[~, ~, time_axis_avg_projection, ~] = tag_stim_non_stim_frames (images_stack, images_stack_info, 0, 0);
images_stack_info.time_axis_avg_projection = time_axis_avg_projection;

% Check that a minimum number of frames is present.
if images_stack_info.number_of_frames < options.opts_ARES_film.window_length
    error ('Insufficient number of frames for analysis. Include more frames or reduce window size.')
end

% Close all previous figures.
close all

% Plot the Average Projection.
if strcmpi(RemoveOrInterpolate, 'Remove') == 1 || strcmpi(RemoveOrInterpolate, 'Interpolate') == 1
    tag_fig_handle = figure();
    plot(time_axis_avg_projection);
    ylim([-inf, inf]);
    xlim([-inf, images_stack_info.number_of_frames]);
    grid on;
    box on;
    h_legend = legend ('Time Axis Projection');
    set(h_legend, 'Location', 'BestOutside');
    xlabel ('Frames'); ylabel('Avg luminance per frame'); title('Average Luminance per Frame.');
end

images_stack_info.FLAG_RemoveOrInterpolate = RemoveOrInterpolate;

end