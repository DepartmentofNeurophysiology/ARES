function [tag_dark] = tag_dark_frames_derivative_GUI (images_stack_info, derivative_threshold_modifier, darkness_max_length)
% This function produces the GUI, used in the process of identifying
% consecutives negative/positive spikes in the derivative of the average 
% time projection of the image stack, and marks the corresponding minimum 
% point (a frame with no illumination) in the tag_dark array.

FLAG_GUI = 1;
FLAG_full_screen = 1;

if nargin < 3
    darkness_max_length = 3;
end
if nargin < 2
    derivative_threshold_modifier = 1;
end

number_of_frames = images_stack_info.number_of_frames;

% Compute derivative, its mean and std.
time_avg_projection_deriv = diff(images_stack_info.time_axis_avg_projection);
time_avg_projection_deriv_mean = mean(time_avg_projection_deriv);
time_avg_projection_deriv_std = std(time_avg_projection_deriv);
% Compute preliminary thresholds.
deriv_low_cutoff = time_avg_projection_deriv_mean - derivative_threshold_modifier*time_avg_projection_deriv_std;
deriv_high_cutoff = time_avg_projection_deriv_mean + derivative_threshold_modifier*time_avg_projection_deriv_std;


%% Make GUI

if FLAG_GUI == 1
    % Initialize.
    time_avg_projection_tmp = images_stack_info.time_axis_avg_projection(1, 1:end-1);
    time_axis = 1:numel(time_avg_projection_tmp);
    left_color = [135, 206, 250]./255;
    right_color = [0, 0, 0]./255;
    
    %% Plot
    deriv_fig_handle = figure();
    Font_Size_Title = 16;
    
    if FLAG_full_screen == 1
        set(gcf, 'position', get(0,'screensize'));
    end
    set(deriv_fig_handle, 'defaultAxesColorOrder', [left_color; right_color]);
    h_axes_1 = axes('units', 'normalized', 'position', [0.1, 0.1, 0.6, 0.825]); % Position is [Distance from left, Distance from bottom, Width, Height]
    title('Identify artifacts via time derivative.', 'FontSize', Font_Size_Title);
    xlabel ('Frames');
    grid on;
    box on;
    yyaxis left; h_TS = plot(time_avg_projection_tmp);
    h_TS.Color(4) = 0.25; % Set Transparency.
    ylabel('Time projection');
    yyaxis right; h_der = plot(time_avg_projection_deriv);
    h_lab_1 = ylabel('Derivative of time projection');
    if FLAG_full_screen == 0
        set(h_lab_1, 'Units', 'normalized');
        set(h_lab_1, 'position', get(h_lab_1, 'position') - [0.025, 0, 0]);
    end
    
    % Set reflines & axis limits.
    axis([-inf, inf, -inf, inf]); pause(0.05);
    hlineup = refline([0 deriv_high_cutoff]);
    hlineup.Color = right_color; hlineup.LineStyle = '--';
    hlinedown = refline([0 deriv_low_cutoff]);
    hlinedown.Color = right_color; hlinedown.LineStyle = '--';
    
    % Set legend.
    h_legend = legend ('Time Projection', 'Time derivative', 'High Threshold', 'Low Threshold');
    set(h_legend, 'Units', 'normalized', 'Location', 'northeast'); %[0.75, 0.75, 0.15, 0.15]
    set(h_legend.BoxFace, 'ColorType','truecoloralpha', 'ColorData', uint8(255*[1; 1; 1; 0.25]));
    
    
    %% Produce User Interface.
    % Slider 1
    slider_1_opts.tick = [0.00025 0.05];
    slider_1_opts.max = time_avg_projection_deriv_mean + time_avg_projection_deriv_std*10;
    slider_1_opts.min = time_avg_projection_deriv_mean - time_avg_projection_deriv_std*10;
    slider_1_opts.default_slide_value = deriv_high_cutoff;
    if FLAG_full_screen == 1
        slider_1_opts.position = [0.75, 0.7, 0.2, 0.05];
    else
        slider_1_opts.position = [0.8, 0.5, 0.2, 0.05];
    end
    slider_1_opts.tag = 'Slider_1';
    slider_1_opts.description = 'Threshold High - Value = ';
    
    % Slider 2
    slider_2_opts.tick = [0.00025 0.05];
    slider_2_opts.max = time_avg_projection_deriv_mean + time_avg_projection_deriv_std*10;
    slider_2_opts.min = time_avg_projection_deriv_mean - time_avg_projection_deriv_std*10;
    slider_2_opts.default_slide_value = deriv_low_cutoff;
    slider_2_opts.position = slider_1_opts.position + [0, -0.15, 0, 0];
    slider_2_opts.tag = 'Slider_2';
    slider_2_opts.description = 'Threshold Low - Value = ';
    
    slider_1_value_tmp = slider_1_opts.default_slide_value;
    slider_1_value = slider_1_value_tmp;
    slider_2_value_tmp = slider_2_opts.default_slide_value;
    slider_2_value = slider_2_value_tmp;
    [h_slider, deriv_fig_handle] = produce_slider (deriv_fig_handle, slider_1_opts, slider_2_opts);
    
    % Button 1
    button_opts.position = slider_1_opts.position + [0.05, -0.3, -0.1, 0];
    [h_button, deriv_fig_handle] = produce_button (deriv_fig_handle, button_opts);
    
    %% Update Figure
        FLAG_User_Ok_1 = 0;
        while FLAG_User_Ok_1 == 0
            pause(0.25)
            if slider_1_value ~= slider_1_value_tmp
                delete(hlineup)
                hlineup = refline([0 slider_1_value]); hlineup.Color = 'k'; hlineup.LineStyle = '--';
                slider_1_value_tmp = slider_1_value;
            end
            if slider_2_value ~= slider_2_value_tmp
                delete(hlinedown)
                hlinedown = refline([0 slider_2_value]); hlinedown.Color = 'k'; hlinedown.LineStyle = '--';
                slider_2_value_tmp = slider_2_value;
            end
        end
        if FLAG_User_Ok_1 == 1
            deriv_high_cutoff = slider_1_value;
            deriv_low_cutoff = slider_2_value;
            close(deriv_fig_handle);
        end
end


%% Tag frames according to derivative threshold -- low luminance artifact
tag_dark = zeros(1, number_of_frames);
counter_darkness = 0;
i_frame = 1;
% Scroll over frames.
while i_frame < number_of_frames - darkness_max_length
    FLAG_darkness = 0;
    % If a low value in the derivative is found
    if time_avg_projection_deriv(1, i_frame) < deriv_low_cutoff
        
        % Start counting until a high derivative is found, or the max allowed distance from the low derivative point is reached.
        counter_darkness = 0;
        while (counter_darkness < darkness_max_length) && (i_frame + counter_darkness < number_of_frames)
            if time_avg_projection_deriv(1, i_frame + counter_darkness + 1) > deriv_high_cutoff
                while time_avg_projection_deriv(1, i_frame + counter_darkness + 1) > deriv_high_cutoff && (counter_darkness < darkness_max_length) && (i_frame + counter_darkness < number_of_frames)
                    counter_darkness = counter_darkness + 1;
                end
                % When the last high derivative is found, exit the loop.
                FLAG_darkness = 1;
                break
            end
            counter_darkness = counter_darkness + 1;
        end
        
    end
    % If a dark frame is found, mark it for interpolation / removal.
    if FLAG_darkness == 1
        tag_dark(1, (i_frame + 1):(i_frame + counter_darkness)) = 1;
    end
    i_frame = i_frame + 1;
end


%% Tag frames according to derivative threshold -- high luminance artifact
counter_bright = 0;
i_frame = 1;
% Scroll over frames.
while i_frame < number_of_frames - darkness_max_length
    FLAG_bright = 0;
    % If a high value in the derivative is found
    if time_avg_projection_deriv(1, i_frame) > deriv_high_cutoff
        
        % Start counting until a low derivative is found, or the max allowed distance from the high derivative point is reached.
        counter_bright = 0;
        while (counter_bright < darkness_max_length) && (i_frame + counter_bright < number_of_frames)
            if time_avg_projection_deriv(1, i_frame + counter_bright + 1) < deriv_low_cutoff
                while time_avg_projection_deriv(1, i_frame + counter_bright + 1) < deriv_low_cutoff && (counter_bright < darkness_max_length) && (i_frame + counter_bright < number_of_frames)
                    counter_bright = counter_bright + 1;
                end
                % When the last high derivative is found, exit the loop.
                FLAG_bright = 1;
                break
            end
            counter_bright = counter_bright + 1;
        end
        
    end
    % If a dark frame is found, mark it for interpolation / removal.
    if FLAG_bright == 1
        tag_dark(1, (i_frame + 1):(i_frame + counter_bright)) = 1;
    end
    i_frame = i_frame + 1;
end