% 05/31/2019
% H. Cai

% An implementation of the modified cuckoo search
% Optimizing the first Bohachevsky function
% The global minimum is known to be at (0,0) where f = 0

rng(5); % Set seed
I.G = 1; % Generation number
I.Pa = 0.25; % fraction of abandoned nests
I.A = 1; % Maximum Levy step size
I.B = 1.1; % Power law index, 1 < B < 2

% Initialize nests in population
I.n_nests = 20;
I.n_params = 2; % = number of positions to optimize
nests = rand(I.n_nests, I.n_params); % Each row is a nest

% Calculate all fitness scores in a population
scores = zeros(I.n_nests, 1);
for i = 1:I.n_nests
    scores(i) = f(nests(i,:));
end

% Rank the nests in order of fitness
[temp, sort_indices] =  sort(nests, 'descend');
abandon_value = floor(I.Pa * I.n_nests); % Nests ranking below this should be discarded

while I.G < 10 % arbitrary stopping parameter
    % Analyze the eggs within each nest
    for i = 1:I.n_nests
        if sort_indices(i) < abandon_value
            % Abandon the egg
            abandon(nests(i,:), I)
        else
            % Keep the egg
        end    
    end
    
    I.G = I.G+1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define a fitness/loss function f()
function [fitness] = f(x)
    fitness = x(1)^2 + 2*x(2)^2 - 0.3*cos(3*pi*x(1)) - 0.4*cos(4*pi*x(2)) + 0.7;
end

% What to do when the egg is abandoned
function [newegg, newscore] = abandon(old, I)
    alpha = ceil(I.A / sqrt(I.G)); % Levy step size
    newegg = old + levy(alpha, I.n_params, I.B);
    newscore = f(newegg);
end


