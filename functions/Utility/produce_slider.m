function [h_slider, h_figure] = produce_slider (h_figure, slider_1_opts, slider_2_opts)
% This function adds 1 oe 2 sliders to a figure.


%% Initialize
if nargin < 2 || isempty(slider_1_opts)
    slider_1_opts.default_slide_value = 0;
    slider_1_opts.position = [0.675 0.4 0.2 0.05];
    slider_1_opts.dimension = [0, 0, 1, 5];
    slider_1_opts.tag = 'Slider_1';
    slider_1_opts.tick = [0.005 0.10];
    slider_1_opts.max = 5;
    slider_1_opts.min = 0;
    slider_1_opts.description = 'Threshold adjuster - Value = ';
end
if nargin == 0 || isempty(h_figure)
    h_figure = figure();
end
% Full description string
description_1 = slider_1_opts.description;
desc_string_1_tmp = sprintf('%.2f', slider_1_opts.default_slide_value);
desc_string_1 = strcat(description_1, desc_string_1_tmp);


%% Produce Slider 1
% Create slider
h_slider = uicontrol(h_figure, 'Style','slider', ...
    'Units', 'normalized', ...
    'Position', slider_1_opts.position, ...
    'Max', slider_1_opts.max, 'Min', slider_1_opts.min, ...
    'Value', slider_1_opts.default_slide_value, ...
    'Tag', slider_1_opts.tag, ...
    'SliderStep', slider_1_opts.tick, 'callback', @Slider_1_Call);

% Add description
slider_1_desc_pos = slider_1_opts.position + [0, -0.075, 0, 0.025];
h_slider_1_desc = uicontrol('Style', 'text', ...
    'Units', 'normalized', ...
    'Position', slider_1_desc_pos, ...
    'String', desc_string_1);


%% Produce Slider 2
if nargin > 2
    % Full description string
    description_2 = slider_2_opts.description;
    desc_string_2_tmp = sprintf('. Value = %.2f', slider_2_opts.default_slide_value);
    desc_string_2 = strcat(description_2, desc_string_2_tmp); 
    
    % Create slider
    h_slider = uicontrol(h_figure, 'Style','slider', ...
        'Units', 'normalized', ...
        'Position', slider_2_opts.position, ...
        'Max', slider_2_opts.max, 'Min', slider_2_opts.min, ...
        'Value', slider_2_opts.default_slide_value, ...
        'Tag', slider_2_opts.tag, ...
        'SliderStep', slider_2_opts.tick, 'callback', @Slider_2_Call);
    
    % Add description
    slider_2_desc_pos = slider_2_opts.position + [0, -0.075, 0, 0.025];
    h_slider_2_desc = uicontrol('Style', 'text', ...
        'Units', 'normalized', ...
        'Position', slider_2_desc_pos, ...
        'String', desc_string_2);
end


%% Callbacks
% Slider 1 Callback function.
    function Slider_1_Call(handles, event)
        handles.UserData = handles.Value;
        assignin('caller', 'slider_1_value', handles.UserData) % other option for workshop is "base" (the main ws)
%         pause(0.002)
        % Update description
%         tmp_value = evalin('caller', handles.Value);
        desc_string_1_update = strcat(description_1, sprintf('%.2f', handles.Value));
        h_slider_1_desc = uicontrol('Style', 'text', ...
            'Units', 'normalized', ...
            'Position', slider_1_desc_pos, ...
            'String', desc_string_1_update);
    end

% Slider 2 Callback function.
    function Slider_2_Call(handles, event)
        handles.UserData = handles.Value;
        assignin('caller', 'slider_2_value', handles.UserData) % other option for workshop is "base" (the main ws)
%         pause(0.002)
        % Update description
        desc_string_2_update = strcat(description_2, sprintf('%.2f', handles.Value));
        h_slider_2_desc = uicontrol('Style', 'text', ...
            'Units', 'normalized', ...
            'Position', slider_2_desc_pos, ...
            'String', desc_string_2_update);
    end

end