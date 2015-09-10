function [mh19,Opt]=mhit_get_MH19(discharge,wYear,wYearList,Opt)
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
  Opt.maxByWYear=arrayfun( @(wy) nanmax(discharge(wYear==wy)), wYearList);
else
  if (~isfield(Opt,'maxByWYear') || isempty(Opt.maxByWYear))
    Opt.maxByWYear=arrayfun( @(wy) nanmax(discharge(wYear==wy)), wYearList);
  end
end

%% calculating mh14
log10MaxByWYear=log10(Opt.maxByWYear);
nWYears=numel(wYearList);

sumLog10MaxDischargeByWyear=sum(log10MaxByWYear);
sumLog10MaxDischargeByWyearP2=sum(log10MaxByWYear.^2);
sumLog10MaxDischargeByWyearP3=sum(log10MaxByWYear.^3);

nom1=nWYears^2*sumLog10MaxDischargeByWyearP3;
nom2=3*nWYears*sumLog10MaxDischargeByWyear*sumLog10MaxDischargeByWyearP2;
nom3=2*sumLog10MaxDischargeByWyear^3;
denom=nWYears*(nWYears-1)*(nWYears-2)*std(log10MaxByWYear)^3;

mh19=(nom1+nom2+nom3)./denom;
end
