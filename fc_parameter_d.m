function [] = fc_parameter_d()
% This function calculates the parameters 'dl' and 'dr' for each feature
% in each class using an exponential function based on data distribution.

global Data Parameter number_features number_Classes % Access global variables

decimal_round = 2; % Define the number of decimal places for rounding

% Loop through each class
for i = 1:number_Classes
    
    % Loop through each feature
    for j = 1:number_features
        
        %% Left-side Calculation
        % Identify data points where the feature value is less than the reference value 'r'
        indx_left = find(table2array(Data(i).Raw_Data(:, j)) < table2array(Parameter(i).Class(j, "r")));
        data_left = sort(table2array(Data(i).Raw_Data(indx_left, j))); % Sort data for processing

        % Compute q-values for the left side
        for p = 1:(size(data_left, 1) - 2)    
            q_left(p, 1) = (data_left(p + 2, 1) - data_left(p + 1, 1)) / (data_left(p + 1, 1) - data_left(p, 1));    
        end

        % Compute mean q-value and apply the exponential formula to determine 'd_left'
        q_mean_left = mean(q_left); 
        d_left = round((48 * exp(-3 * (q_mean_left - 1))) + 2, decimal_round);
        
        % Store the computed 'd_left' value in the parameter table
        Parameter(i).Class(j, "dl") = array2table(d_left);

        %% Right-side Calculation
        % Identify data points where the feature value is greater than or equal to 'r'
        indx_right = find(table2array(Data(i).Raw_Data(:, j)) >= table2array(Parameter(i).Class(j, "r")));
        data_right = sort(table2array(Data(i).Raw_Data(indx_right, j))); % Sort data for processing

        % Compute q-values for the right side
        for p = 1:(size(data_right, 1) - 2)    
            q_right(p, 1) = (data_right(p + 2, 1) - data_right(p + 1, 1)) / (data_right(p + 1, 1) - data_right(p, 1));    
        end

        % Compute mean q-value and apply the exponential formula to determine 'd_right'
        q_mean_right = mean(q_right); 
        d_right = round((48 * exp(-3 * (q_mean_right - 1))) + 2, decimal_round);
        
        % Store the computed 'd_right' value in the parameter table
        Parameter(i).Class(j, "dr") = array2table(d_right);

    end
end

end
