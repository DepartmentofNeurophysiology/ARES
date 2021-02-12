function [ time_series_permuted  ] = permute_time_series_elementwise( time_series )
% This function randomly permutes a time series, elementwise


time_series_length = numel(time_series);
time_series_permuted = time_series;
for i = 1:20
    time_series_permuted = time_series_permuted(randperm(time_series_length));
end

end

