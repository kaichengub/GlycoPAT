function glycanNetModelobj = glycanNetSBMLread(fileName,varargin)
%glycanNetSBMLread parse an SBML file describing the glycosylation reaction
% network annotated with glycan structures
%
% GLYCANNETMODELOBJ = glycanNetSBMLread(FILENAME) reads a file name in the 
%  string input argument FILENAME. The glycan structure are annotated with 
%  the GlycoCT format. The function returns a GlycanNetModel Object,
%  GLYCANNETMODELOBJ, representing the parsed glycosylation reaction 
%  network. The GlycanNetModel object can be manipulated by using other
%  functions in the toolbox. 
%   
% GLYCANNETMODELOBJ = glycanNetSBMLread(FILENAME,GLYCANFORMAT) reads a 
%  glycan sequence in the format GLYCANFORMAT used in the SBML annotation 
%  section. 
%
% Example 1: 
%  glycanNetModelobj = glycanNetSBMLread('OlinkedModel_wtannot.xml');
%     
% Example 2: 
%  glycanNetModelobj = glycanNetSBMLread('NlinkedModel_wtannot.xml','glycoct_xml');
%
% See also glycanNetSBMLwrite,glycanMLread,glycanMLwrite,glycanStrread,
%  glycanStrwrite.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

% validate the number of input arguments
if(~verLessThan('matlab','7.13'))
    narginchk(1,2);
else
    error(nargchk(1,2,nargin));
end

% input handling 
if (nargin==1)  
    glycanStringFormat = 'glycoct_xml';
elseif(nargin==2)
    glycanStringFormat  = varargin{1};
end

% input variable type check
isCharArg = ischar(fileName)&&ischar(glycanStringFormat) ;
if(~isCharArg)
    errorReport(mfilename,'NonStringInput');
end

%check if the file exists
if (exist(fileName,'file')==0)
    errorReport(mfilename,'FileNotFound');
end
fileFullName = which(fileName);

% parse SBML document using SBMLToolbox Function 
try
       SBML_structure = TranslateSBML(fileFullName);      
catch err
       errorReport(mfilename,'InvalidSBMLTranslation');        
end

% convert SBML structure along with glycan structure information into a
% GlycanNetModel object
glycanNetModelobj = GlycanNetModel(SBML_structure,glycanStringFormat);   

end
   
   
   








