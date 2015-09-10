function [mh20,Opt]=mhit_get_MH20(discharge,wYear,wYearList,drainageArea,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(wYear,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(drainageArea,{'single','double'},{'scalar'});

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
if (nargin<5 || isempty(Opt))
  Opt.preference='mean';
  Opt.prefFun=mhit_getPrefFun(Opt.preference);
  Opt.maxByWYear=arrayfun( @(wy) nanmax(discharge(wYear==wy)), wYearList);
else
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'prefFun') || isempty(Opt.prefFun))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end
  if (~isfield(Opt,'maxByWYear') || isempty(Opt.maxByWYear))
    Opt.maxByWYear=arrayfun( @(wy) nanmax(discharge(wYear==wy)), wYearList);
  end
end

%% calculating mh20
mh20=Opt.prefFun(Opt.maxByWYear)/drainageArea;
end
