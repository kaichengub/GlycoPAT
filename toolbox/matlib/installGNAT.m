function installGNAT
% INSTALLGNAT function is to install the GNAT for modeling glycosylation
% reaction networks. It consists of several pre-check subroutines and
% installation steps.
%
% 1. System check and display basic information
% 2. Add the GlycanBuilder, JGRAPH and other
%       java libraries to the java class path
% 3. Add the GNAT directory to the Path
% 4. Check if libSBML works properly
% 5. Check if SBML works properly
% 6. Check if GNAT works properly

% Author: Gang Liu
% Date Lastly Updated: 9/15/13

clc;clear;  %clear command window and workspace

fprintf(1,'Installation starts \n');
fprintf(1,'-------------------------------------------------------------\n');
fprintf(1,'1. Display Matlab system information.\n');
dispSystemInfo();
checkVersions();

fprintf(1,'\n2. GNAT Installation\n');

fprintf(1,'\t2.1 Set up environment path\n');
addGNATPath();

fprintf(1,'\t2.2 Set up java class path for libraries\n');
addJavaLibPath();
addJavaJARPath();
checkJavaLibPath();

fprintf(1,'\n3.Installation postcheck\n');
fprintf(1,'\t 3.1.Check libsbml\n\t\t');
checkLibSBML();
fprintf(1,'\t 3.2 Check SBMLToolbox\n');
checkSBMLToolbox();
fprintf(1,'\t 3.3.Function test\n');
functiontest();
fprintf(1,'---------------------------------------------------------------\n');
fprintf(1,'Installation ends.\n');

end

function addGNATPath()
ToolboxPath = genpath(pwd);
addpath(ToolboxPath);
s = savepath;
if (s ~= 0)
    warning('GNAT:Installation:PathNotAdded','\n GNAT directorie and subdirectories were not added to the Pathdef.m. ');
else
    fprintf(1,'\t\t Installation successful\n');
end;
end

function addJavaLibPath()
if(ispc)
    jalibpath = [pwd '\toolbox\javalibs'];
else
    jalibpath = [pwd '/toolbox/javalibs'];
end

addpath(jalibpath);

s = savepath;
if (s ~= 0)
    warning('GNAT:Installation:PathNotAdded','\n GNAT java directories were not added to the Path');
else
    fprintf(1,'\t \t Installation successful\n');
end;
end

function addJavaJARPath()
if(ispc)
    jalibpath = [pwd '\toolbox\javalibs'];
    jarFiles = dir([jalibpath '\*.jar']);
else
    jalibpath = [pwd '/toolbox/javalibs'];
    jarFiles = dir([jalibpath '/*.jar']);
end

if(~existJavaClassPath(jalibpath))
    javaaddpath(jalibpath);
end

for i=1: length(jarFiles)
    fileName = jarFiles(i).name;
    fullFileName = which(fileName);
    if(~existJavaJarFile(fullFileName))
        javaaddpath(fullFileName);
    end
end
end

function existpath =existJavaClassPath(jarlibpath)
spath = javaclasspath('-all');
for i=1: length(spath)
    if(strcmp(spath(i),jarlibpath))
        existpath = true;
        return
    end
end
existpath = false;
end

function existFile =existJavaJarFile(fullFileName)
spath = javaclasspath('-all');
[pathstr,name,ext]=fileparts(fullFileName);
partFileName = [name ext];

for i=1: length(spath)
    [pathstr,name,ext]=fileparts(char(spath(i)));
    sfileName = [name ext];
    if(strcmpi(partFileName,sfileName))
        existFile = true;
        return
    end
end
existFile = false;
end

function checkJavaLibPath()
classcheck1=isequal( exist ...
    ('org.eurocarbdb.application.glycanbuilder.Glycan',...
    'class'),8);
classcheck2=isequal(exist...
    ('org.eurocarbdb.application.glycanbuilder.Residue',...
    'class'),8);
classcheck3=isequal(exist(...
    'org.glyco.GlycanNetGraphEditor',...
    'class'),8);

isJavaSetupProperly = classcheck1 ...
    && classcheck2 && classcheck3;
if(isJavaSetupProperly)
    fprintf(1,'\t Validation:Java Library is installed properly\n');
else
    error('Java Library is not installed properly\n');
end
end

function checkLibSBML()
%checkLibSBML check installation of libSBML
%
%  See also checkSBMLToolbox
if(doesItRun('matlab'))
    fprintf(1,'\t Validation:libSBML is installed properly\n');
else
    warning('GNAT:libSBML:NotInstalled','\t libSBML is not installed properly. GNAT functions may not work\n');
end
end

function functiontest()
%functiontest check path setup and main folder existence
dir1_GNATToolbox = 'viz';
dir2_GNATToolbox = 'util';
dir3_GNATToolbox = 'transform';
dir4_GNATToolbox = 'funcs';
dir5_GNATToolbox = 'db';
isDirsGNATToolboxExist =...
    isdir(dir1_GNATToolbox)...
    && isdir(dir2_GNATToolbox) ...
    && isdir(dir3_GNATToolbox) ...
    && isdir(dir4_GNATToolbox) ...
    && isdir(dir5_GNATToolbox) ;

classcheck1=isequal( exist ...
    ('GlycanStruct',...
    'class'),8);
classcheck2=isequal(exist...
    ('Rxn',...
    'class'),8);
classcheck3=isequal(exist(...
    'GlycanNetModel',...
    'class'),8);

isMatlabClassSetProperly = classcheck1 ...
    && classcheck2 && classcheck3;

isGNATToolboxInstalled = ...
    isDirsGNATToolboxExist  &&...
    isMatlabClassSetProperly;

if(isGNATToolboxInstalled)
    fprintf(1,'\t Validation:GNAT is installed properly\n');
else
    error('GNAT is not installed properly\n');
end
end

function checkSBMLToolbox()
% check existance of file folders
%
%  See also checklibSBML
dir1_SBMLToolbox = 'Validate_MATLAB_SBML_Structures';
dir2_SBMLToolbox = 'Simulation';
dir3_SBMLToolbox = 'Convenience';
dir4_SBMLToolbox = 'AccessModel';
isDirsSBMLToolboxExist =...
    isdir(dir1_SBMLToolbox)...
    && isdir(dir2_SBMLToolbox) ...
    && isdir(dir3_SBMLToolbox) ...
    && isdir(dir4_SBMLToolbox);

isSBMLToolboxInstalled = isDirsSBMLToolboxExist;
if(isSBMLToolboxInstalled)
    fprintf(1,'\t Validation:SBMLToolbox is installed properly\n');
else
    warning('GNAT:SBMLToolbox:NotInstalled','\t SBML Toolbox is not installed properly. GNAT functions may not work\n');
end
end

function dispSystemInfo()
%systemDisplay display matlab information
%
%  See also COMPUTER,ISUNIX,IS32BIT
curMatlab = ver('matlab');
currMatlabVer = curMatlab.Version;

% fprintf(1,'  Computer system properties are as follows: \n\n');
fprintf(1,'  \tMatlab platform: %s version %s\n',getSystemsByte,currMatlabVer);

if(ispc)
    sysComputer='  PC\n';
elseif(ismac)
    sysComputer=   ' Mac\n';
else
    sysComputer=  '  Unix/Linux\n';
end

fprintf(1,sprintf('\tPC system: %s',sysComputer));
end

function result = is32bit()
%IS32BIT True for the 32bit  version of MATLAB.
%   IS32BIT returns 1 for 32bit  versions of MATLAB and 0 otherwise.
%
%   See also COMPUTER, ISUNIX, ISMAC,ISPC.

result = strcmp(computer,'PCWIN') || strcmp(computer,'GLNX86');
end

function systemByte = getSystemsByte()
%getSystemsByte return a string for the MATLAB bytes
%   getSystemsByte returns 32bit and 64bit based on current Matlab platform.
%
%   See also is32bit, ISUNIX, ISMAcomputC,ISPC.
if(is32bit())
    systemByte = '32 bit';
else
    systemByte = '64 bit';
end
end

function isSuggestedVersion=checkVersions( )
% checkVersions True for the recommended Matlab version or higher
%    checkVersions returns 1 for suggested Matlab verion and 0 otherwise
%
%  See also verLessThan
StableVersionForGlycoToolbox = '7.13';

curMatlab = ver('matlab');
currMatlabVer = curMatlab.Version;
% toolboxParts = getParts(toolboxver(1).Version);
% verParts = getParts(verstr);
isSuggestedVersion=~verLessThan('matlab',StableVersionForGlycoToolbox);
if(~isSuggestedVersion)
    warning('GNAT:Installation:MATLABVERSIONOWER',sprintf('Matlab Version %s or higher is recommended',StableVersionForGlycoToolbox));
else
    sprintf('Current version %s is stable for GNAT',currMatlabVer);
end

end

% The codes below are taken from SBMLToolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check for executables and that they are right ones
%  This function is borrowed from libSBML toolbox to check if the
%  installation of libSBML is correct
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test the installation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test the installation
function success = doesItRun(matlab_octave)

success = 1;

try
    testFileName=which('SBMLtest.xml') ;
    M = TranslateSBML(testFileName);
catch err
    success = 0;
end;

if strcmpi(matlab_octave, 'matlab')
    outFile = [tempdir,filesep, 'test-out.xml'];
else
    if ispc()
        outFile = [tempdir, 'temp', filesep, 'test-out.xml'];
    else
        outFile = [tempdir, 'test-out.xml'];
    end;
end;

if (success == 1)
    try
        OutputSBML(M, outFile,1);
    catch err
        success = 0;
    end;
end;
end
