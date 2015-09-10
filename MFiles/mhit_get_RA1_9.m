function [ra1_9,Opt]=mhit_get_RA(discharge,wYear,wYearList,Opt)
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
  Opt.preference='mean';
  Opt.prefFun=mhit_getPrefFun(Opt.preference);
else
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'prefFun') || isempty(Opt.prefFun))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end
end

%%
dDischarge=diff(discharge);
positiveChangeMask=dDischarge>0;
negativeChangeMask=dDischarge<0;

positiveChanges=dDischarge(positiveChangeMask);
negativeChanges=dDischarge(negativeChangeMask);

ra1=Opt.prefFun(positiveChanges);
ra2=std(positiveChanges)/mean(positiveChanges)*100;

ra3=Opt.prefFun(negativeChanges);
ra4=std(negativeChanges)/mean(negativeChanges)*100;

nFlowRecords=sum(~isnan(discharge));
ra5=numel(positiveChanges)/nFlowRecords;

log10Discharge=log10(discharge+eps);
dLog10Discharge=diff(log10Discharge);
ra6=median(dLog10Discharge(positiveChangeMask));
ra7=median(dLog10Discharge(negativeChangeMask));

reversalStartDay=find(    (positiveChangeMask(1:end-1) & negativeChangeMask(2:end)) ...
                        | (positiveChangeMask(2:end) & negativeChangeMask(1:end-1)) );

nReversalDaysByWYear=zeros(numel(wYearList),1);
for wyID=1:numel(wYearList)
  wYearMask= wYear==wYearList(wyID);
  nReversalDaysByWYear(wyID)=sum(   reversalStartDay>=find(wYearMask,1,'first') ...
                                  & reversalStartDay<find(wYearMask,1,'last'));
end

ra8=Opt.prefFun(nReversalDaysByWYear);
ra9=std(nReversalDaysByWYear)/mean(nReversalDaysByWYear)*100;
if isnan(ra9)
  ra9=0;
end

ra1_9=[ra1, ra2, ra3, ra4, ra5, ra6, ra7, ra8, ra9];
end
