function [tag_array, tag_fig_handle, time_axis_avg_projection, tag_threshold_up] = tag_stim_non_stim_frames (images_stack, images_stack_info, FLAG_plot, FLAG_slider, tag_threshold_up, options)
% This function assigns each frame a 1/-1 tag, to divide them into actual
% recordings, and frames to cut due to no input.
% INPUT
% images_stack: the stack of images loaded in the workspace as a 3D matrix
% images_stack_info: a structure containing infos about the images stack
% FLAG_plot: a binary variable which is 1 in case the figure is 
%            to be displayed, 0 otherwise.
% FLAG_slider: a binary variable which is 1 in case the figure should have
%            the interactive threshold slider.
% tag_threshold_up: the threshold value above which frames will be 
%            considered in the analysis.

if nargin < 3
   FLAG_plot = 1; 
end
if nargin < 4
    FLAG_slider = 1;
end
if nargin < 6
   options.std_multiplier_up_down = 2.3; 
end
number_of_frames = images_stack_info.number_of_frames;
std_multiplier_up_down = options.std_multiplier_up_down;
time_axis_avg_projection = compute_stack_time_profile (images_stack, images_stack_info, 'avg');
FLAG_uncertain_frames_as_positive = 0;
FLAG_uncertain_frames_as_negative = 1;


%% Set a first glance threshold for up states and low states.
min_time_axis_avg_projection = nanmin(time_axis_avg_projection);
time_axis_avg_projection = time_axis_avg_projection - min_time_axis_avg_projection;
min_time_axis_avg_projection = 0;
max_time_axis_avg_projection = nanmax(time_axis_avg_projection);
avg_time_axis_avg_projection = nanmean(time_axis_avg_projection);
std_time_axis_avg_projection = nanstd(time_axis_avg_projection);
up_threshold = avg_time_axis_avg_projection - 1*std_time_axis_avg_projection;
bottom_threshold = min_time_axis_avg_projection + 1*std_time_axis_avg_projection;


%% Consider the frames which have their avg value in the 2 intervals.
up_counter = 0;
down_counter = 0;
up_frames = NaN(1, number_of_frames);
down_frames = NaN(1, number_of_frames);
for i_frame = 1:number_of_frames
    if (time_axis_avg_projection(1, i_frame) >= up_threshold)
        up_counter = up_counter + 1;
        up_frames(1, up_counter) = time_axis_avg_projection(1, i_frame);
    elseif (time_axis_avg_projection(1, i_frame) <= bottom_threshold)
        down_counter = down_counter + 1;
        down_frames(1, down_counter) = time_axis_avg_projection(1, i_frame);
    end
end
up_avg = nanmean(up_frames);
up_std = nanstd(up_frames);
down_avg = nanmean(down_frames);
down_std = nanstd(down_frames);


%% Make a new threshold value, with the group of pixels with the lower std,
% then finally use it to tag every frame with up/down.

tag_threshold_down = down_avg + std_multiplier_up_down*down_std;
if nargin < 5 || isempty (tag_threshold_up)
    tag_threshold_up = up_avg - std_multiplier_up_down*up_std;
end
if tag_threshold_up <= tag_threshold_down
    tag_threshold_down = tag_threshold_up;
end
tag_array = zeros (1, number_of_frames);
% UP -> tag = 1
% DOWN -> tag = -1
% middle -> tag = 0
for i_frame = 1:number_of_frames
    if (time_axis_avg_projection(1, i_frame) <= tag_threshold_down)
        tag_array(1, i_frame) = -1;
    elseif (time_axis_avg_projection(1, i_frame) >= tag_threshold_up)
        tag_array(1, i_frame) = 1;
    end
    % Also consider uncertain frames as up states or down states.
    if FLAG_uncertain_frames_as_positive == 1
        if tag_array(1, i_frame) == 0
            tag_array(1, i_frame) = 1;
        end
    elseif FLAG_uncertain_frames_as_negative == 1
         if tag_array(1, i_frame) == 0
            tag_array(1, i_frame) = -1;
        end
    end
end


%% Display tag vector together with time profile to visually check for correctness.
if FLAG_plot == 1
    FLAG_full_screen = 0;
    tag_display = tag_array.*(avg_time_axis_avg_projection/2) + avg_time_axis_avg_projection/2;
    tag_fig_handle = figure; 
    if FLAG_full_screen == 1
        set(gcf,'position', get(0,'screensize'));
    end
    h_axes_1 = axes('units', 'normalized', 'position', [0.1, 0.1, 0.65, 0.825]);
    plot(time_axis_avg_projection); hold on;
    h_scatter_1 = scatter(1:number_of_frames, tag_display, 25, 'x');
    set(h_scatter_1, 'MarkerFaceAlpha', 0.33, 'MarkerEdgeAlpha', 0.33);
    hlineup = refline([0 tag_threshold_up]); hlineup.Color = 'k'; hlineup.LineStyle = '--';
    hold off;
    ylim([-inf, inf]); % try ylim([-avg_time_axis_avg_projection/20, inf]) if display is ugly
    xlim([-inf, number_of_frames]);    
    h_legend = legend ('Time Projection', 'Tag (up or down)', 'Up State Threshold');
    set(h_legend, 'Location', 'northeast');
    set(h_legend, 'FontSize', 8);
    set(h_legend.BoxFace, 'ColorType','truecoloralpha', 'ColorData', uint8(255*[1; 1; 1; 0.25]));
    xlabel ('Frame'); ylabel('Avg Intensity'); title('Tagged frames according to time average projection.');
    % Produce User Interface.
    if FLAG_slider == 1
        slider_opts.default_slide_value = tag_threshold_up;
        if FLAG_full_screen == 1
            slider_opts.position = [0.75, 0.5, 0.2, 0.05];
        else
            slider_opts.position = [0.775, 0.5, 0.2, 0.05];
        end
        slider_opts.tag = 'Slider_1';
        slider_opts.tick = [0.005 0.10];
        slider_opts.max = max_time_axis_avg_projection;
        slider_opts.min = min_time_axis_avg_projection;
        slider_opts.description = 'Threshold adjuster - Value = ';
        button_opts.position = slider_opts.position + [0.05, -0.125, -0.1, 0];
        slider_value_tmp = slider_opts.default_slide_value;
        slider_1_value = slider_value_tmp;
        [h_slider, tag_fig_handle] = produce_slider (tag_fig_handle, slider_opts);
        [h_button, tag_fig_handle] = produce_button (tag_fig_handle, button_opts);
        % Update figure.
        FLAG_User_Ok_1 = 0;
        if exist('warn_tmp', 'var'); clear warn_tmp; end; % Fix for the slider not appearing in some cases
        while FLAG_User_Ok_1 == 0
            pause(0.25)
            %-% Fix for the slider not appearing in some cases
            warn_tmp = warning('query', 'last'); 
            if exist('warn_tmp', 'var')
                if isfield (warn_tmp, 'identifier') && numel(warn_tmp) ~= 0
                    if strcmpi(warn_tmp.identifier, 'MATLAB:hg:uicontrol:ValueMustBeInRange') == 1
                        warning('Slider default value (%d) out of borders. Changed automatically to %d.', slider_opts.default_slide_value, slider_opts.default_slide_value/2)
                        slider_value_tmp = slider_opts.default_slide_value/2;
                        if exist('warn_tmp', 'var'); clear warn_tmp; end;
                    end
                end
            end
            %-%
            if slider_1_value ~= slider_value_tmp
                delete(hlineup)
                hlineup = refline([0 slider_1_value]); hlineup.Color = 'k'; hlineup.LineStyle = '--';
                slider_value_tmp = slider_1_value;
            end
        end
        if FLAG_User_Ok_1 == 1
            tag_threshold_up = slider_1_value;
            close(tag_fig_handle);
            % Recursive but without User Interface.
            [tag_array, tag_fig_handle, time_axis_avg_projection] = tag_stim_non_stim_frames (images_stack, images_stack_info, 0, 0, tag_threshold_up);
        end
    end
    
else
    tag_fig_handle = [];
end

end