function [mh21,Opt]=mhit_get_MH21(discharge,Opt)
validateattributes(discharge,{'single','double'},{'column'});

%% Checking Options
if (nargin<2 || isempty(Opt))
  [~,Opt]=mhit_get_MA2(discharge);
else
  if (~isfield(Opt,'medianDischarge') || isempty(Opt.medianDischarge))
    [~,Opt]=mhit_get_MA2(discharge,Opt);
  end
end

%%
mask=discharge>Opt.medianDischarge;

totalFlow=sum((discharge(mask)-Opt.medianDischarge));

nEvents=sum(diff([0;mask])>0);

mh21=totalFlow/nEvents/Opt.medianDischarge;

end