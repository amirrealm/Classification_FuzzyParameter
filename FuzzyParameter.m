clear all; clc; close all; 

% Define parameters for automatic processing and constant values
automatic_b = true;   % If true, use automatic computation for parameter 'b'
constant_parameter_b = 0.5; % Constant value for parameter 'b' if not automatic

automatic_d = false;  % If true, use automatic computation for parameter 'd'
constant_parameter_d = 2;   % Constant value for parameter 'd' if not automatic

With_angle = false;   % Boolean flag to determine if angle-related computations should be performed

% Define global variables for storing data and parameters
global Data Parameter number_features number_Classes 

% Read data from an Excel file
[num, txt] = xlsread('Data_out1_train.xlsx'); % Read numerical data and text headers
T = array2table(num, 'VariableNames', txt);  % Convert numerical array to a table with headers

% Determine dataset characteristics
number_Classes = max(T.label);       % Identify the number of unique classes in the dataset
number_features = size(T,2) - 2;      % Calculate the number of features (excluding label columns)

% Initialize Data and Parameter structures
Data.Raw_Data = [];                   % Empty structure to store raw data
Parameter.Class = zeros(number_features, 8); % Initialize parameter matrix with zeros

% Define parameter names
par_name = {'r', 'a', 'bl', 'br', 'cl', 'cr', 'dl', 'dr'}; 
Parameter.Class = array2table(Parameter.Class, 'VariableNames', par_name); % Convert to table format

% Replicate Data and Parameter structures for each class
Data = repmat(Data, number_Classes, 1);    
Parameter = repmat(Parameter, number_Classes, 1);

% Initialize Regression structure for each class
Regression.Class = [];
Regression = repmat(Regression, number_Classes, 1);

% Store dataset into different structured format for each class
for i = 1:number_Classes
    ind = find(T.label == i);      % Find indices for current class
    Data(i).Raw_Data = T(ind,1:end-1); % Store data excluding the label column
end

% Call function to perform certain computations (function implementation not provided)
fc_ce();

% If With_angle flag is set, call the function for angle-related computations
if With_angle == 1
    fc_angle;
end

% Call function to compute parameters related to 'r' and 'c'
fc_parameter_r_c;

% Handle computation for parameter 'd' based on automatic setting
if automatic_d == 1
    fc_parameter_d  % Call function if automatic mode is enabled
else 
    % If not automatic, assign constant parameter values for 'dl' and 'dr'
    for i = 1:number_Classes
         Parameter(i).Class(:,"dl") = array2table(constant_parameter_d);
         Parameter(i).Class(:,"dr") = array2table(constant_parameter_d);
    end
end

% Handle computation for parameter 'b' based on automatic setting
if automatic_b == 1
    fc_parameter_b() % Call function if automatic mode is enabled
else 
    % If not automatic, assign constant parameter values for 'bl' and 'br'
    for i = 1:number_Classes
         Parameter(i).Class(:,"bl") = array2table(constant_parameter_b);
         Parameter(i).Class(:,"br") = array2table(constant_parameter_b);
    end
end
