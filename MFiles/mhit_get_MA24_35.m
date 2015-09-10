function [ma24_35,Opt]=mhit_get_MA24_35(discharge,year,month,yearList, Opt)
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
isSTDByMonthYearCalculated=false;
isMeanByMonthYearCalculated=false;
isCVByMonthYearCalculated=false;
needRecalculation=true;

if (nargin<5 || isempty(Opt))
  Opt.preference='mean';
  Opt.prefFun=mhit_getPrefFun(Opt.preference);
else
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'prefFun') || isempty(Opt.prefFun))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end
  if (~isfield(Opt,'stdByMonthYear') || ~isempty(Opt.stdByMonthYear))
    isSTDByMonthYearCalculated=false;
    needRecalculation=true;
  else
    isSTDByMonthYearCalculated=true;
  end
  if (~isfield(Opt,'meanByMonthYear') || isempty(Opt.meanByMonthYear))
    isMeanByMonthYearCalculated=false;
    needRecalculation=true;
  else
    isMeanByMonthYearCalculated=true;
  end
  if (~isfield(Opt,'cvByMonthYear') || isempty(Opt.cvByMonthYear))
    isCVByMonthYearCalculated=false;
    needRecalculation=true;
  else
    isCVByMonthYearCalculated=true;
  end
end

%% calculating ma24 to ma35
if (any([isSTDByMonthYearCalculated==false, ...
         isMeanByMonthYearCalculated==false, ...
         isCVByMonthYearCalculated==false]))
  needRecalculation=true;
end

if (needRecalculation==true)
  Opt.stdByMonthYear=zeros(numel(yearList),12,class(discharge)); %#ok<ZEROLIKE>
  Opt.meanByMonthYear=zeros(numel(yearList),12,class(discharge)); %#ok<ZEROLIKE>
  for yyyyID=1:numel(yearList)
    yearMask= year==yearList(yyyyID);
    for mm=1:12
      maskedData=discharge( yearMask & (month==mm));
      Opt.stdByMonthYear(yyyyID,mm)=nanstd(maskedData);
      Opt.meanByMonthYear(yyyyID,mm)=nanmean(maskedData);
    end
  end
  Opt.cvByMonthYear=Opt.stdByMonthYear./Opt.meanByMonthYear;
end

ma24_35(1,:)=Opt.prefFun(Opt.cvByMonthYear)*100;

end