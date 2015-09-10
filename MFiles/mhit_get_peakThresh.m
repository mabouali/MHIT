function [peakThresh,Opt]=mhit_get_peakThresh(discharge,wYear,jDay,wYearList,prct,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(wYear,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(jDay,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(prct,{'single','double'},{'column','vector','>=',0,'<=',1});

if (any(size(discharge)~=size(wYear)))
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
  Opt.maxByWYear=arrayfun( @(wy) nanmax(discharge(wYear==wy)), wYearList);
else
  if (~isfield(Opt,'maxByWYear') || isempty(Opt.maxByWYear))
    Opt.maxByWYear=arrayfun( @(wy) nanmax(discharge(wYear==wy)), wYearList);
  end
end

%%
%NOTE; if discharge has daily resolution meanDailyFlow and maxByWYear flow
%would be the same numbers.
meanDailyFlow=zeros(numel(wYearList),1);
for wyID=1:numel(wYearList)
  maskedData=discharge(wYear==wYearList(wyID));
  maskedDays=jDay(wYear==wYearList(wyID));
  DayOfMaxFlow = maskedDays( find( maskedData==Opt.maxByWYear(wyID),1,'first') );
  
  
  meanDailyFlow(wyID)=mean(maskedData(maskedDays==DayOfMaxFlow));
end

%% Forming regression
x=log10(Opt.maxByWYear);
y=log10(meanDailyFlow);
p=polyfit(x,y,1);

thresh=mhit_quantiles(x,prct,6);

peakThresh=10.^polyval(p,thresh);

Opt.peakThreshPrct=prct*100;
Opt.peakThresh=peakThresh;

end
