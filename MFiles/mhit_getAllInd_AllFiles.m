function [HydInd,Timing]=mhit_getAllInd_AllFiles(inputDIR,inputFileExtension)
%% Getting FileList
fileList=dir(fullfile(inputDIR,sprintf('*.%s',inputFileExtension)));
fileList={fileList(:).name}';

%%checking if drainageArea file exist
mask=   strcmpi(fileList, sprintf('drainageArea.%s',inputFileExtension) ) ...
     | strcmpi(fileList, 'drainageArea.csv' )  ;
tmp=sum(mask);
if( tmp==0 )
  error('mhit_getAllInd_AllFiles: could not find drainageArea file.');
elseif (tmp>1)
  error('mhit_getAllInd_AllFiles: multiple drainageArea files were found.');
end
drainageArea=readtable(fullfile(inputDIR,'drainageArea.csv'));
fileList=fileList(~mask);
clear mask tmp
nFiles=numel(fileList);

% nFiles=24
% fileList=fileList(1:nFiles);

%%
allIndices=cell(nFiles,1);
Timing=nan(nFiles,1);
parfor fileID=1:nFiles
  data=readtable(fullfile(inputDIR,fileList{fileID}));
  fileTimer=tic;
  indices = mhit_getAllIndices( data.discharge, ...
                                data.year, ...
                                data.month, ...
                                data.day, ...
                                drainageArea.drainageArea(strcmpi(fileList{fileID},drainageArea.fileName))); %#ok<PFBNS>
  Timing(fileID)=toc(fileTimer);
  allIndices{fileID,1}=struct2array(indices);
end
%%
Timing=table(fileList,Timing);

HydInd=table(fileList);
HydInd(:,2:172)=array2table( cell2mat(allIndices) );
HydInd.Properties.VariableNames(2:46)=cellfun(@(c) strtrim(c), cellstr(num2str((1:45)','MA%d')),'UniformOutput',false);
HydInd.Properties.VariableNames(47:68)=cellfun(@(c) strtrim(c), cellstr(num2str((1:22)','ML%d')),'UniformOutput',false);
HydInd.Properties.VariableNames(69:95)=cellfun(@(c) strtrim(c), cellstr(num2str((1:27)','MH%d')),'UniformOutput',false);
HydInd.Properties.VariableNames(96:98)=cellfun(@(c) strtrim(c), cellstr(num2str((1:3)','FL%d')),'UniformOutput',false);
HydInd.Properties.VariableNames(99:109)=cellfun(@(c) strtrim(c), cellstr(num2str((1:11)','FH%d')),'UniformOutput',false);
HydInd.Properties.VariableNames(110:129)=cellfun(@(c) strtrim(c), cellstr(num2str((1:20)','DL%d')),'UniformOutput',false);
HydInd.Properties.VariableNames(130:153)=cellfun(@(c) strtrim(c), cellstr(num2str((1:24)','DH%d')),'UniformOutput',false);
HydInd.Properties.VariableNames(154:156)=cellfun(@(c) strtrim(c), cellstr(num2str((1:3)','TA%d')),'UniformOutput',false);
HydInd.Properties.VariableNames(157:160)=cellfun(@(c) strtrim(c), cellstr(num2str((1:4)','TL%d')),'UniformOutput',false);
HydInd.Properties.VariableNames(161:163)=cellfun(@(c) strtrim(c), cellstr(num2str((1:3)','TH%d')),'UniformOutput',false);
HydInd.Properties.VariableNames(164:172)=cellfun(@(c) strtrim(c), cellstr(num2str((1:9)','RA%d')),'UniformOutput',false);


end






















