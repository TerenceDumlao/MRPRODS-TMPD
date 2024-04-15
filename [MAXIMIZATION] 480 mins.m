% Define selling price per bread piece variables
SP1 = 3; % selling price for Pandesal
SP2 = 3; % selling price for Spanish Bread
SP3 = 3; % selling price for Cheese Bread

% Define profit margin variables
PM1 = 0.42; % profit margin for Pandesal
PM2 = 0.37; % profit margin for Spanish Bread
PM3 = 0.41; % profit margin for Cheese Bread

% Define pieces per batch per bread variables
B1 = 33; % pieces per batch of Pandesal
B2 = 40; % pieces per batch of Spanish Bread
B3 = 60; % pieces per batch of Cheese Bread

% Define bread batches variables
x1 = optimvar('x1', 'LowerBound', 0); % Batches of Pandesal
x2 = optimvar('x2', 'LowerBound', 0); % Batches of Spanish Bread
x3 = optimvar('x3', 'LowerBound', 0); % Batches of Cheese Bread

% Define worker variables
w1 = optimvar('w1', 'LowerBound', 0); % Worker 1 time in minutes
w2 = optimvar('w2', 'LowerBound', 0); % Worker 2 time in minutes

% Define the problem
prob = optimproblem('Objective',(SP1*PM1*B1*x1) + (SP2*PM2*B2*x2) + (SP3*PM3*B3*x3) - (400*w1/480) - (250*w2/480), 'ObjectiveSense', 'max');

% Labor Constraint
prob.Constraints.c1 = w1 + w2 <= 960; % total labor available in minutes

% Machine Hours Constraint
prob.Constraints.c2 = 20*x1 + 20*x2 + 20*x3 <= 900; % machine mixer capacity
prob.Constraints.c3 = 20*x1 + 20*x2 + 20*x3 <= 480; % oven capacity 
prob.Constraints.c4 = x1*B1 + x2*B2 + x3*B3 <= 480; % maximum pieces for oven

% Minimum Production Constraint
prob.Constraints.c5 = x1*B1 >= 260; % minimum pieces of Pandesal
prob.Constraints.c6 = x2*B2 >= 80; % minimum pieces of Spanish Bread
prob.Constraints.c7 = x3*B3 >= 80; % minimum pieces of Cheese Bread

% Worker 1 Wage Constraint
prob.Constraints.c8 = w1 <= 480; % maximum time for worker 1
prob.Constraints.c9 = w1 == 20*x1 + 45*x2 + 20*x3; % total time for worker 1

% Worker 2 Wage Constraint
prob.Constraints.c10 = w2 <= 480; % maximum time for worker 2
prob.Constraints.c11 = w2 == 20*x1 + 45*x2 + 20*x3; % total time for worker 2

% Non-negativity Constraint
prob.Constraints.c12 = x1 >= 0;
prob.Constraints.c13 = x2 >= 0;
prob.Constraints.c14 = x3 >= 0;

% Convert problem object to a problem structure
problem = prob2struct(prob);

% Solve the problem
[sol, fval, exitflag, output] = solve(prob);

% Display the solutions
fprintf('Optimal solutions:\n');
fprintf('x1 | Batches of Pandesal = %f\n', sol.x1);
fprintf('      Pieces of Pandesal = %f\n\n', sol.x1*B1);
fprintf('x2 | Batches of Spanish Bread = %f\n', sol.x2);
fprintf('      Pieces of Spanish Bread = %f\n\n', sol.x2*B2);
fprintf('x3 | Batches of Cheese Bread = %f\n', sol.x3);
fprintf('      Pieces of Cheese Bread = %f\n\n', sol.x3*B3);
fprintf('w1 | Worker 1 time in minutes = %f\n', sol.w1);
fprintf('w2 | Worker 2 time in minutes = %f\n', sol.w2);

% Display the optimal value
fprintf('\nMaximum Profit, z = PHP %f\n', fval);