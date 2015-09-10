function [ma3,Opt]=mhit_get_MA3(discharge,wYear,wYearList,Opt)
%% mhit_get_MA3: Mean (or median - use the preference option) of the 
%  coefficiant of variation.

%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(wYear,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});

if any(size(discharge)~=size(wYear))
  error('discharge and wYear must be same size.');
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
  Opt.stdByWYear=arrayfun( @(wy) nanstd(discharge(wYear==wy)), wYearList);
  Opt.meanByWYear=arrayfun( @(wy) nanmean(discharge(wYear==wy)), wYearList);
  Opt.cvByWYear=Opt.stdByWYear ./ Opt.meanByWYear;
else
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'prefFun') || isempty(Opt.prefFun))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end
  if (~isfield(Opt,'stdByWYear') || isempty(Opt.stdByWYear))
    Opt.stdByWYear=arrayfun( @(wy) nanstd(discharge(wYear==wy)), wYearList);
  end
  if (~isfield(Opt,'meanByWYear') || isempty(Opt.meanByWYear))
    Opt.meanByWYear=arrayfun( @(wy) nanmean(discharge(wYear==wy)), wYearList);
  end
  if (~isfield(Opt,'cvByWYear') || isempty(Opt.cvByWYear))
    Opt.cvByWYear=Opt.stdByWYear ./ Opt.meanByWYear;
  end
end

%% Calculating ma3
ma3=Opt.prefFun(Opt.cvByWYear)*100;

end
