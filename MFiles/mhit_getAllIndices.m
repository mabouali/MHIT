function [allIndices,Opt]=mhit_getAllIndices(discharge,year,month,day,drainageArea,Opt)
%% Validating inputs
validateattributes(discharge,{'single','double'},{'column'});
validateattributes(year,{'int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(month,{'int8','int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(day,{'int8','int16','int32','int64','uint16','uint32','uint64','single','double'},{'column'});
validateattributes(drainageArea,{'single','double'},{'scalar'});

%% Checking sizes
if ( numel(discharge)~=numel(year) || ...
     numel(discharge)~=numel(month) || ...
     numel(discharge)~=numel(day) )
   error('mhit_getAllIndices: discharge, year, month, and day must have the same number of elements.');
else
  nData=numel(discharge);
end

%% Checking Options
if ( (nargin<6) || isempty(Opt))
  Opt.isSorted=issorted([year,month,day],'rows');
else
  if (~isfield(Opt,'isSorted') || isempty(Opt.isSorted))
    Opt.isSorted=issorted([year,month,day],'rows');
  end
end

%% Sorting data if needed
if (~Opt.isSorted)
  tmpSortedData=sortrows([year,month,day, (1:nData)'],[1,2,3]);
  discharge=discharge(tmpSortedData(:,4));
  year=year(tmpSortedData(:,4));
  month=month(tmpSortedData(:,4));
  day=day(tmpSortedData(:,4));
  clear tmpSortedData;
end

%% Making sure everything has proper type
discharge=double(discharge);
year=uint16(year);
month=uint16(month);
day=uint16(day);
drainageArea=double(drainageArea);

%% Calculate some parameters
jDay=datenum(double(year),double(month),double(day))-datenum(double(year),1,1)+1;
wYear=year+uint16((month>=10));
wYearList=unique(wYear);
yearList=unique(year);

%% Calculating all indices
%% MA
allIndices.MA=nan(1,45);
[allIndices.MA(1),Opt]=mhit_get_MA1(discharge,Opt); 
[allIndices.MA(2),Opt]=mhit_get_MA2(discharge,Opt);
[allIndices.MA(3),Opt]=mhit_get_MA3(discharge,wYear,wYearList,Opt);
[allIndices.MA(4:11),Opt]=mhit_get_MA4_11(discharge,Opt);
[allIndices.MA(12:23),Opt]=mhit_get_MA12_23(discharge,month,Opt);
[allIndices.MA(24:35),Opt]=mhit_get_MA24_35(discharge,year,month,yearList,Opt);
[allIndices.MA(36:40),Opt]=mhit_get_MA36_40(discharge,year,month,yearList,Opt);
[allIndices.MA(41:45),Opt]=mhit_get_MA41_45(discharge,wYear,month,wYearList,drainageArea,Opt);

%% ML
allIndices.ML=nan(1,22);
[allIndices.ML(1:12),Opt]=mhit_get_ML1_12(discharge,year,month,yearList,Opt);
[allIndices.ML(13),Opt]=mhit_get_ML13(discharge,year,month,yearList,Opt);
[allIndices.ML(14:16),Opt]=mhit_get_ML14_16(discharge,wYear,wYearList,Opt);
[allIndices.ML(17),Opt]=mhit_get_ML17(discharge,wYear,wYearList,Opt);
[allIndices.ML(18),Opt]=mhit_get_ML18(discharge,wYear,wYearList,Opt);
[allIndices.ML(19),Opt]=mhit_get_ML19(discharge,wYear,wYearList,Opt);
allIndices.ML(20)=mhit_get_ML20(discharge);
[allIndices.ML(21),Opt]=mhit_get_ML21(discharge,wYear,wYearList,Opt);
[allIndices.ML(22),Opt]=mhit_get_ML22(discharge,wYear,wYearList,2,Opt);

%% MH
allIndices.MH=nan(1,27);
[allIndices.MH(1:12),Opt]=mhit_get_MH1_12(discharge,year,month,yearList,Opt);
[allIndices.MH(13),Opt]=mhit_get_MH13(discharge,year,month,yearList,Opt);
[allIndices.MH(14),Opt]=mhit_get_MH14(discharge,wYear,wYearList,Opt);
[allIndices.MH(15:17),Opt]=mhit_get_MH15_17(discharge,Opt);
[allIndices.MH(18),Opt]=mhit_get_MH18(discharge,wYear,wYearList,Opt);
[allIndices.MH(19),Opt]=mhit_get_MH19(discharge,wYear,wYearList,Opt);
[allIndices.MH(20),Opt]=mhit_get_MH20(discharge,wYear,wYearList,2,Opt);
[allIndices.MH(21),Opt]=mhit_get_MH21(discharge,Opt);
[allIndices.MH(22),Opt]=mhit_get_MH22(discharge,Opt);
[allIndices.MH(23),Opt]=mhit_get_MH23(discharge,Opt);
[allIndices.MH(24),Opt]=mhit_get_MH24(discharge,Opt);
[allIndices.MH(25),Opt]=mhit_get_MH25(discharge,Opt);
[allIndices.MH(26),Opt]=mhit_get_MH26(discharge,Opt);
[allIndices.MH(27),Opt]=mhit_get_MH27(discharge,Opt);

%% FL
allIndices.FL=nan(1,3);
[allIndices.FL(1:2),Opt]=mhit_get_FL1_2(discharge,wYear,wYearList,Opt);
[allIndices.FL(3),Opt]=mhit_get_FL3(discharge,wYear,wYearList,Opt);

%% FH
allIndices.FH=nan(1,11);
[allIndices.FH(1:2),Opt]=mhit_get_FH1_2(discharge,wYear,wYearList,Opt);
[allIndices.FH(3),Opt]=mhit_get_FH3(discharge,wYear,wYearList,Opt);
[allIndices.FH(4),Opt]=mhit_get_FH4(discharge,wYear,wYearList,Opt);
[allIndices.FH(5),Opt]=mhit_get_FH5(discharge,wYear,wYearList,Opt);
[allIndices.FH(6),Opt]=mhit_get_FH6(discharge,wYear,wYearList,Opt);
[allIndices.FH(7),Opt]=mhit_get_FH7(discharge,wYear,wYearList,Opt);
[allIndices.FH(8),Opt]=mhit_get_FH8(discharge,wYear,wYearList,Opt);
[allIndices.FH(9),Opt]=mhit_get_FH9(discharge,wYear,wYearList,Opt);
[allIndices.FH(10),Opt]=mhit_get_FH10(discharge,wYear,wYearList,Opt);
[allIndices.FH(11),Opt]=mhit_get_FH11(discharge,wYear,jDay,wYearList,Opt);

%% DL
allIndices.DL=nan(1,20);
[allIndices.DL(1),Opt]=mhit_get_DL1(discharge,wYear,wYearList,Opt);
[allIndices.DL(2),Opt]=mhit_get_DL2(discharge,wYear,wYearList,Opt);
[allIndices.DL(3),Opt]=mhit_get_DL3(discharge,wYear,wYearList,Opt);
[allIndices.DL(4),Opt]=mhit_get_DL4(discharge,wYear,wYearList,Opt);
[allIndices.DL(5),Opt]=mhit_get_DL5(discharge,wYear,wYearList,Opt);
[allIndices.DL(6),Opt]=mhit_get_DL6(discharge,wYear,wYearList,Opt);
[allIndices.DL(7),Opt]=mhit_get_DL7(discharge,wYear,wYearList,Opt);
[allIndices.DL(8),Opt]=mhit_get_DL8(discharge,wYear,wYearList,Opt);
[allIndices.DL(9),Opt]=mhit_get_DL9(discharge,wYear,wYearList,Opt);
[allIndices.DL(10),Opt]=mhit_get_DL10(discharge,wYear,wYearList,Opt);
[allIndices.DL(11),Opt]=mhit_get_DL11(discharge,wYear,wYearList,Opt);
[allIndices.DL(12),Opt]=mhit_get_DL12(discharge,wYear,wYearList,Opt);
[allIndices.DL(13),Opt]=mhit_get_DL13(discharge,wYear,wYearList,Opt);
[allIndices.DL(14),Opt]=mhit_get_DL14(discharge,Opt);
[allIndices.DL(15),Opt]=mhit_get_DL15(discharge,Opt);
[allIndices.DL(16:17),Opt]=mhit_get_DL16_17(discharge,wYear,wYearList,Opt);
[allIndices.DL(18:19),Opt]=mhit_get_DL18_19(discharge,wYear,wYearList,Opt);
[allIndices.DL(20),Opt]=mhit_get_DL20(discharge,year,month,yearList,Opt);

%% DH
allIndices.DH=nan(1,24);
[allIndices.DH(1),Opt]=mhit_get_DH1(discharge,wYear,wYearList,Opt);
[allIndices.DH(2),Opt]=mhit_get_DH2(discharge,wYear,wYearList,Opt);
[allIndices.DH(3),Opt]=mhit_get_DH3(discharge,wYear,wYearList,Opt);
[allIndices.DH(4),Opt]=mhit_get_DH4(discharge,wYear,wYearList,Opt);
[allIndices.DH(5),Opt]=mhit_get_DH5(discharge,wYear,wYearList,Opt);
[allIndices.DH(6),Opt]=mhit_get_DH6(discharge,wYear,wYearList,Opt);
[allIndices.DH(7),Opt]=mhit_get_DH7(discharge,wYear,wYearList,Opt);
[allIndices.DH(8),Opt]=mhit_get_DH8(discharge,wYear,wYearList,Opt);
[allIndices.DH(9),Opt]=mhit_get_DH9(discharge,wYear,wYearList,Opt);
[allIndices.DH(10),Opt]=mhit_get_DH10(discharge,wYear,wYearList,Opt);
[allIndices.DH(11),Opt]=mhit_get_DH11(discharge,wYear,wYearList,Opt);
[allIndices.DH(12),Opt]=mhit_get_DH12(discharge,wYear,wYearList,Opt);
[allIndices.DH(13),Opt]=mhit_get_DH13(discharge,wYear,wYearList,Opt);
[allIndices.DH(14),Opt]=mhit_get_DH14(discharge,year,month,yearList,Opt);
[allIndices.DH(15:16),Opt]=mhit_get_DH15_16(discharge,wYear,wYearList,Opt);
[allIndices.DH(17),Opt]=mhit_get_DH17(discharge,wYear,wYearList,Opt);
[allIndices.DH(18),Opt]=mhit_get_DH18(discharge,wYear,wYearList,Opt);
[allIndices.DH(19),Opt]=mhit_get_DH19(discharge,wYear,wYearList,Opt);
[allIndices.DH(20),Opt]=mhit_get_DH20(discharge,wYear,wYearList,Opt);
[allIndices.DH(21),Opt]=mhit_get_DH21(discharge,wYear,wYearList,Opt);
[allIndices.DH(22),Opt]=mhit_get_DH22(discharge,wYear,jDay,wYearList,Opt);
[allIndices.DH(23),Opt]=mhit_get_DH23(discharge,wYear,jDay,wYearList,Opt);
[allIndices.DH(24),Opt]=mhit_get_DH24(discharge,wYear,jDay,wYearList,Opt);

%% TA
allIndices.TA=nan(1,3);
[allIndices.TA(1:2),Opt]=mhit_get_TA1_2(discharge,month,day,Opt);
[allIndices.TA(3),Opt]=mhit_get_TA3(discharge,wYear,month,jDay,wYearList,Opt);

%% TL
allIndices.TL=nan(1,4);
[allIndices.TL(1:2),Opt]=mhit_get_TL1_2(discharge,wYear,jDay,wYearList,Opt);
[allIndices.TL(3),Opt]=mhit_get_TL3(discharge,wYear,month,jDay,wYearList,Opt);
[allIndices.TL(4),Opt]=mhit_get_TL4(discharge,wYear,jDay,wYearList,Opt);

%% TH
allIndices.TH=nan(1,3);
[allIndices.TH(1:2),Opt]=mhit_get_TH1_2(discharge,wYear,jDay,wYearList,Opt);
[allIndices.TH(3),Opt]=mhit_get_TH3(discharge,wYear,jDay,wYearList,Opt);

%% RA
[allIndices.RA,Opt]=mhit_get_RA1_9(discharge,wYear,wYearList,Opt);
end
