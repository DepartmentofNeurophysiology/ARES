function [h_button, h_figure] = produce_button (h_figure, button_opts)
% This function adds a confirmation button to a figure.

if nargin < 2 || isempty(button_opts)
    button_opts.position = slider_opts.position + [0.5, -0.1, -0.1, 0];
end
if nargin == 0 || isempty(h_figure)
    h_figure = figure();
end

% Create push button
h_button = uicontrol(h_figure, 'Style', 'pushbutton', 'String', 'Ok',...
    'Units', 'normalized', 'Position', button_opts.position, ...
    'Tag', 'Button_1', 'Callback', @ButtonCall);

% Button Callback function
    function ButtonCall(handles, event)
        assignin('caller', 'FLAG_User_Ok_1', 1)
    end

end