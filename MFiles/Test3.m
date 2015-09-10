%% Test3
% This example calculates all the indices for multiple streams. Check the
% data files to learn how the input data must be prepared.

clear;
clc;
close all;

%%
inputDIR='..\Data';
inputFileExtension='csv';
nParallelWorker=2;

outputFilename='..\Output\allIndicesCalculated.csv';

%% Preparing the parallel worker
% This step is only needed if you want to deviate from the default parpool
% launch of MATLAB. For example, here I want to make sure that the number
% of parallel workers are the same as the one set in nParallelWorker;
% therefore, I am launching the parpool manually.

currentProfile=gcp('nocreate'); 
if (isempty(currentProfile)) % Checking if there is a parallel pool present
  disp('There is no parallel pool running.')
  parpool(nParallelWorker);
elseif (currentProfile.NumWorkers ~= nParallelWorker)
  disp('Current parallel pool has different number of workers. Creating a new pool ...')
	delete(gcp);    
  parpool(nParallelWorker);
else
  disp('Using the existing parallel pool.')
end


%% calculating all the indices for all the streams in the inputDIR
[HydInd,Timing]=mhit_getAllInd_AllFiles(inputDIR,inputFileExtension);

%% Write the otput to a CSV file.
writetable(HydInd,outputFilename);





