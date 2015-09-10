function [dl13,Opt]=mhit_get_DL13(discharge,wYear,wYearList,Opt)
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
  Opt.rolling30DayMeanByWYear=arrayfun( @(wy) conv(discharge(wYear==wy),ones(30,1)/30,'valid'), wYearList,'UniformOutput',false);
else
  if (~isfield(Opt,'medianDischarge') || isempty(Opt.medianDischarge))
    [~,Opt]=mhit_get_MA2(discharge,Opt);
  end
	if (~isfield(Opt,'rolling30DayMeanByWYear') || isempty(Opt.rolling30DayMeanByWYear))
    Opt.rolling30DayMeanByWYear=arrayfun( @(wy) conv(discharge(wYear==wy),ones(30,1)/30,'valid'), wYearList,'UniformOutput',false);
  end
end
%% calculating mh14
minRolling30DayMeanByWYear=arrayfun(@(wyID) min(Opt.rolling30DayMeanByWYear{wyID}),(1:numel(Opt.rolling30DayMeanByWYear))');
dl13=mean(minRolling30DayMeanByWYear)./Opt.medianDischarge;
end
