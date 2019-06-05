% H. Cai

% An implementation of the modified cuckoo search
% Optimizing the first Bohachevsky function
% The global minimum is known to be at (0,0) where f = 0

rng(5); % Set seed
I.G = 1; % Generation number
I.Pa = 0.75; % fraction of abandoned nests
I.A = 1; % Maximum Levy step size
I.beta = 1.3; % Power law index, 1 < B < 2
I.phi = ( 1 + sqrt(5) ) / 2; % Golden ratio, use described in paper

% Initialize nests in population
I.n_nests = 20;
I.n_params = 2; % = number of positions to optimize
nests_init = rand(I.n_nests, I.n_params); % Each row is a nest

% Calculate all fitness scores in a population
scores_init = zeros(I.n_nests, 1);
for i = 1:I.n_nests
    scores_init(i) = f(nests_init(i,:));
end

% Rank the nests in order of fitness
nests =  sortrows(horzcat(nests_init, scores_init), 3, 'descend');
abandon_value = floor(I.Pa * I.n_nests); % Nests ranking below this should be discarded

while I.G < 50 % arbitrary stopping parameter
   for i = 1:abandon_value
      % generate a new nest
      candidate = flight(nests, i, I);
      breed(candidate, (nests(i,:)));      
   end    
   
   for i = abandon_value+1:I.n_nests
       % the nest has relatively good fitness: keep it
   end
   
   I.G = I.G + 1; 
   nests
   drawplot(nests)
end

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define a fitness/loss function f()
function [fitness] = f(x)
    fitness = x(1)^2 + 2*x(2)^2 - 0.3*cos(3*pi*x(1)) - 0.4*cos(4*pi*x(2)) + 0.7;
end

% What to do when taking a Levy flight and updating scores
function replacement = flight(nests, i, I) 
    oldegg = nests(i, 2:I.n_params+1);
    alpha = I.A / sqrt(I.G); % step size scaling factor
    newegg = oldegg + alpha .* levy(1, I.n_params, I.beta);
    newscore = f(newegg);
    replacement = horzcat(newscore, newegg);
end

% Recombination of chromosomes/individuals
function offspring = breed(mother, father, locus, drift)
    % locus must be leq the length of mother/father vector
    % drift describes the probability of random mutation
    
    offspring = horzcat(mother(1:locus), father(locus+1:end));
    mutation = rand(size(offspring));
    for i = 1:length(offspring)
        if mutation(i) < drift
            offspring(i) = rand(1);
        end
    end
end