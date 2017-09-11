function [out]=ScoreAllscript
% script running program matchPepList.m
%Pepfile='G:\crash\MATLAB_programs\GPA\testData\dta files from JBC paper\DigestList.txt';  % specify location where the output of the digestscript file is stored.
% Note: Directory names have to be changed for this script to work

Pepfile='D:\Working\Dropbox\glycoPAT\version_check121016\GlycoPAT_submit\toolbox\test\data\score\mzxml files\19FcTry.txt';                           % specify location where the output of the digestscript file is stored.
%DataDirectory='G:\crash\MATLAB_programs\GPA\testData\dta files from JBC paper';    
DataDirectory='D:\Working\Dropbox\glycoPAT\version_check121016\GlycoPAT_submit\toolbox\test\data\score\mzxml files\B11_01_130622_19FC_try_Top7_1uL_CID_250nL_50Col_col73_long'; % specify location where .dta files are stored
fragMode='CID'; % specify fragmentation mode 'CID/HCD (default)','ETD(default)',''CIDSpecial'/'HCDSpecial', ','ETDSpecial'
MS1tol=20;      % specify MS1 tolerance, e.g. 20 ppm
MS1tolUnit='ppm'; % specify units of MS1 tolerance
MS2tol=1;       % specify MS2 tolerance, e.g. 1Da
MS2tolUnit='Da';% specify units of MS2 tolerance

% These parameters could be set using options
OutputDir=fileparts(Pepfile);  % same directory as Pepfile
Outfname='LongTryGO.csv';  % Output is comma separated file that can be read using excel. Specify .csv file name here
maxlag=50;          % parameter for XCorr
CutOffMed=2;        % paramters to clean Spectra
FracMax=0.02;
% fragMode='other'
nmFrag=0;  % In case fragMode='other', set using options
ngFrag=0;
npFrag=0;
selectPeak=[293.0807,163.1,292.1,455.1,454.1];    % Look to see if there are specific peaks in the MS spectra
% selectPeak=[293.0807,163.1,292.1,455.1,366,454.1,657.2];    % Look to see if there are specific peaks in the MS spectra

glycanOnly='true';                                % Output file only contains glycan hits
veryLabilePTM={'<s>'};
pseudoLabilePTM={};
[hit]=scoreAllSpectra(Pepfile,DataDirectory,fragMode,MS1tol,MS1tolUnit,MS2tol,MS2tolUnit,...
    OutputDir,Outfname,maxlag,CutOffMed,FracMax,nmFrag,npFrag,ngFrag,selectPeak);
    end