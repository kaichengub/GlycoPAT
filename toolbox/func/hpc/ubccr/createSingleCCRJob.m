function [fullslurmfilename,fullslurmmatlabfilename]=createSingleCCRJob(pathname,jobname,...
    pepfilefullname,mzxmlfilefullname,MS1tol,MS2tol,MS2tolUnit,usePar,ppn,numworkers)
% createSingleCCRJob make the directory and create the files for job submission (slurm file and analysis file) 
%   
%   
%See also writeSlurmFile, writeCCRMFile

% Author: Gang Liu
% Date Lastly Updated: 7/22/14
cddircmd = sprintf('cd %s',pathname);
mkdircmd = sprintf('mkdir %s',jobname);
cdsubdircmd = sprintf('cd %s',jobname);
eval(cddircmd);
if(exist(jobname,'dir')==7)
   error('MATLAB:GlycoPAT:DIREXIS','DIRECTORY ALREADY EXISTS');
end
eval(mkdircmd);
eval(cdsubdircmd);

% write slurm file 
fullslurmfilename = fullfile(pwd,jobname);
writeSlurmFile(fullslurmfilename,jobname,ppn);
fullslurmmatlabfilename = [fullslurmfilename,'slurm.m'];
writeSlurmMatlabFile(fullslurmmatlabfilename,jobname,ppn,numworkers);
[~,slurmmatlabwoext,~]=fileparts(fullslurmmatlabfilename);
slurmfunchandle = str2func(slurmmatlabwoext);

% write function file
mfilename         = fullfile(pwd,[jobname,'.m']);
[xmlfilepath,xmlfilenamewoext,xmlfileformat] = fileparts(mzxmlfilefullname);
mzxmlfilename     = [xmlfilenamewoext,xmlfileformat];
fragMode          = 'AUTO'; % specify fragmentation mode 'CID/HCD (default)','ETD(default)','CID/HCD (Special)','ETD (Special)'
MS1tolUnit        = 'ppm'; % specify units of MS1 tolerance
OutputDir         = pwd;  % same directory as Pepfile

[~,pepfilenamewoext,~] = fileparts(pepfilefullname);
OutCSVname        = [jobname,'_',xmlfilenamewoext,'_',pepfilenamewoext,'.csv'];  % Output is comma separated file that can be read using excel. Specify .csv file name here
maxlag            = 50;          % parameter for XCorr
cutOffMed         = 2;        % paramters to clean Spectra
fracMax           = 0.02;
if(usePar==1)
    scorecommand      = 'scoreAllSpectra_parfor';
elseif(usePar==2)
    scorecommand      = 'scoreAllSpectra_spmd';
elseif(usePar==0)
    scorecommand      = 'scoreAllSpectra';
elseif(usePar==3)
    scorecommand      = 'scoreAllSpectra_v1';
end

% numpools = 12;
writeCCRMfile(mfilename,pepfilefullname,xmlfilepath,mzxmlfilename,OutCSVname,maxlag,...
 fragMode,MS1tol,MS1tolUnit,MS2tol,MS2tolUnit,OutputDir,cutOffMed,fracMax,scorecommand)

%submit job
cdupperdircmd = sprintf('cd ..');
eval(cdupperdircmd);
