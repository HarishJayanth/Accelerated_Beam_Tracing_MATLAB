function [yout, filtState] = reflFilter(x, refl_gain, filtState, filtCoeffs)
% x - input sample
% abs - absorption coefficients
% filtCoeffs - second order section filter coefficients
% filtState - cells containing previous state of filter sections

yout_temp = zeros(length(filtCoeffs),1);
if isempty(filtState)               % executes at the first iteration for a given path
%     filtState = cell(length(filtCoeffs), 1);
    filtState = zeros(length(filtCoeffs), 5, 3);
end
% tic;
for i = 1:length(filtCoeffs)
    sec_el = size(filtCoeffs{i},1); % half of the actual order of filter section
    sec_b = filtCoeffs{i}(:,1:3);   % numerator coefficients  
    sec_a = filtCoeffs{i}(:,4:6);   % denominator coefficients
    
%     if isempty(filtState{i})        % exectues at the very first iteration for every filter section
%         sec_state = zeros(sec_el, 3);
%     else
%         sec_state = filtState{i};       % filter section states
%     end
    
    sec_state = reshape(filtState(i,:,:), 5, 3);
    
    prevOut = [x; sec_state(:,1)];
    for j = 1:sec_el
        [sec_state(j,1), sec_state(j,2:end)] = filter(sec_b(j,:), sec_a(j,:), prevOut(j) , sec_state(j,2:end));
    end
    filtState{i} = sec_state;
    yout_temp(i) = sec_state(end,1)*refl_gain(i);
end
% toc;
yout = sum(yout_temp);  % sum all outputs

end

