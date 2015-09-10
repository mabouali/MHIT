function [dl6,Opt]=mhit_get_DL6(discharge,wYear,wYearList,Opt)
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
  Opt.minByWYear=arrayfun( @(wy) nanmin(discharge(wYear==wy)), wYearList);
else
  if (~isfield(Opt,'minByWYear') || isempty(Opt.minByWYear))
    Opt.minByWYear=arrayfun( @(wy) nanmin(discharge(wYear==wy)), wYearList);
  end
end
%% calculating mh14
dl6=std(Opt.minByWYear)./mean(Opt.minByWYear)*100;
end
