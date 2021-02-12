function res_time_series = AutoRegress_TS_residuals (input_ts_matrix, process_order, FLAG_demean, reg_mode)
% This function performs an autoregression (AR) on a given time series.
% The method for the AR is a simple linear least squared, solved by QR
% decomposition.
% INPUT
%   - input_ts_matrix = the input time series.
%   - process_order = the order of the autoregression.
%   - FLAG_demean = 1 if the input TS should be demeaned, = 0 if not.
%   - reg_mode is the regression mode, 'linear' or 'exponential'.
% OUTPUT
%  res_time_series = the residuals time series.
% NOTE: 
% 1) The autoregression might issue a warning in case the matrix is rank
%   deficient. This might happen because of non-stationariety or because of
%   too much stationariety (= the time series is constant: for instance if 
%   the fluorescent signal is saturating, or there is no input).
%   To suppress these warnings (they might get quite annoying), set 
%   options.deactivate_warnings = 1 in the User Interface, or provided as input.

if nargin < 3 % Default: do not demean.
    FLAG_demean = 0;
end
if nargin < 4 % Default: linear regression.
   reg_mode = 'linear'; 
end

TS_length = numel(input_ts_matrix);
reduced_window_length = (TS_length - process_order);


% Perform exponential regression, if required.
if strcmpi(reg_mode, 'exponential')
    input_ts_matrix = log(input_ts_matrix);
end

% Demean
if FLAG_demean == 1
    input_ts_matrix = input_ts_matrix - mean(input_ts_matrix);
end

% Making No lag TS
no_lag_TS = input_ts_matrix(1, (process_order + 1):end); 
% Making a lagged TS for each process order
lagged_TS = zeros(process_order, reduced_window_length);
for i_lag = 1:process_order
    lagged_TS(i_lag,:) = reshape(input_ts_matrix(:,(process_order + 1 - i_lag):(TS_length - i_lag),:),1,reduced_window_length);
end

VAR_coeff_matrix = no_lag_TS/lagged_TS; % Autoregression (least squares)

% Check if there are infinite values in the coeff matrix.
if ~all(isfinite(VAR_coeff_matrix)) == 1
    res_time_series = NaN;
    return
end

% Compute residuals
res_time_series = -(no_lag_TS - VAR_coeff_matrix*lagged_TS);
% If demeaning, invert the signal sign, so that when positive it will be 
% consistent with the high luminance in the raw data.
if FLAG_demean == 1
    res_time_series = -res_time_series;
end

end
