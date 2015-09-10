function [fl3,Opt]=mhit_get_FL3(discharge,wYear,wYearList,Opt)
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
  [~,Opt]=mhit_get_MA1(discharge,Opt);
else
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end  
  if (~isfield(Opt,'meanDischarge') || isempty(Opt.meanDischarge))
    [~,Opt]=mhit_get_MA1(discharge,Opt);
  end
end
%% calculating mh14
thresh = 0.05 * Opt.meanDischarge;

nEventsPerYear=arrayfun(@(wy) sum(diff([0;(discharge(wYear==wy)<thresh)])>0), wYearList);

fl3= Opt.prefFun(nEventsPerYear);

end
