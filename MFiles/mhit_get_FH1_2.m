function [fh1_2,Opt]=mhit_get_FH1_2(discharge,wYear,wYearList,Opt)
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
  Opt.dischargePercentilesList=linspace(95,5,19)';
  Opt.dischargePercentiles=mhit_quantiles(discharge,Opt.dischargePercentilesList/100,6);
else
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'prefFun') || isempty(Opt.prefFun))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end  
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
thresh=Opt.dischargePercentiles(Opt.dischargePercentilesList==75);

nEventsPerYear=arrayfun(@(wy) sum(diff([0;(discharge(wYear==wy)>thresh)])>0), wYearList);

fh1= Opt.prefFun(nEventsPerYear);

fh2= std(nEventsPerYear)/mean(nEventsPerYear)*100;

fh1_2=[fh1, fh2];
end
