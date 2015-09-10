function [ma2,Opt]=mhit_get_MA2(discharge,Opt)
%% mhit_get_MA2: median of the daily mean flow values for the entire flow record

%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'})

%% calculating ma2
ma2=nanmedian(discharge);

Opt.medianDischarge=ma2;

end
