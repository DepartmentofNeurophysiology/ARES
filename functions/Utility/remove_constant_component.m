function demeaned_variable = remove_constant_component(input_variable)
% Remove constant (mean) component from input.

[dim1,dim2,dim3] = size(input_variable);

tmp = ones(1,dim3*dim2);
demeaned_variable = double(input_variable(:,:));
demeaned_variable = demeaned_variable-mean(demeaned_variable,2)*tmp;

demeaned_variable = reshape(demeaned_variable,dim1,dim2,dim3);
return
end