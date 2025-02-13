function [] = fc_ce()
% This function calculates the characteristic element (ce) for each feature
% in each class by computing 5% of the feature's range (max - min).

global Data number_features number_Classes ce % Access global variables

% Initialize the ce matrix with zeros, dimensions: [number_Classes x number_features]
ce = zeros(number_Classes, number_features);

% Iterate through each class
for i = 1:number_Classes
    % Iterate through each feature
    for j = 1:number_features
        % Extract the maximum and minimum values of the current feature
        max_value = max(table2array(Data(i).Raw_Data(:, j))); % Maximum feature value
        min_value = min(table2array(Data(i).Raw_Data(:, j))); % Minimum feature value
        
        % Compute the characteristic element (5% of the feature range)
        ce(i, j) = (max_value - min_value) * 0.05;
    end
end

end
