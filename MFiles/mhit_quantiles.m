function quantVec=mhit_quantiles(data,p,type)
%% Validating the inputs 
validateattributes(data,{'single','double'},{'column'})
validateattributes(p,{'single','double'},{'vector','>=',0,'<=',1});

%% set default type to 5; equivalent to matlabs' prctile and quantile function.
if (nargin<3 || isempty(type))
  type=5;
end

%% sort data if needed
data=data(~isnan(data));
if (~issorted(data))
  data=sort(data);
end

%% calculating the quantiles
nData=numel(data);
switch type
  case 5
    % this is the same as MATLAB's prctile or quantile function
    x=(0.5+(0:nData)')/nData;
    F=griddedInterpolant(x,data,'linear','linear');
    quantVec=F(p);
  case 6
    x=(1:nData)'./(nData+1);
    F=griddedInterpolant(x,data,'linear','linear');
    quantVec=F(p);
  otherwise
    error('requested type is not supported.')
end
end