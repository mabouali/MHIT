function [ta1_2,Opt]=mhit_get_TA1_2(discharge,month,day,Opt)
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(month,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(day,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});

if ( any(size(discharge)~=size(month)) || any(size(discharge)~=size(day)) )
  error('discharge, month, and day must be of the same size.');
end

%% Checking Options
if (nargin<4 || isempty(Opt))
  [~,~,~,Opt]=mhit_get_colwellMat(discharge,month,day);
else
  if (   ~isfield(Opt,'ColwellMat') || isempty(Opt.ColwellMat) ...
      || ~isfield(Opt,'ColwellBounds') || isempty(Opt.ColwellBounds) ...
      || ~isfield(Opt,'CollwellLabels') || isempty(Opt.CollwellLabels) )
    [~,~,~,Opt]=mhit_get_colwellMat(discharge,month,day,Opt);
  end
end
%% Calculating TA1 and TA2
X=sum(Opt.ColwellMat,1);
Y=sum(Opt.ColwellMat,2);
Z=sum(X);

 HX = -sum((X(X>0)/Z).*log10(X(X>0)/Z));
 HY = -sum((Y(Y>0)/Z).*log10(Y(Y>0)/Z));
HXY = -sum( (Opt.ColwellMat(Opt.ColwellMat>0)/Z).*log10(Opt.ColwellMat(Opt.ColwellMat>0)/Z) );

ta1=1-HY./log10(11); %Constancy
ta2=1-(HXY-HX)./log10(11); %predictability

ta1_2=[ta1, ta2];
end

