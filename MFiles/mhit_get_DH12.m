function [dh12,Opt]=mhit_get_DH12(discharge,wYear,wYearList,Opt)
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
  Opt.rolling7DayMeanByWYear=arrayfun( @(wy) conv(discharge(wYear==wy),ones(7,1)/7,'valid'), wYearList,'UniformOutput',false);
else
  if (~isfield(Opt,'medianDischarge') || isempty(Opt.medianDischarge))
    [~,Opt]=mhit_get_MA2(discharge,Opt);
  end
	if (~isfield(Opt,'rolling7DayMeanByWYear') || isempty(Opt.rolling7DayMeanByWYear))
    Opt.rolling7DayMeanByWYear=arrayfun( @(wy) conv(discharge(wYear==wy),ones(7,1)/7,'valid'), wYearList,'UniformOutput',false);
  end
end
%% calculating mh14
maxRolling7DayMeanByWYear=arrayfun(@(wyID) max(Opt.rolling7DayMeanByWYear{wyID}),(1:numel(Opt.rolling7DayMeanByWYear))');
dh12=mean(maxRolling7DayMeanByWYear)./Opt.medianDischarge;
end
