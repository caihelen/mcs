% 05/31/2019
% H. Cai

% An implementation of the modified cuckoo search
% Optimizing the first Bohachevsky function
% The global minimum is known to be at (0,0) where f = 0

rng(5); % Set seed
G = 0; % Generation number

% Initialize nests in population
n_nests = 10;
n_params = 2; % = number of positions to optimize
nests = rand(n_nests, n_params); % Each row is a nest

% Calculate all fitness scores in a population
scores = zeros(1, n_nests);
for i = 1:n_nests
    scores(i) = f(nests(i,:));
end

% Define a fitness/loss function f()
function [fitness] = f(x)
    fitness = x(1)^2 + 2*x(2)^2 - 0.3*cos(3*pi*x(1)) - 0.4*cos(4*pi*x(2)) + 0.7;
end



