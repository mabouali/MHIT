function [mh27,Opt]=mhit_get_MH27(discharge,Opt)
validateattributes(discharge,{'single','double'},{'column'});

%% Checking Options
if (nargin<2 || isempty(Opt))
  [~,Opt]=mhit_get_MA2(discharge);
  Opt.dischargePercentilesList=linspace(95,5,19)';
  Opt.dischargePercentiles=mhit_quantiles(discharge,Opt.dischargePercentilesList/100,6);
else
  if (~isfield(Opt,'medianDischarge') || isempty(Opt.medianDischarge))
    [~,Opt]=mhit_get_MA2(discharge,Opt);
  end
  if ( ~isfield(Opt,'dischargePercentilesList') || isempty(Opt.dischargePercentilesList))
    Opt.dischargePercentilesList=linspace(95,5,19)';
  else
    Opt.dischargePercentilesList=Opt.dischargePercentilesList(:); %making sure it is a column
  end
  if ( ~isfield(Opt,'dischargePercentiles') || isempty(Opt.dischargePercentiles))
    Opt.dischargePercentiles=mhit_quantiles(discharge,Opt.dischargePercentilesList/100,6);
  end
end

%%
mask=discharge>Opt.dischargePercentiles(Opt.dischargePercentilesList==75);

eventStart=find(diff([0;mask])>0);
eventEnd=find(diff([mask;0])<0);
if (numel(eventStart)~=numel(eventEnd))
  error('mhit_get_MH24: couldn''t properly recognize the events.')
end

peaksVec=arrayfun(@(eventID) max(discharge(eventStart(eventID):eventEnd(eventID))), 1:numel(eventStart));

mh27=mean(peaksVec)/Opt.medianDischarge;

end