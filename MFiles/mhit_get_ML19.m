function [ml19,Opt]=mhit_get_ML19(discharge,wYear,wYearList,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(wYear,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});

if ( any(size(discharge)~=size(wYear)) )
  error('discharge and year must be of the same size.');
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
  Opt.minByWYear=arrayfun( @(wy) nanmin(discharge(wYear==wy)), wYearList);
  Opt.meanByWYear=arrayfun( @(wy) nanmean(discharge(wYear==wy)), wYearList);
else
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'prefFun') || isempty(Opt.prefFun))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end 
  if (~isfield(Opt,'minByWYear') || isempty(Opt.minByWYear))
    Opt.minByWYear=arrayfun( @(wy) nanmin(discharge(wYear==wy)), wYearList);
  end
  if (~isfield(Opt,'meanByWYear') || isempty(Opt.meanByWYear))
    Opt.meanByWYear=arrayfun( @(wy) nanmean(discharge(wYear==wy)), wYearList);
  end
end

%%
ml19=Opt.prefFun(Opt.minByWYear./Opt.meanByWYear)*100;
end