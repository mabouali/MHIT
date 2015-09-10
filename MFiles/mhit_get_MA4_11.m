function [ma4_11,Opt]=mhit_get_MA4_11(discharge,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'})

%% Checking Options
if (nargin<2 || isempty(Opt))
  Opt.dischargePercentilesList=linspace(95,5,19)';
  Opt.dischargeExceedencePercentilesList=100-Opt.dischargePercentilesList;
  Opt.dischargePercentiles=mhit_quantiles(discharge,Opt.dischargePercentilesList/100,6);
  Opt.dischargeExceedencePercentiles=Opt.dischargePercentiles;
  [~,Opt]=mhit_get_MA1(discharge,Opt);
  [~,Opt]=mhit_get_MA2(discharge,Opt);
else
  if ( ~isfield(Opt,'dischargePercentilesList') || isempty(Opt.dischargePercentilesList))
    Opt.dischargePercentilesList=linspace(95,5,19)';
  else
    Opt.dischargePercentilesList=Opt.dischargePercentilesList(:); %making sure it is a column
  end
  if ( ~isfield(Opt,'dischargePercentiles') || isempty(Opt.dischargePercentiles))
    Opt.dischargePercentiles=mhit_quantiles(discharge,Opt.dischargePercentilesList/100,6);
  end
  if ( ~isfield(Opt,'dischargeExceedencePercentilesList') || isempty(Opt.dischargeExceedencePercentilesList) )
    Opt.dischargeExceedencePercentilesList=100-Opt.dischargePercentilesList;
  else
    Opt.dischargeExceedencePercentilesList=Opt.dischargeExceedencePercentilesList(:); %making sure it is a column
  end
  if ( ~isfield(Opt,'dischargeExceedencePercentiles') || isempty(Opt.dischargeExceedencePercentiles))
    if (all(Opt.dischargeExceedencePercentilesList==(100-Opt.dischargePercentilesList)))
      Opt.dischargeExceedencePercentiles=Opt.dischargePercentiles;
    else
      Opt.dischargeExceedencePercentiles=mhit_quantiles(discharge,1-Opt.dischargeExceedencePercentilesList/100,6);
    end
  end
  if (~isfield(Opt,'meanDischarge') || isempty(Opt.meanDischarge))
    [~,Opt]=mhit_get_MA1(discharge,Opt);
  end
  if (~isfield(Opt,'medianDischarge') || isempty(Opt.medianDischarge))
    [~,Opt]=mhit_get_MA2(discharge,Opt);
  end
end

%% calculate ma4 to ma11
meanPrct=mean(Opt.dischargePercentiles);
stdPrct=std(Opt.dischargePercentiles);

ma4  = stdPrct./meanPrct * 100;
ma5  = Opt.meanDischarge ./ Opt.medianDischarge;
ma6  = Opt.dischargeExceedencePercentiles(Opt.dischargeExceedencePercentilesList==10)./Opt.dischargeExceedencePercentiles(Opt.dischargeExceedencePercentilesList==90);
ma7  = Opt.dischargeExceedencePercentiles(Opt.dischargeExceedencePercentilesList==20)./Opt.dischargeExceedencePercentiles(Opt.dischargeExceedencePercentilesList==80);
ma8  = Opt.dischargeExceedencePercentiles(Opt.dischargeExceedencePercentilesList==25)./Opt.dischargeExceedencePercentiles(Opt.dischargeExceedencePercentilesList==75);
ma9  = (Opt.dischargePercentiles(Opt.dischargePercentilesList==90) - Opt.dischargePercentiles(Opt.dischargePercentilesList==10))/Opt.medianDischarge;
ma10 = (Opt.dischargePercentiles(Opt.dischargePercentilesList==80) - Opt.dischargePercentiles(Opt.dischargePercentilesList==20))/Opt.medianDischarge;
ma11 = (Opt.dischargePercentiles(Opt.dischargePercentilesList==75) - Opt.dischargePercentiles(Opt.dischargePercentilesList==25))/Opt.medianDischarge;

ma4_11 = [ma4,ma5,ma6,ma7,ma8,ma9,ma10,ma11];
end
