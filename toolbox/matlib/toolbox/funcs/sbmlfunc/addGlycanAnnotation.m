function varargout = addGlycanAnnotation(varargin)
%addGlycanAnnotation add glycan sequence data to the annotation field of 
% species element in SBML structure 
%
% SBML_STRUCT = addGlycanAnnotation(SBML_STRUCT,containers.Map) places XML
%  based glycan structure information stored in containers.Map into MATLAB
%  SBML structure, SBML_STRUCT. containers.Map is a MATLAB data structure 
%  with SBML species name (key) and corresponding glycan structure (value).
%
% Example 1: 
%  %read SBML file to MATLAB sbml structure. One of the predefined species is "M9" 
%  linearNLinkedModel_SBML=TranslateSBML(which('gnat_test_woannot.xml')); 
%  %create a Map structure
%  glycansMap = containers.Map;
%  %read M9_glycan structure in XML format
%   M9_glycan  = glycanMLread('M9.glycoct_xml');
%  %add M9 key and value pair into previously created containers.map
%  glycansMap('M9')= glycanStrwrite(M9_glycan); 
%  %add key-value relation defined in glycansMap into SBML structure 
%  NLinkedModel_SBML_Annot = addGlycanAnnotation(linearNLinkedModel_SBML,glycansMap);
%      
% See also GlycanNetModel,GlycanStruct. 

% Author: Gang Liu
% CopyRight 2012 Neelamegham Lab

% input number check
if(~verLessThan('matlab','7.13'))
    narginchk(2,2);
else
    error(nargchk(2,2,nargin));
end

% check if first argument is sbml_structure
if(isa(varargin{1},'struct')) && isSBML_Model(varargin{1})
    glycan_sbml =varargin{1};
    caseNo = 1;
elseif(isa(varargin{1},'GlycanNetModel'))
    glycan_sbml=varargin{1}.glycanNet_sbmlmodel;
    caseNo =2;
else
    errorReport(mfilename,'IncorrectInputType');
end

if(isa(varargin{2},'containers.Map'))
    glycanMap =varargin{2};
else
    errorReport(mfilename,'IncorrectInputType');
end

keys                               =  glycanMap.keys;
glycoctstr                     =  glycanMap.values;
glycoctannotationstr =   setAnnotationStr(glycoctstr);

% retrieve species name for the list
nSpecies =  length(glycan_sbml.species);
speciesNameList = cell(nSpecies,1);
speciesIDList = cell(nSpecies,1);
for i=1: nSpecies
    speciesNameList{i,1} = glycan_sbml.species(1,i).name;
    speciesIDList{i,1} = glycan_sbml.species(1,i).id;
end

% find sbml_species
for i=1:glycanMap.Count
    speciesname = keys{i};
    nameindex = findbyname(speciesNameList, speciesname);
    
    if(~isempty(nameindex))
       % set annoation in sbml_species
      glycan_sbml.species(1,nameindex).annotation=glycoctannotationstr{i};
    else 
         idindex = findbyname(speciesIDList, speciesname);
         if(~isempty(idindex))
             glycan_sbml.species(1,idindex).annotation=glycoctannotationstr{i};
         end    
    end
end

% return argument
if(caseNo==1)
    varargout{1}=glycan_sbml;
elseif(caseNo==2)
    varargout{1} =varargin{1};
end

end

function annotationstr=setAnnotationStr(glycostr)
annotationstr=cell(1,length(glycostr));   
for i=1:length(glycostr)
        annotationstr{1,i}=['<annotation>' '<glycoct xmlns="http://www.eurocarbdb.org/recommendations/encoding">'];
        annotationstr{1,i} =[annotationstr{1,i} glycostr{1,i} '</glycoct>' '</annotation>'];
        annotationstr{1,i}=strrep(annotationstr{1,i},'<?xml version="1.0" encoding="UTF-8"?>', ' ');
 end
end


function nameindex = findbyname(fulllist, name)

 [ii jj value]=find(strcmpi(name,fulllist));
 nameindex = ii;

end

