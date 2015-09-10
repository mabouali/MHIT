%% Test1
% This example calculates all the indices one by one. Everything here is
% handled manually. 
% Make sure to check Test2 for an easier way to calculate all the indices.

clear;
clc;
close all;
%%
filename   = 'reach13639.csv';
dataFolder = '..\Data';

%% Reading Data file
data = readtable(fullfile(dataFolder,filename));

%% Reading the drainage area
drainageAreaTBL = readtable(fullfile(dataFolder,'drainageArea.csv'));

%% finding the drainage Area in the table
drainageArea = drainageAreaTBL.drainageArea( strcmpi(drainageAreaTBL.fileName,filename) );

%% calculating water year and some needed parameters
wYear = data.year + (data.month>=10);
wYearList=unique(wYear);
yearList=unique(data.year);
jDay=datenum(data.year,data.month,data.day)-datenum(data.year,1,1)+1;

tic;
%% MA1 to MA45 indices
[ma1,Opt]=mhit_get_MA1(data.discharge);

% To prevent recalculation, we are going to use Opt
[ma2,Opt]=mhit_get_MA2(data.discharge,Opt);
[ma3,Opt]=mhit_get_MA3(data.discharge,wYear,wYearList,Opt);
[ma4_11,Opt]=mhit_get_MA4_11(data.discharge,Opt);
[ma12_23,Opt]=mhit_get_MA12_23(data.discharge,data.month,Opt);
[ma24_35,Opt]=mhit_get_MA24_35(data.discharge,data.year,data.month,yearList, Opt);
[ma36_40, Opt]=mhit_get_MA36_40(data.discharge,data.year,data.month,yearList,Opt);
[ma41_45,Opt]=mhit_get_MA41_45(data.discharge,wYear,data.month,wYearList,2,Opt);

MA=[ma1, ma2, ma3, ma4_11, ma12_23, ma24_35, ma36_40, ma41_45];

%% ML1 to ML22 indices
[ml1_12,Opt]=mhit_get_ML1_12(data.discharge,data.year,data.month,yearList,Opt);
[ml13,Opt]=mhit_get_ML13(data.discharge,data.year,data.month,yearList,Opt);
[ml14_16,Opt]=mhit_get_ML14_16(data.discharge,wYear,wYearList,Opt);
[ml17,Opt]=mhit_get_ML17(data.discharge,wYear,wYearList,Opt);
[ml18,Opt]=mhit_get_ML18(data.discharge,wYear,wYearList,Opt);
[ml19,Opt]=mhit_get_ML19(data.discharge,wYear,wYearList,Opt);
ml20=mhit_get_ML20(data.discharge);
[ml21,Opt]=mhit_get_ML21(data.discharge,wYear,wYearList,Opt);
[ml22,Opt]=mhit_get_ML22(data.discharge,wYear,wYearList,2,Opt);

ML=[ml1_12, ml13, ml14_16, ml17, ml18, ml19, ml20, ml21, ml22];

%% MH1 to MH27 indices
[mh1_12,Opt]=mhit_get_MH1_12(data.discharge,data.year,data.month,yearList,Opt);
[mh13,Opt]=mhit_get_MH13(data.discharge,data.year,data.month,yearList,Opt);
[mh14,Opt]=mhit_get_MH14(data.discharge,wYear,wYearList,Opt);
[mh15_17,Opt]=mhit_get_MH15_17(data.discharge,Opt);
[mh18,Opt]=mhit_get_MH18(data.discharge,wYear,wYearList,Opt);
[mh19,Opt]=mhit_get_MH19(data.discharge,wYear,wYearList,Opt);
[mh20,Opt]=mhit_get_MH20(data.discharge,wYear,wYearList,2,Opt);
[mh21,Opt]=mhit_get_MH21(data.discharge,Opt);
[mh22,Opt]=mhit_get_MH22(data.discharge,Opt);
[mh23,Opt]=mhit_get_MH23(data.discharge,Opt);
[mh24,Opt]=mhit_get_MH24(data.discharge,Opt);
[mh25,Opt]=mhit_get_MH25(data.discharge,Opt);
[mh26,Opt]=mhit_get_MH26(data.discharge,Opt);
[mh27,Opt]=mhit_get_MH27(data.discharge,Opt);

MH=[mh1_12, mh13, mh15_17, mh18, mh19, mh20, mh21, mh22, mh23, mh24, mh25, mh26, mh27];

%% FL1 to FL3 indices
[fl1_2,Opt]=mhit_get_FL1_2(data.discharge,wYear,wYearList,Opt);
[fl3,Opt]=mhit_get_FL3(data.discharge,wYear,wYearList,Opt);

FL=[fl1_2, fl3];

%% FH1 to FH11 indices
[fh1_2,Opt]=mhit_get_FH1_2(data.discharge,wYear,wYearList,Opt);
[fh3,Opt]=mhit_get_FH3(data.discharge,wYear,wYearList,Opt);
[fh4,Opt]=mhit_get_FH4(data.discharge,wYear,wYearList,Opt);
[fh5,Opt]=mhit_get_FH5(data.discharge,wYear,wYearList,Opt);
[fh6,Opt]=mhit_get_FH6(data.discharge,wYear,wYearList,Opt);
[fh7,Opt]=mhit_get_FH7(data.discharge,wYear,wYearList,Opt);
[fh8,Opt]=mhit_get_FH8(data.discharge,wYear,wYearList,Opt);
[fh9,Opt]=mhit_get_FH9(data.discharge,wYear,wYearList,Opt);
[fh10,Opt]=mhit_get_FH10(data.discharge,wYear,wYearList,Opt);
[fh11,Opt]=mhit_get_FH11(data.discharge,wYear,jDay,wYearList,Opt);

FH=[fh1_2, fh3, fh4, fh5, fh6, fh7, fh8, fh9, fh10, fh11];

%% DL1 to DL20 indices
[dl1,Opt]=mhit_get_DL1(data.discharge,wYear,wYearList,Opt);
[dl2,Opt]=mhit_get_DL2(data.discharge,wYear,wYearList,Opt);
[dl3,Opt]=mhit_get_DL3(data.discharge,wYear,wYearList,Opt);
[dl4,Opt]=mhit_get_DL4(data.discharge,wYear,wYearList,Opt);
[dl5,Opt]=mhit_get_DL5(data.discharge,wYear,wYearList,Opt);
[dl6,Opt]=mhit_get_DL6(data.discharge,wYear,wYearList,Opt);
[dl7,Opt]=mhit_get_DL7(data.discharge,wYear,wYearList,Opt);
[dl8,Opt]=mhit_get_DL8(data.discharge,wYear,wYearList,Opt);
[dl9,Opt]=mhit_get_DL9(data.discharge,wYear,wYearList,Opt);
[dl10,Opt]=mhit_get_DL10(data.discharge,wYear,wYearList,Opt);
[dl11,Opt]=mhit_get_DL11(data.discharge,wYear,wYearList,Opt);
[dl12,Opt]=mhit_get_DL12(data.discharge,wYear,wYearList,Opt);
[dl13,Opt]=mhit_get_DL13(data.discharge,wYear,wYearList,Opt);
[dl14,Opt]=mhit_get_DL14(data.discharge,Opt);
[dl15,Opt]=mhit_get_DL15(data.discharge,Opt);
[dl16_17,Opt]=mhit_get_DL16_17(data.discharge,wYear,wYearList,Opt);
[dl18_19,Opt]=mhit_get_DL18_19(data.discharge,wYear,wYearList,Opt);
[dl20,Opt]=mhit_get_DL20(data.discharge,data.year,data.month,yearList,Opt);

DL=[dl1, dl2, dl3, dl4, dl5, dl6, dl7, dl8, dl9, dl10, dl11, dl12, dl13, dl14, dl15, dl16_17, dl18_19, dl20];

%% DH1 to DH24 indices
[dh1,Opt]=mhit_get_DH1(data.discharge,wYear,wYearList,Opt);
[dh2,Opt]=mhit_get_DH2(data.discharge,wYear,wYearList,Opt);
[dh3,Opt]=mhit_get_DH3(data.discharge,wYear,wYearList,Opt);
[dh4,Opt]=mhit_get_DH4(data.discharge,wYear,wYearList,Opt);
[dh5,Opt]=mhit_get_DH5(data.discharge,wYear,wYearList,Opt);
[dh6,Opt]=mhit_get_DH6(data.discharge,wYear,wYearList,Opt);
[dh7,Opt]=mhit_get_DH7(data.discharge,wYear,wYearList,Opt);
[dh8,Opt]=mhit_get_DH8(data.discharge,wYear,wYearList,Opt);
[dh9,Opt]=mhit_get_DH9(data.discharge,wYear,wYearList,Opt);
[dh10,Opt]=mhit_get_DH10(data.discharge,wYear,wYearList,Opt);
[dh11,Opt]=mhit_get_DH11(data.discharge,wYear,wYearList,Opt);
[dh12,Opt]=mhit_get_DH12(data.discharge,wYear,wYearList,Opt);
[dh13,Opt]=mhit_get_DH13(data.discharge,wYear,wYearList,Opt);
[dh14, Opt]=mhit_get_DH14(data.discharge,data.year,data.month,yearList,Opt);
[dh15_16,Opt]=mhit_get_DH15_16(data.discharge,wYear,wYearList,Opt);
[dh17,Opt]=mhit_get_DH17(data.discharge,wYear,wYearList,Opt);
[dh18,Opt]=mhit_get_DH18(data.discharge,wYear,wYearList,Opt);
[dh19,Opt]=mhit_get_DH19(data.discharge,wYear,wYearList,Opt);
[dh20,Opt]=mhit_get_DH20(data.discharge,wYear,wYearList,Opt);
[dh21,Opt]=mhit_get_DH21(data.discharge,wYear,wYearList,Opt);
[dh22,Opt]=mhit_get_DH22(data.discharge,wYear,jDay,wYearList,Opt);
[dh23,Opt]=mhit_get_DH23(data.discharge,wYear,jDay,wYearList,Opt);
[dh24,Opt]=mhit_get_DH24(data.discharge,wYear,jDay,wYearList,Opt);

DH=[dh1, dh2, dh3, dh4, dh5, dh6 , dh7, dh8, dh9, dh10, dh11, dh12, dh13, dh14, dh15_16, dh17, dh18, dh19, dh20, dh21, dh22, dh23, dh24];

%% TA1 to TA3 indices
[ta1_2,Opt]=mhit_get_TA1_2(data.discharge,data.month,data.day,Opt);
[ta3,Opt]=mhit_get_TA3(data.discharge,wYear,data.month,jDay,wYearList,Opt);

TA=[ta1_2, ta3];

%% TL1 to TL4 indices
[tl1_2,Opt]=mhit_get_TL1_2(data.discharge,wYear,jDay,wYearList,Opt);
[tl3,Opt]=mhit_get_TL3(data.discharge,wYear,data.month,jDay,wYearList,Opt);
[tl4,Opt]=mhit_get_TL4(data.discharge,wYear,jDay,wYearList,Opt);

TL=[tl1_2, tl3, tl4];

%% TH1 to TH3 indices
[th1_2,Opt]=mhit_get_TH1_2(data.discharge,wYear,jDay,wYearList,Opt);
[th3,Opt]=mhit_get_TH3(data.discharge,wYear,jDay,wYearList,Opt);

TH=[th1_2, th3];

%% RA1 to RA9 indices
[ra1_9,Opt]=mhit_get_RA1_9(data.discharge,wYear,wYearList,Opt);

RA=ra1_9;

%%
allIndices.MA=MA;
allIndices.ML=ML;
allIndices.MH=MH;
allIndices.FL=FL;
allIndices.FH=FH;
allIndices.DL=DL;
allIndices.DH=DH;
allIndices.TA=TA;
allIndices.TL=TL;
allIndices.TH=TH;
allIndices.RA=RA;

%%
fprintf('Done calculating all the indices.\n Time to calculate all indices: %f0.2 [s]\n',toc)



