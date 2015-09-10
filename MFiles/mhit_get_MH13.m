function [mh13,Opt]=mhit_get_MH13(discharge,year,month,yearList,Opt)
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
  Opt.maxByMonthYear=mhit_get_maxByMonthYear(discharge,year,yearList,month);
else
  if (~isfield(Opt,'maxByMonthYear') || isempty(Opt.maxByMonthYear))
    Opt.maxByMonthYear=mhit_get_maxByMonthYear(discharge,year,yearList,month);
  end
end

%% calculating ml1 to m12
mh13=nanstd(Opt.maxByMonthYear(:))./nanmean(Opt.maxByMonthYear(:))*100;
end
