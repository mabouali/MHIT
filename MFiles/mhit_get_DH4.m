function [dh4,Opt]=mhit_get_DH4(discharge,wYear,wYearList,Opt)
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
  Opt.rolling30DayMeanByWYear=arrayfun( @(wy) conv(discharge(wYear==wy),ones(30,1)/30,'valid'), wYearList,'UniformOutput',false);
else
  if (~isfield(Opt,'preference') || isempty(Opt.preference))
    Opt.preference='mean';
  end
  if (~isfield(Opt,'prefFun') || isempty(Opt.prefFun))
    Opt.prefFun=mhit_getPrefFun(Opt.preference);
  end  
	if (~isfield(Opt,'rolling30DayMeanByWYear') || isempty(Opt.rolling30DayMeanByWYear))
    Opt.rolling30DayMeanByWYear=arrayfun( @(wy) conv(discharge(wYear==wy),ones(30,1)/30,'valid'), wYearList,'UniformOutput',false);
  end
end
%% calculating mh14
maxRolling30DayMeanByWYear=arrayfun(@(wyID) max(Opt.rolling30DayMeanByWYear{wyID}),(1:numel(Opt.rolling30DayMeanByWYear))');
dh4=Opt.prefFun(maxRolling30DayMeanByWYear);
end
