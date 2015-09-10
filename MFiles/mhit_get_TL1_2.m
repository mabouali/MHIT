function [tl1_2,Opt]=mhit_get_TL1_2(discharge,wYear,jDay,wYearList,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(wYear,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(jDay,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});

if (any(size(discharge)~=size(wYear)) || any(size(discharge)~=size(jDay)))
  error('discharge, wYear, month, and jDay must be of the same size.');
end

if (nargin<4 || isempty(wYearList))
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
   Opt.minByWYear=arrayfun( @(wy) nanmin(discharge(wYear==wy)), wYearList);
else
  if (~isfield(Opt,'minByWYear') || isempty(Opt.minByWYear))
    Opt.minByWYear=arrayfun( @(wy) nanmin(discharge(wYear==wy)), wYearList);
  end
end
%%

minJDays=cell2mat(arrayfun(@(wyID) jDay(discharge==Opt.minByWYear(wyID)), (1:numel(wYearList))','UniformOutput',false));

% wYearDays(minJDays>=274)= minJDays(minJDays>=274)-273;
% wYearDays(minJDays<274)= minJDays(minJDays<274)+92;

rad2day=(2*pi/365.25);
x= cos( minJDays * rad2day );
y= sin( minJDays * rad2day );

theta=atan2(mean(y),mean(x));

if theta<0
  theta=2*pi+theta;
end

tl1= theta / rad2day;

tl2=sqrt(2*(1-norm([mean(x),mean(y)])))/rad2day;

tl1_2=[tl1,tl2];
end
