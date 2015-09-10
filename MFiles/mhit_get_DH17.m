function [dh17,Opt]=mhit_get_DH17(discharge,wYear,wYearList,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(wYear,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});

if (any(size(discharge)~=size(wYear)))
  error('discharge, year, and month must be of the same size.');
end

if (nargin<3 || isempty(wYearList))
  wYearList=unique(wYear);
else
  validateattributes(wYearList,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
  tmpWYearList=unique(wYearList);
  if (   (numel(tmpWYearList) ~= numel(wYearList)) ...
      ||  any(tmpWYearList ~= wYearList) )
    error('mhit_get_MA3: wYearList must have unique values.');
  end
end

%% Checking Options
if (nargin<4 || isempty(Opt))
  [~,Opt]=mhit_get_MA2(discharge);
  Opt.preference='mean';
  Opt.prefFun=mhit_getPrefFun(Opt.preference);
else
  if (~isfield(Opt,'medianDischarge') || isempty(Opt.medianDischarge))
    [~,Opt]=mhit_get_MA2(discharge,Opt);
  end
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'prefFun') || isempty(Opt.prefFun))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end  
end

%%
thresh=Opt.medianDischarge;

eventMaskPerYear=arrayfun(@(wy) discharge(wYear==wy)>thresh , wYearList, 'UniformOutput',false);
totalEventsDurationPerYear=arrayfun(@(wyID) sum(eventMaskPerYear{wyID}), 1:numel(wYearList));
nEventsPerYear=arrayfun(@(wyID) sum(diff([0;eventMaskPerYear{wyID}])>0), 1:numel(wYearList));

avgEventDurationPerYear=totalEventsDurationPerYear./nEventsPerYear;
avgEventDurationPerYear(nEventsPerYear==0)=0;

dh17=Opt.prefFun(avgEventDurationPerYear);
end
