function [fh8,Opt]=mhit_get_FH8(discharge,wYear,wYearList,Opt)
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
  Opt.dischargeExceedencePercentilesList=linspace(5,95,19)';
  Opt.dischargeExceedencePercentiles=mhit_quantiles(discharge,1-Opt.dischargeExceedencePercentilesList/100,6);
else
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'prefFun') || isempty(Opt.prefFun))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end  
  if ( ~isfield(Opt,'dischargeExceedencePercentilesList') || isempty(Opt.dischargeExceedencePercentilesList) )
    Opt.dischargeExceedencePercentilesList=linspace(5,95,19)';
  else
    Opt.dischargeExceedencePercentilesList=Opt.dischargeExceedencePercentilesList(:); %making sure it is a column
  end
  if ( ~isfield(Opt,'dischargeExceedencePercentiles') || isempty(Opt.dischargeExceedencePercentiles))
    Opt.dischargeExceedencePercentiles=mhit_quantiles(discharge,1-Opt.dischargeExceedencePercentilesList/100,6);
  end
end
%% calculating mh14
thresh=Opt.dischargeExceedencePercentiles(Opt.dischargeExceedencePercentilesList==25);

nEventsPerYear=arrayfun(@(wy) sum(diff([0;(discharge(wYear==wy)>thresh)])>0), wYearList);

fh8=Opt.prefFun(nEventsPerYear);
end
