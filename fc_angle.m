function [] = fc_angle()
% This function calculates the principal angle between feature vectors
% and applies a rotation transformation to align them.

global Data Parameter number_features number_Classes % Access global variables

for i = 1:number_Classes % Loop through each class in the dataset
    
    for j = 2:number_features % Loop through each feature (excluding the first column)
        
        % Extract two-dimensional feature data (first column and current feature column)
        X1 = (table2array(Data(i).Raw_Data(:, [1, j])))'; % Transpose for computation
        
        % Compute the mean of each row (feature-wise mean)
        Xavg1 = mean(X1, 2); 
        
        % Determine the number of data points
        nPoints = size(X1, 2); 
        
        % Center the data by subtracting the mean
        B1 = X1 - Xavg1 * ones(1, nPoints); 
        
        % Perform Singular Value Decomposition (SVD)
        [U1, ~, ~] = svd(B1 / sqrt(nPoints), 'econ'); 
        
        % Determine the principal angle based on the first singular vector
        if (U1(1,1) > 0 && U1(2,1) > 0) || (U1(1,1) < 0 && U1(2,1) < 0) == 1
            % Compute the angle using inverse cosine (acosd)
            angle1 = acosd(U1(1,1));
            
            % Adjust angle to be within [0, 90] degrees
            if angle1 >= 90 
                angle1 = 180 - angle1;
            end
        end
        
        if (U1(1,1) > 0 && U1(2,1) < 0) || (U1(1,1) < 0 && U1(2,1) > 0) == 1
            % Compute the angle using inverse sine (asind)
            angle1 = asind(U1(1,1)) - 90;
            
            % Adjust angle to be within [-90, 0] degrees
            if angle1 <= -90 
                angle1 = -180 - angle1;
            end
        end
        
        % Store the computed angle value in the parameter table
        Parameter(i).Class(j, "a") = array2table(round(angle1, 1));
        
        % Apply rotation transformation to align the feature vector
        R = ((X1' - Xavg1') * [cosd(angle1), -sind(angle1); sind(angle1), cosd(angle1)]) + Xavg1';
        
        % Update the rotated data in the dataset
        Data(i).Raw_Data(:, [1, j]) = array2table(R);
        
    end  
    
    % Clear temporary variables to free memory
    X1 = []; 
    Xavg1 = []; 
    B1 = []; 
    R = [];
end

end
