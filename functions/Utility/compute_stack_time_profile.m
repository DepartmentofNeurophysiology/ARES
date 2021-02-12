function time_axis_projection = compute_stack_time_profile (images_stack, images_stack_info, type_of_projection)
% This function computes the selected time projection of the images stack
% (average, max, min, std), it does not consider zero values and NaNs.

[~, ~, number_of_frames] = size(images_stack);

switch type_of_projection
    case 'avg'
        time_axis_projection = zeros(1, number_of_frames);
        for i_frame = 1:number_of_frames
            time_axis_projection(1, i_frame)= mean(nanmean(nonzeros(images_stack(:,:, i_frame))));
        end
    case 'max'
        time_axis_projection = zeros(1, number_of_frames);
        for i_frame = 1:number_of_frames
            time_axis_projection(1, i_frame)= max(nanmax(nonzeros(images_stack(:,:, i_frame))));
        end
    case 'min'
        time_axis_projection = zeros(1, number_of_frames);
        for i_frame = 1:number_of_frames
            time_axis_projection(1, i_frame)= min(nanmin(nonzeros(images_stack(:,:, i_frame))));
        end
    case 'std'
        time_axis_projection = zeros(1, number_of_frames);
        for i_frame = 1:number_of_frames
            time_axis_projection(1, i_frame)= std(nanstd(nonzeros(images_stack(:,:, i_frame))));
        end
end

end