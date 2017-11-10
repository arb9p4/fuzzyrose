%% FUZZY_ROSE_DEMO
%  This script demonstrates some of the capabilities of the fuzzy rose
%  plotting library.

% Get a clean workspace
close all; clear all; clc;


%% Create several fuzzy numbers and plot them

% Crisp value represented as a fuzzy number
A1 = fuzzy_deltamf(2);

% Crisp interval represented as a fuzzy number
A2 = fuzzy_rectmf(3,9);

% Triangular fuzzy number
A3 = fuzzy_trimf(0,1,5);

% Trapezoidal fuzzy numbers
A4 = fuzzy_trapmf(1,3,5,8);
A5 = fuzzy_trapmf(5,7,9,10);

% Concatenate into a vector of fuzzy numbers
X = [A1, A2, A3, A4, A5];

% Plot using a standard diagram
fuzzy_plot(X);

% Plot using a fuzzy rose diagram
fuzzy_rose_plot(X);


%% Create a random vector of fuzzy numbers and plot

X = fuzzy_randmf_vector(12, 10);
fuzzy_plot(X);
fuzzy_rose_plot(X);


%% Create a random fuzzy weighted graph and plot

G = fuzzy_random_weighted_graph();
fuzzy_graph_plot(G);
