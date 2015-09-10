function [mh15_17,Opt]=mhit_get_MH15_17(discharge,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'})

%% Checking Options
if (nargin<2 || isempty(Opt))
  Opt.dischargeExceedencePercentilesList=linspace(5,95,19)';
  Opt.dischargeExceedencePercentiles=mhit_quantiles(discharge,1-Opt.dischargeExceedencePercentilesList/100,6);
  [~,Opt]=mhit_get_MA2(discharge,Opt);
else
  if ( ~isfield(Opt,'dischargeExceedencePercentilesList') || isempty(Opt.dischargeExceedencePercentilesList) )
    Opt.dischargeExceedencePercentilesList=linspace(5,95,19)';
  else
    Opt.dischargeExceedencePercentilesList=Opt.dischargeExceedencePercentilesList(:); %making sure it is a column
  end
  if ( ~isfield(Opt,'dischargeExceedencePercentiles') || isempty(Opt.dischargeExceedencePercentiles))
    Opt.dischargeExceedencePercentiles=mhit_quantiles(discharge,1-Opt.dischargeExceedencePercentilesList/100,6);
  end
  if (~isfield(Opt,'medianDischarge') || isempty(Opt.medianDischarge))
    [~,Opt]=mhit_get_MA2(discharge,Opt);
  end
end

%% calculate mh15 to mh17
dischargeExceedence1prct=mhit_quantiles(discharge,1-1/100,6);

mh15=dischargeExceedence1prct/Opt.medianDischarge;
mh16= Opt.dischargeExceedencePercentiles(Opt.dischargeExceedencePercentilesList==10)/Opt.medianDischarge;
mh17= Opt.dischargeExceedencePercentiles(Opt.dischargeExceedencePercentilesList==25)/Opt.medianDischarge;
mh15_17=[mh15,mh16,mh17];
end
