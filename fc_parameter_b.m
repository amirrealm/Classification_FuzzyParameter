function [] = fc_parameter_b()
% This function calculates the parameters 'bl' and 'br' (boundary values) for each feature
% in each class using an optimization approach based on integration.

global Data Parameter number_features number_Classes decimal_round area_left area_right opt_par_left opt_par_right ce 

decimal_round = 2; % Rounding precision for calculated values

% Loop through each class
for i = 1:number_Classes
    
    % Loop through each feature
    for j = 1:number_features
        
        %% Left-side Calculation
        % Identify data points where the feature value is less than the reference value 'r'
        indx_left = find(table2array(Data(i).Raw_Data(:, j)) < table2array(Parameter(i).Class(j, "r")));
        data_left = sort(table2array(Data(i).Raw_Data(indx_left, j))); % Sort data for processing
        STD_left = ce(i, j); % Characteristic element from previous computation

        syms x b % Define symbolic variables for integration

        % Compute midpoints between consecutive sorted data points
        for w = 1:(size(data_left, 1) - 1)
            S(w, 1) = (data_left(w, 1) + data_left(w + 1, 1)) / 2;
        end

        % Define boundary limits for integration
        left1 = -inf; % Negative infinity as lower bound
        left2 = table2array(Parameter(i).Class(j, "r")); % Reference value 'r' as upper bound
        boundary_left = [left1; S; left2]; % Construct boundary array

        % Compute the integral of the function over defined intervals
        for p = 1:size(data_left, 1)
            eqn_left = (1 + ((x - data_left(p, 1)) / STD_left)^2)^-1;
            Result_integral_left(p, 1) = int(eqn_left, [boundary_left(p, 1), boundary_left(p + 1, 1)]);
        end
        
        % Convert symbolic integral results to numeric values
        Result_integral_left = double(Result_integral_left);
        area_left = sum(Result_integral_left); % Compute total area under the curve

        % Store relevant parameters for left boundary calculation
        opt_par_left(1, 1) = table2array(Parameter(i).Class(j, "r"));
        opt_par_left(1, 2) = table2array(Parameter(i).Class(j, "cl"));
        opt_par_left(1, 3) = table2array(Parameter(i).Class(j, "dl"));

        % Define lower bound for optimization
        x_min = opt_par_left(1, 1) - (50 * opt_par_left(1, 2));

        % Find optimal 'b_left' using a predefined function
        b_left = find_optimal_b(1, opt_par_left(1, 2), opt_par_left(1, 1), opt_par_left(1, 3), x_min, opt_par_left(1, 1), area_left);

        % Store computed left boundary parameter
        Parameter(i).Class(j, "bl") = array2table(round(b_left, decimal_round));

        % Clear temporary variables for left-side calculations
        indx_left = []; data_left = []; S = []; boundary_left = []; eqn_left = []; Result_integral_left = []; area_left = [];
        b_left = []; left1 = []; left2 = []; opt_par_left = [];

        %% Right-side Calculation
        % Identify data points where the feature value is greater than or equal to 'r'
        indx_right = find(table2array(Data(i).Raw_Data(:, j)) >= table2array(Parameter(i).Class(j, "r")));
        data_right = sort(table2array(Data(i).Raw_Data(indx_right, j))); % Sort data for processing
        STD_right = ce(i, j); % Characteristic element from previous computation

        syms x b % Define symbolic variables for integration

        % Compute midpoints between consecutive sorted data points
        for w = 1:(size(data_right, 1) - 1)
            S(w, 1) = (data_right(w, 1) + data_right(w + 1, 1)) / 2;
        end

        % Define boundary limits for integration
        right1 = table2array(Parameter(i).Class(j, "r")); % Reference value 'r' as lower bound
        right2 = max(data_right) + STD_right; % Upper bound slightly beyond max value
        boundary_right = [right1; S; right2]; % Construct boundary array

        % Compute the integral of the function over defined intervals
        for p = 1:size(data_right, 1)
            eqn_right = (1 + ((x - data_right(p, 1)) / STD_right)^2)^-1;
            Result_integral_right(p, 1) = int(eqn_right, [boundary_right(p, 1), boundary_right(p + 1, 1)]);
        end
        
        % Convert symbolic integral results to numeric values
        Result_integral_right = double(Result_integral_right);
        area_right = sum(Result_integral_right); % Compute total area under the curve

        % Store relevant parameters for right boundary calculation
        opt_par_right(1, 1) = table2array(Parameter(i).Class(j, "r"));
        opt_par_right(1, 2) = table2array(Parameter(i).Class(j, "cr"));
        opt_par_right(1, 3) = table2array(Parameter(i).Class(j, "dr"));

        % Define upper bound for optimization
        x_max = (50 * opt_par_right(1, 2)) - opt_par_right(1, 1);

        % Find optimal 'b_right' using a predefined function
        b_right = find_optimal_b(1, opt_par_right(1, 2), opt_par_right(1, 1), opt_par_right(1, 3), opt_par_right(1, 1), x_max, area_right);

        % Store computed right boundary parameter
        Parameter(i).Class(j, "br") = array2table(round(b_right, decimal_round));

        % Clear temporary variables for right-side calculations
        indx_right = []; data_right = []; S = []; boundary_right = []; eqn_right = []; Result_integral_right = []; area_right = [];
        b_right = []; right1 = []; right2 = []; opt_par_right = [];
        
    end
end

end
