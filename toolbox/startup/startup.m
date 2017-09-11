% Please note here that the user should replace '<GLYCOPATInstallationDir>' in 
% line 10 by absolute GLYCOPAT installation directory.
function startup
% startup add Java class path to MATLAB java path
% in the system when MATLAB starts

% Author: Gang Liu
% CopyRight 2014 Neelamegham Lab

glycopatpath= 'c:\glycopat_submit' ;
addpath(genpath(glycopatpath))
addJavaJARPath(glycopatpath);
end

%load GLYCOPAT java class path
function addJavaJARPath(glycopatpath)
if(ispc)
    jalibpath = [glycopatpath '\toolbox\javalibs'];
    jalibpath2 = [glycopatpath '\toolbox\matlib\toolbox\javalibs'];
    jarFiles = dir([jalibpath '\*.jar']);
    jarFiles2 = dir([jalibpath2 '\*.jar']);
else
    jalibpath = [glycopatpath '/toolbox/javalibs'];
    jalibpath2 = [glycopatpath '/toolbox/matlib/toolbox/javalibs'];
    jarFiles = dir([jalibpath '/*.jar']);
    jarFiles2 = dir([jalibpath2 '/*.jar']);    
end

for i=1: length(jarFiles)
    fileName = jarFiles(i).name;
    fullFileName = which(fileName);
    if(~existnJavaClassPath(fileName))
        javaaddpath(fullFileName);
    end
end

for i=1: length(jarFiles2)
    fileName = jarFiles2(i).name;
    fullFileName = which(fileName);
    if(~existnJavaClassPath(fileName))
        javaaddpath(fullFileName);
    end
end

end

function existFile = existnJavaClassPath(fileName)
spath = javaclasspath('-all');
[pathstr,name,ext]=fileparts(fileName);
partFileName = [name ext];

for i=1: length(spath)
    [pathstr,name,ext]=fileparts(char(spath(i)));
    sfileName = [name ext];
    if(strcmp(partFileName,sfileName))
        existFile = true;
        return
    end
end
existFile = false;
end
