function [ma12_23,Opt]=mhit_get_MA12_23(discharge,month,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(month,{'int8','int16','int32','int64','uint8','uint16','uint32','uint64','single','double'},{'column'});

if any(size(discharge)~=size(month))
  error('discharge and month must be the same size');
end

%% Checking Options
if (nargin<3 || isempty(Opt))
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

%% calculate ma12 to ma23
switch (upper(Opt.preference))
  case 'MEAN'
    if (~isfield(Opt,'meanByMonth') || isempty(Opt.meanByMonth))
      Opt.meanByMonth=arrayfun( @(mm) nanmean(discharge(month==mm)), 1:12);
    end
    ma12_23=Opt.meanByMonth;
  case 'MEDIAN'
    if (~isfield(Opt,'medianByMonth') || isempty(Opt.medianByMonth))
      Opt.medianByMonth=arrayfun( @(mm) nanmedian(discharge(month==mm)), 1:12);
    end
    ma12_23=Opt.medianByMonth;
  otherwise
    error('preference must be either Mean or Median.');
end
end
