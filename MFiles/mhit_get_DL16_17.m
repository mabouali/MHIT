function [dl16_17,Opt]=mhit_get_DL16_17(discharge,wYear,wYearList,Opt)
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
  Opt.dischargePercentilesList=linspace(95,5,19)';
  Opt.dischargePercentiles=mhit_quantiles(discharge,Opt.dischargePercentilesList/100,6);
else
  if ( ~isfield(Opt,'dischargePercentilesList') || isempty(Opt.dischargePercentilesList))
    Opt.dischargePercentilesList=linspace(95,5,19)';
  else
    Opt.dischargePercentilesList=Opt.dischargePercentilesList(:); %making sure it is a column
  end
  if ( ~isfield(Opt,'dischargePercentiles') || isempty(Opt.dischargePercentiles))
    Opt.dischargePercentiles=mhit_quantiles(discharge,Opt.dischargePercentilesList/100,6);
  end
end
%% calculating mh14
thresh=Opt.dischargePercentiles(Opt.dischargePercentilesList==25);

eventMaskPerYear=arrayfun(@(wy) discharge(wYear==wy)<thresh , wYearList, 'UniformOutput',false);
totalEventsDurationPerYear=arrayfun(@(wyID) sum(eventMaskPerYear{wyID}), 1:numel(wYearList));
nEventsPerYear=arrayfun(@(wyID) sum(diff([0;eventMaskPerYear{wyID}])>0), 1:numel(wYearList));

avgEventDurationPerYear=totalEventsDurationPerYear./nEventsPerYear;
avgEventDurationPerYear(nEventsPerYear==0)=0;
dl16=nanmedian(avgEventDurationPerYear);
dl17=nanstd(avgEventDurationPerYear)./mean(avgEventDurationPerYear)*100;
dl16_17=[dl16,dl17];
end
