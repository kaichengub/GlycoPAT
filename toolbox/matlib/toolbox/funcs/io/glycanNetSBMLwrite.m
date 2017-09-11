function glycanNetSBMLwrite(glycanNetModel, varargin)
%glycanNetSBMLwrite write a GlycanNetModel Object to an SBML file with glycan
% structure annotation
% 
% glycanNetSBMLwrite(GLYCANNETMODELOBJ,FILENAME) writes a GlycanNetModel
%  object GLYCANNETMODELOBJ to an SBML file named as the string input 
%  argument FILENAME and annotated with glycan sequences in GlycoCT format.
% 
% glycanNetSBMLwrite(GLYCANNETMODELOBJ,FILENAME,GLYCANFORMAT) uses a string
%  input argument GLYCANFORMAT as sequence format for structure annotation
%  in SBML. GLYCANFORMAT can be either GlycoCT or GLYDE. 
%  
%  glycanNetSBMLwrite(GLYCANNETMODELOBJ) uses a user inferface to decide
%  the file and its location. Default GLYCANFORMAT is GlycoCT.
% 
% Example 1: 
%  load glycanmodelexample.mat;
%  glycanNetSBMLwrite(olinked_model,'OlinkedModel_wtannot.xml'); 
%
% Example 2: 
%  load glycanmodelexample.mat;
%  glycanNetSBMLwrite(nlinked_model,'NlinkedModel_wtannot.xml','glycoct_xml');
% 
%   Example 3: 
%     load glycanmodelexample.mat;
%     glycanNetSBMLwrite(nlinked_model);
% 
% See also glycanNetSBMLread,glycanMLread,glycanMLwrite,glycanStrread,
%  glycanStrwrite.

% Author: Gang Liu
% Date Lastly Updated: 10/1/13

% input number check
error(nargchk(1,3,nargin));

if (nargin==1)  
    glycanStringFormat = 'glycoct_xml';
elseif(nargin==2)
    glycanfilename = varargin{1}; 
    glycanStringFormat = 'glycoct_xml';
elseif(nargin==3)
    glycanfilename = varargin{1}; 
    glycanStringFormat = varargin{2}; 
end

% input variable type check
if(nargin==2) && (nargin==3)
    isCharArg = ischar(glycanfilename)&&ischar(glycanStringFormat) ;
    if(~isCharArg)
        errorReport(mfilename,'NonStringInput');
    end
end

%convert GlycoNetModel object to the SBML structure
GlycoNetSBML_Structure = glycanNetModel.toSBMLStruct;

% output SBML document with glycan structure definition to a local file
try
    if (nargin==2) || (nargin==3)
         OutputSBML(GlycoNetSBML_Structure,glycanfilename);      
    elseif(nargin==1)
        OutputSBML(GlycoNetSBML_Structure);
    end
CATCH error
       errorReport(mfilename,'InvalidSBMLTranslation');        
end

end

