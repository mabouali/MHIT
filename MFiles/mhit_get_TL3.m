function [tl3,Opt]=mhit_get_TL3(discharge,wYear,month,jDay,wYearList,Opt)
%% Validating the inputs 
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(wYear,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(month,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(jDay,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});

if (any(size(discharge)~=size(wYear)) || any(size(discharge)~=size(month)) || any(size(discharge)~=size(jDay)))
  error('discharge, wYear, month, and jDay must be of the same size.');
end

if (nargin<5 || isempty(wYearList))
  wYearList=unique(wYear);
else
  validateattributes(wYearList,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
  tmpWYearList=unique(wYearList);
  if (   (numel(tmpWYearList) ~= numel(wYearList)) ...
      ||  any(tmpWYearList ~= wYearList) )
    error('mhit_get_MA3: wYearList must have unique values.');
  end
end

%% Checking Options
if (nargin<6 || isempty(Opt))
  [~,Opt]=mhit_get_peakThresh(discharge,wYear,jDay,wYearList,[0.4;0.8]);
else
  if (   ~isfield(Opt,'peakThreshPrct') || isempty(Opt.peakThreshPrct) ...
      || ~isfield(Opt,'peakThresh') || isempty(Opt.peakThresh))
    [~,Opt]=mhit_get_peakThresh(discharge,wYear,jDay,wYearList,[0.4;0.8],Opt);
  end
end
%% calculating mh14
thresh=Opt.peakThresh(Opt.peakThreshPrct==80);

periods=[10,11; ...
         12, 1; ...
          2, 3; ...
          4, 5; ...
          6, 7; ...
          8, 9];

nEventsDayByPeriod=arrayfun(@(mmID) sum(discharge( (month==periods(mmID,1)) | (month==periods(mmID,2)) ) <= thresh), ...
                            1:6);

tl3=max(nEventsDayByPeriod)./sum(nEventsDayByPeriod);
end
