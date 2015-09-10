function [dh14, Opt]=mhit_get_DH14(discharge,year,month,yearList,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(year,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(month,{'int8','int16','int32','int64','uint8','uint16','uint32','uint64','single','double'},{'column'});

if (any(size(discharge)~=size(year)) || any(size(discharge)~=size(month)))
  error('discharge, year, and month must be of the same size.');
end

if (nargin<4 || isempty(yearList))
  yearList=unique(year);
else
  validateattributes(yearList,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
  tmpYearList=unique(yearList);
  if (   (numel(tmpYearList) ~= numel(yearList)) ...
      ||  any(tmpYearList ~= yearList) )
    error('mhit_get_MA24_35: yearList must have unique values.');
  end
end

%% Checking Options
if (nargin<5 || isempty(Opt))
  Opt.meanByMonthYear=mhit_get_meanByMonthYear(discharge,year,yearList,month);
else
  if (~isfield(Opt,'meanByMonthYear') || isempty(Opt.meanByMonthYear))
    Opt.meanByMonthYear=mhit_get_meanByMonthYear(discharge,year,yearList,month);
  end
end
%% calculating ma36 to ma40
dh14=mhit_quantiles(Opt.meanByMonthYear(:),0.95,6)/nanmean(Opt.meanByMonthYear(:));
end
