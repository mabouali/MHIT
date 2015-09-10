%% Test2
% This example calculates all the indices. This is essentially the same as
% Test1 however, much easier.

clear;
clc;
close all;
%%
filename   = 'reach13639.csv';
dataFolder = '..\Data';

%% Reading Data file
data = readtable(fullfile(dataFolder,filename));

%% Reading the drainage area
drainageAreaTBL = readtable(fullfile(dataFolder,'drainageArea.csv'));

%% finding the drainage Area in the table
drainageArea = drainageAreaTBL.drainageArea( strcmpi(drainageAreaTBL.fileName,filename) );

%% Calculaing all the indices
tic;
[allIndices,Opt]=mhit_getAllIndices(data.discharge,data.year,data.month,data.day,drainageArea);
fprintf('Done calculating all the indices.\n Time to calculate all indices: %f0.2 [s]\n',toc)



