function [tag_dark] = tag_dark_frames_derivative (images_stack_info, derivative_threshold_modifier, darkness_max_length)
% This function identifies consecutives negative/positive spikes in the derivative
% of the average time projection of the image stack, and marks 
% the corresponding minimum point (a frame with no illumination)
% in the tag_dark array.

if nargin < 3
    darkness_max_length = 3;
end
if nargin < 2
    derivative_threshold_modifier = 0.75;
end

number_of_frames = images_stack_info.number_of_frames;

% Compute derivative, its mean and std.
time_axis_avg_projection_deriv = diff(images_stack_info.time_axis_avg_projection);
time_axis_avg_projection_deriv_mean = mean(time_axis_avg_projection_deriv);
time_axis_avg_projection_deriv_std = std(time_axis_avg_projection_deriv);


%% Make GUI
% Plot
figure(); plot(time_axis_avg_projection_deriv);
zero_line = refline([0 deriv_high_cutoff]); zero_line.Color = 'b'; zero_line.LineStyle = '--';
zero_line = refline([0 deriv_low_cutoff]); zero_line.Color = 'b'; zero_line.LineStyle = '--';
axis([-inf, inf, -inf, inf]);

% Plot
figure(); plot(tag_dark);
zero_line = refline([0 deriv_high_cutoff]); zero_line.Color = 'b'; zero_line.LineStyle = '--';
zero_line = refline([0 deriv_low_cutoff]); zero_line.Color = 'b'; zero_line.LineStyle = '--';
axis([-inf, inf, -1.5, 1.5]);


%% Tag frames according to derivative threshold.
% Compute thresholds.
deriv_low_cutoff = time_axis_avg_projection_deriv_mean - derivative_threshold_modifier*time_axis_avg_projection_deriv_std;
deriv_high_cutoff = time_axis_avg_projection_deriv_mean + derivative_threshold_modifier*time_axis_avg_projection_deriv_std;

tag_dark = zeros(1, number_of_frames);
counter_darkness = 0;
i_frame = 1;
% Scroll over frames.
while i_frame < number_of_frames - darkness_max_length
    FLAG_darkness = 0;
    % If a low value in the derivative is found
    if time_axis_avg_projection_deriv(1, i_frame) < deriv_low_cutoff
        
        % Start counting until a high derivative is found, or the max allowed distance from the low derivative point is reached.
        counter_darkness = 0;
        while (counter_darkness < darkness_max_length) && (i_frame + counter_darkness < number_of_frames)
            if time_axis_avg_projection_deriv(1, i_frame + counter_darkness + 1) > deriv_high_cutoff
                while time_axis_avg_projection_deriv(1, i_frame + counter_darkness + 1) > deriv_high_cutoff && (counter_darkness < darkness_max_length) && (i_frame + counter_darkness < number_of_frames)
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
