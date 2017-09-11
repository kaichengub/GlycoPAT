function installglycopat
% INSTALLGLYCOPAT function is to install the GLYCOPAT. It consists of 
% several pre-check subroutines and installation steps.
%
% 1. System check and display basic information
% 2. Add the GLYCOPAT directory to the Path
% 3. Add the java libraries to the java class path
% 4. Check if GLYCOPAT works properly

% Author: Gang Liu
% Date Lastly Updated: 12/01/14

clc;clear;  %clear command window and workspace

fprintf(1,'Installation starts \n');
fprintf(1,'-------------------------------------------------------------\n');
fprintf(1,'1. Display Matlab system information.\n');
dispSystemInfo();
checkVersions();

fprintf(1,'\n2. GlycoPAT Installation\n');

fprintf(1,'\t2.1 Set up environment path\n');
addGlycoPATPath();

fprintf(1,'\t2.2 Set up java class path for libraries\n');
addJavaLibPath();
addJavaJARPath();

fprintf(1,'\n3.Installation check\n');
fprintf(1,'\t 3.1.Check MZXML\n');
checkmzXML();
fprintf(1,'\t 3.2.Function test\n');
functiontest();
fprintf(1,'---------------------------------------------------------------\n');
fprintf(1,'Installation ends.\n');

end

function functiontest()
%functiontest check path setup and main folder existence
dir1_GLYCOPATToolbox = 'func';
dir2_GLYCOPATToolbox = 'class';
dir3_GLYCOPATToolbox = 'gui';
dir4_GLYCOPATToolbox = 'javalibs';
dir5_GLYCOPATToolbox = 'test';
isDirsGLYCOPATToolboxExist =...
    isdir(dir1_GLYCOPATToolbox)...
    && isdir(dir2_GLYCOPATToolbox) ...
    && isdir(dir3_GLYCOPATToolbox) ...
    && isdir(dir4_GLYCOPATToolbox) ...
    && isdir(dir5_GLYCOPATToolbox) ;

if(isDirsGLYCOPATToolboxExist)
    fprintf(1,'\t\tValidation:GlycoPAT is installed properly\n');
else
    error('GlycoPAT:Installation:INCORRECTPATH','\t\tGLYCOPAT is not installed properly\n');
end
end

function addGlycoPATPath()
glycopatpath = fullfile(pwd,'toolbox');
ToolboxPath  = genpath(glycopatpath);
addpath(ToolboxPath);
s = savepath;
if (s ~= 0)
    warning('GlycoPAT:Installation:PathNotAdded',...
        '\nGLYCOPAT directorie and subdirectories were not added to the Pathdef.m. ');
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
    warning('GlycoPAT:Installation:PathNotAdded','\n GLYCOPAT java directories were not added to the Path');
else
    fprintf(1,'\t \t Installation successful\n');
end;
end

function addJavaJARPath()
if(ispc)
    jalibpath = [pwd '\toolbox\javalibs'];
    jarFiles = dir([jalibpath '\*.jar']);
    gnatjalibpath = [pwd '\toolbox\matlib\toolbox\javalibs'];
    gnatjarfiles = dir([gnatjalibpath '\*.jar']);
else
    jalibpath = [pwd '/toolbox/javalibs'];
    jarFiles = dir([jalibpath '/*.jar']);
    gnatjalibpath = [pwd '/toolbox/matlib/toolbox/javalibs'];
    gnatjarfiles = dir([gnatjalibpath '/*.jar']);
end

if(~existJavaClassPath(jalibpath))
    javaaddpath(jalibpath);
    javaaddpath(gnatjalibpath);
end

for i=1: length(jarFiles)
    fileName = jarFiles(i).name;
    fullFileName = which(fileName);
    if(~existJavaJarFile(fullFileName))
        javaaddpath(fullFileName);        
    end
end

for i=1: length(gnatjarfiles)
    gnatfileName = gnatjarfiles(i).name;
    fullgnatFileName = which(gnatfileName);
    if(~existJavaJarFile(fullgnatFileName))
        javaaddpath(fullgnatFileName);        
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

function unittest()
% to do 
end

function checkmzXML()
classcheck1=isequal( exist ...
    ('org.systemsbiology.jrap.MSXMLParser',...
    'class'),8);
classcheck2=isequal(exist...
    ('org.systemsbiology.jrap.extension.ExtMSXMLParser',...
    'class'),8);

isJavaSetupProperly = classcheck1 ...
    && classcheck2;
if(isJavaSetupProperly)
    fprintf(1,'\t\tValidation:Java Library is installed properly\n');
else
    error('\tJava Library is not installed properly\n');
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
StableVersionForGlycoToolbox = '8.2';

curMatlab = ver('matlab');
currMatlabVer = curMatlab.Version;
% toolboxParts = getParts(toolboxver(1).Version);
% verParts = getParts(verstr);
isSuggestedVersion=~verLessThan('matlab',StableVersionForGlycoToolbox);
if(~isSuggestedVersion)
    warning('GLYCOPAT:Installation:MATLABVERSIONOWER',sprintf('Matlab Version %s or higher is recommended',StableVersionForGlycoToolbox));
else
    sprintf('Current version %s is stable for GPAT',currMatlabVer);
end

end
