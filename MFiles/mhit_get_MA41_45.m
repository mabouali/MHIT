function [ma41_45,Opt]=mhit_get_MA41_45(discharge,wYear,month,wYearList,drainageArea,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(wYear,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(month,{'int8','int16','int32','int64','uint8','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(drainageArea,{'single','double'},{'scalar'});

if (any(size(discharge)~=size(wYear)) || any(size(discharge)~=size(month)))
  error('discharge, year, and month must be of the same size.');
end

if (nargin<4 || isempty(wYearList))
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
if (nargin<6 || isempty(Opt))
  Opt.meanByWYear=arrayfun( @(wy) nanmean(discharge(wYear==wy)), wYearList);
else
  if (~isfield(Opt,'meanByWYear') || isempty(Opt.meanByWYear))
    Opt.meanByWYear=arrayfun( @(wy) nanmean(discharge(wYear==wy)), wYearList);
  end
end

%% calculating ma41 to ma45
percentiles=mhit_quantiles(Opt.meanByWYear,[10;25;75;90]/100,6);

meanMeanByWYear=mean(Opt.meanByWYear);
medianMeanByWYear=median(Opt.meanByWYear);

ma41=meanMeanByWYear./drainageArea;
ma42=(max(Opt.meanByWYear)-min(Opt.meanByWYear))./medianMeanByWYear;
ma43=(percentiles(3)-percentiles(2))./medianMeanByWYear;
ma44=(percentiles(4)-percentiles(1))./medianMeanByWYear;
ma45=(meanMeanByWYear-medianMeanByWYear)./medianMeanByWYear;

ma41_45=[ma41,ma42,ma43,ma44,ma45];
end