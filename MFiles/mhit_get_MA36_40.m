function [ma36_40, Opt]=mhit_get_MA36_40(discharge,year,month,yearList,Opt)
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
  Opt.preference='mean';
  Opt.prefFun=mhit_getPrefFun(Opt.preference);
  Opt.meanByMonthYear=mhit_get_meanByMonthYear(discharge,year,yearList,month);
else
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'prefFun') || isempty(Opt.prefFun))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end
  if (~isfield(Opt,'meanByMonthYear') || isempty(Opt.meanByMonthYear))
    Opt.meanByMonthYear=mhit_get_meanByMonthYear(discharge,year,yearList,month);
  end
end
%% calculating ma36 to ma40

meanByMonth=Opt.meanByMonthYear(:);

percentiles=mhit_quantiles(meanByMonth,[10;25;75;90]/100,6);

medianMeanByMonth=nanmedian(meanByMonth);
meanMeanByMonth=nanmean(meanByMonth);

ma36=(max(meanByMonth)-min(meanByMonth))./medianMeanByMonth;
ma37=(percentiles(3)-percentiles(2))./medianMeanByMonth;
ma38=(percentiles(4)-percentiles(1))./medianMeanByMonth;
ma39=nanstd(meanByMonth)./meanMeanByMonth*100;
ma40=(meanMeanByMonth-medianMeanByMonth)./medianMeanByMonth;

ma36_40=[ma36,ma37,ma38,ma39,ma40];
end
