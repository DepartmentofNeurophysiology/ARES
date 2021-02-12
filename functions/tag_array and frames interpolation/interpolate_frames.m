function [images_stack_output, counter_interpolated_frames] = interpolate_frames (images_stack, images_stack_info, tag_dark, options)
% This function interpolates missing frames (frames that have been tagged
% with 0 in the tag_array), with an average between its 2 closest
% neighbouring frames.

if nargin < 3
    options.number_of_interpolation_cycles = 4;
end


%% Declaring basic image stack related variables.
number_of_frames = images_stack_info.number_of_frames;
image_Height = images_stack_info.Height;
image_Width = images_stack_info.Width;
number_of_interpolation_cycles = options.number_of_interpolation_cycles;


%% Interpolate dark frames via derivative identification
fprintf('Interpolating remaining dark frames...\n...\n');
% Initializing output.
FLAG_plot = 0;
images_stack_output = images_stack;
images_stack_info_output = images_stack_info;
counter_interpolated_frames = 0;

% Initialize waitbar
prog_bar = waitbar(0, 'Interpolating Frames... 0%', 'Name', 'Interpolating Frames...',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(prog_bar, 'canceling', 0);

% Repeat the interpolation as previously.
% while any(tag_dark < 0) == 1
for i_cycle = 1:number_of_interpolation_cycles
    % Main loop.
    for i_frame = 1:number_of_frames
        if tag_dark(1, i_frame) ~= 0
            counter_interpolated_frames = counter_interpolated_frames + 1;
            % Find first precedent good frame.
            precedent_good_frame = [];
            for j_frame = (i_frame-1):-1:1
                if tag_dark(1, j_frame) == 0
                    precedent_good_frame = images_stack_output(:,:, j_frame);
                    break
                end
            end
            precedent_good_frame = double(precedent_good_frame);
            % Find first following good frame.
            following_good_frame = [];
            for j_frame = (i_frame+1):number_of_frames
                if tag_dark(1, j_frame) == 0
                    following_good_frame = images_stack_output(:,:, j_frame);
                    break
                end
            end
            following_good_frame = double(following_good_frame);
            
            % Check that there are actually good frames to interpolate with...
            % otherwise just continue.
            if ~isempty(following_good_frame) && ~isempty(precedent_good_frame)
                % Compute mean frame between the 2 good frames.
                mean_frame = zeros(image_Height, image_Width);
                for i_pixel = 1:image_Height
                    for j_pixel = 1:image_Width
                        mean_frame(i_pixel, j_pixel) = (precedent_good_frame(i_pixel, j_pixel) + following_good_frame(i_pixel, j_pixel))/2;
                    end
                end
                if isa(images_stack, 'uint8')
                    mean_frame = uint8(mean_frame);
                elseif isa(images_stack, 'uint32')
                    mean_frame = uint16(mean_frame);
                elseif isa(images_stack, 'uint32')
                    mean_frame = uint32(mean_frame);
                elseif isa(images_stack, 'uint64')
                    mean_frame = uint64(mean_frame);
                elseif isa(images_stack, 'double')
                    mean_frame = double(mean_frame);
                else
                    warning('Input was expected to be of type uint or double');
                end
                % Substitute culprit frame with interpolated one.
                images_stack_output(:, :, i_frame) = mean_frame;
                % Re-assign tag.
                tag_dark(1, i_frame) = 0;
            end
        end
    end
    
    % Update waitbar
    percentage_cycle = (i_cycle/number_of_interpolation_cycles)*100;
    waitbar(i_cycle/number_of_interpolation_cycles, prog_bar, sprintf('Interpolating Frames... %d%%', percentage_cycle));
    if getappdata(prog_bar, 'canceling')
        delete(prog_bar);
        return
    end
    
    [~, ~, time_axis_avg_projection] = tag_stim_non_stim_frames (images_stack_output, images_stack_info, FLAG_plot);
    images_stack_info_output.time_axis_avg_projection = time_axis_avg_projection;
end
delete(prog_bar);


end
