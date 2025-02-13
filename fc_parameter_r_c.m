function [] = fc_parameter_r_c()
% This function calculates and assigns the parameters 'r', 'cl', and 'cr' for each feature
% in each class based on statistical calculations.

global Data Parameter number_features number_Classes % Access global variables

ce = 0; % Initializing characteristic element offset (currently set to zero)
decimal_round = 2; % Define the number of decimal places for rounding

% Loop through each class
for i = 1:number_Classes 

    % Compute the mean, min, and max for each feature
    r = (mean(table2array(Data(i).Raw_Data(:, 1:number_features))))'; % Compute mean for each feature
    min_data = (min(table2array(Data(i).Raw_Data(:, 1:number_features))))'; % Compute min values
    max_data = (max(table2array(Data(i).Raw_Data(:, 1:number_features))))'; % Compute max values

    % Assign calculated parameters to the Parameter structure
    Parameter(i).Class(1, "a") = array2table(1); % Assign a constant value of 1 for parameter 'a'
    Parameter(i).Class(:, "r") = array2table(round(r, decimal_round)); % Assign rounded mean value to parameter 'r'
    Parameter(i).Class(:, "cl") = array2table(round((r - min_data), decimal_round) - ce); % Assign 'cl' based on range
    Parameter(i).Class(:, "cr") = array2table(round((max_data - r), decimal_round) + ce); % Assign 'cr' based on range

end

end
