function ml20=mhit_get_ML20(discharge)
%% NOTE: 
%    Discharge is assumed to be sequential, meaning the days are in order.

%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});

%%
% Removing NaN from the data set
discharge=discharge(~isnan(discharge));

% Calculating number of blocks;
n5DayBlocks=floor(numel(discharge)/5);
if (n5DayBlocks==0)
  error('mhit_get_ML20: not enough data.')
end

% Resizing discharge into 5 days blocks.
% 
discharge=reshape(discharge(1:(n5DayBlocks*5)),5,[]);
minBlocks=min(discharge);

% Keeping the most left and right item.
% In the middle if 90% of the minimum of the blocks is less than the
% minumum of the both adjacent blocks we keep it.
 maskLeft = (0.9*minBlocks(2:end-1))<(minBlocks(1:end-2));
maskRight = (0.9*minBlocks(2:end-1))<(minBlocks(3:end));
mask=[true (maskLeft & maskRight) true];

% Interpolating those records that are dropped
x=1:n5DayBlocks;
F=griddedInterpolant(x(mask),minBlocks(mask));
minBlocks(~mask)=F(x(~mask));

% calculating flow
totalFlow=sum(sum(discharge));
totalBlockFlow=sum(minBlocks*5);

ml20=totalFlow/totalBlockFlow;



end