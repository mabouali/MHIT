function [ma1,Opt]=mhit_get_MA1(discharge,Opt)
%% mhit_get_MA1: mean of the daily mean flow values for the entire flow record

%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'})

%% calculating ma1
ma1=nanmean(discharge);

Opt.meanDischarge=ma1;
end
