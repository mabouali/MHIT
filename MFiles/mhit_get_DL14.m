function [dl14,Opt]=mhit_get_DL14(discharge,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});

%% Checking Options
if (nargin<2 || isempty(Opt))
  [~,Opt]=mhit_get_MA2(discharge);
  Opt.dischargeExceedencePercentilesList=linspace(5,95,19)';
  Opt.dischargeExceedencePercentiles=mhit_quantiles(discharge,1 - Opt.dischargeExceedencePercentilesList/100,6);
else
  if (~isfield(Opt,'medianDischarge') || isempty(Opt.medianDischarge))
    [~,Opt]=mhit_get_MA2(discharge,Opt);
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
dl14=Opt.dischargeExceedencePercentiles( Opt.dischargeExceedencePercentilesList==75 )./Opt.medianDischarge;
end
