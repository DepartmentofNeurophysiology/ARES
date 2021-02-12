function window_used = set_window (window_type, window_length, gauss_std)
% This function will create a window of length "window_length" and type
% "window_type". 
% This window is often used in the toolbox as a sliding time window to
% compute the time dimention of causality related quantities.
% 
% ~~~ INPUT VARIABLES ~~~ %
% 
% - "window_type" is the type of window. It can assume the values(strings):
% 'rectangular', 'gaussian', 'hanning', 'hamming', 'blackman'.
% - "window_length" is the length of the window used. In the toolbox this 
% length is usually the length in frames 
% (or time points, it's the same thing!)
% - (Optional): "gauss_std" is the standard deviation of the gaussian, 
% in case this window type is selected, the user might want to modify this.
% ---------------------------------------------------------------------- %

if nargin < 3
    gauss_std = 6;
end

switch window_type
    case 'rectangular'
        window_used = ones(1, window_length);
    case 'gaussian'
        alpha = (window_length-1) / (gauss_std*2); % Just a parameter required by matlab to build the window
        window_used = gausswin(window_length, alpha);
        window_used = window_used';
    case 'hanning'
        window_used = (hann(window_length))';
    case 'hamming'
        window_used = (hamming(window_length))';
    case 'blackman'
        window_used = (blackman(window_length))';
    otherwise
        error('Wrong input string for window_type. Check function description for more info.');
end

end

