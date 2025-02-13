
% This function finds the optimal value of 'b' that minimizes the error
% between the computed volume and the target volume.

function b_optimal = find_optimal_b(a, c, r, d, x_min, x_max, target_volume)
    % Optimization Settings
    options = optimset('TolX', 1e-6); % Set tolerance for optimization precision
    b_initial = 0.5; % Initial guess for parameter 'b' to start optimization

    % Find the optimal value of 'b' using fminsearch to minimize the error function
    b_optimal = fminsearch(@(b) error_function(b, target_volume, a, c, r, d, x_min, x_max), b_initial, options);
    
    % Display the optimal 'b' value
    disp('Optimal b:');
    disp(b_optimal);
end

% This function computes the volume under the function for given parameters
function volume = compute_volume(a, b, c, r, d, x_min, x_max)
    num_points = 1000; % Number of points for numerical integration
    x_values = linspace(x_min, x_max, num_points); % Generate points between min and max x values
    
    % Compute membership function values for all x-values
    m_values = a ./ (1 + ((1/b - 1) * (abs(x_values - r) / c).^d));
    
    % Compute the integral using numerical trapezoidal integration
    volume = trapz(x_values, m_values);
end

% This function calculates the error between the computed and target volumes
function error = error_function(b, target_volume, a, c, r, d, x_min, x_max)
    % Compute the volume for the given 'b'
    calculated_volume = compute_volume(a, b, c, r, d, x_min, x_max);
    
    % Calculate absolute error between computed volume and target volume
    error = abs(calculated_volume - target_volume);
end
