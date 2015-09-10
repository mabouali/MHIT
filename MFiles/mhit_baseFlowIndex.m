function [baseFlowIndex,Opt]=mhit_baseFlowIndex(discharge,wYear,wYearList,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(wYear,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});

if ( any(size(discharge)~=size(wYear)) )
  error('discharge and year must be of the same size.');
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

%% Checking Options and calculating Base Flow Index
if (nargin<4 || isempty(Opt))
  Opt.rollingMeanByWYear=arrayfun( @(wy) conv(discharge(wYear==wy),ones(7,1)/7,'valid'), wYearList,'UniformOutput',false);
  Opt.meanByWYear=arrayfun( @(wy) nanmean(discharge(wYear==wy)), wYearList);
  Opt.baseFlowIndex=arrayfun(@(yearID) min(Opt.rollingMeanByWYear{yearID})./(Opt.meanByWYear(yearID)), (1:numel(wYearList))');
else
	if (~isfield(Opt,'rolling7DayMeanByWYear') || isempty(Opt.rolling7DayMeanByWYear))
    Opt.rolling7DayMeanByWYear=arrayfun( @(wy) conv(discharge(wYear==wy),ones(7,1)/7,'valid'), wYearList,'UniformOutput',false);
  end
  if (~isfield(Opt,'meanByWYear') || isempty(Opt.meanByWYear))
    Opt.meanByWYear=arrayfun( @(wy) nanmean(discharge(wYear==wy)), wYearList);
  end
  if (~isfield(Opt,'baseFlowIndex') || isempty(Opt.baseFlowIndex))
    Opt.baseFlowIndex=arrayfun(@(yearID) min(Opt.rolling7DayMeanByWYear{yearID})./(Opt.meanByWYear(yearID)), (1:numel(wYearList))');
  end
end

%%
baseFlowIndex=Opt.baseFlowIndex;
end