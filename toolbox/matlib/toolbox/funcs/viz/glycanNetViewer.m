function glycanNetViewer(glycanNetModelObj, varargin)
%glycanNetViewer read a GlycanNetModel object and return a graphical representation  
% of the glycosylation network.
% 
% glycanNetViewer(GLYCANNETMODELOBJ,OPTIONS) reads a GlycanNetModel object GLYCANNETMODELOBJ
%  and displays the network using the options OPTIONS. The OPTIONS can be specified using
%  displayset. See displayset for details. 
%
% glycanNetViewer(GLYCANNETMODELOBJ) uses the default options to
%  visualize the glycosylation reaction network.
%
% Example 1:
%  glycanNetModelObj = glycanNetSBMLread('OlinkedModel_wtannot.xml','glycoct_xml');
%  glycanNetViewer(glycanNetModelObj);  
%
% Example 2:
%  glycanNetModelObj = glycanNetSBMLread('NlinkedModel_wtannot.xml','glycoct_xml');
%  options=displayset('showRedEnd',false,'showLinkage',false,'netlayout','Circle');
%  glycanNetViewer(glycanNetModelObj,options)
%
% Example 3:
%  glycanNetModelObj = glycanNetSBMLread('NlinkedModel_wtannot.xml','glycoct_xml');
%  options = displayset('showRedEnd',false,'showLinkage',false,'netlayout','Circle');
%  options = displayset(options,'dbname','GLYCOME','dbusername','postgres');
%  options = displayset(options,'dbpassword','furnas910');
%  glycanNetViewer(glycanNetModelObj,options)
%
% See also glycanViewer,glycanFileViewer,glycanNetFileViewer,displayset,displayget.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

% input check
% if(~verLessThan('matlab','7.13'))
%     narginchk(1,3);
% else
    error(nargchk(1,3,nargin));
% end
    

% input argument assignment
if (nargin < 2)
    options = displayset;
elseif(nargin<3)
    options = varargin{1};
elseif(nargin<4)
    options = varargin{1};
    ithCompt = varargin{2};
end

optionfieldnames = char( 'showMass        ',   'showLinkage      ',    'showRedEnd     ',   ...
    'Isotope                 ',        'Derivatization   ',   'IonCloudCharge' ,   'NetLayout         ',   ...
    'NetFrameHeight ',        'NetFrameWidth',    'NetFitToFrame ','dbname',...
    'dbusername','dbpassword');

% check option fields
names = fieldnames(options);

for i=1:length(names)
   if(~any(strcmpi(names(i,1),cellstr(optionfieldnames))))
       errorReport(mfilename,'wrongfieldname');
   end    
end

% first option: display reducing end
showRedEnd=displayget(options,'showRedEnd');

% second option: display linkage
showLinkage=displayget(options,'showLinkage');

% third option: layoutout
layoutformat = displayget(options,'NetLayout');

%fourth option (frame choice to be done in future: frame choice: auto/default/Detailed):
frameChoice ='Custom';

%fifth option
frameHeight  =  displayget(options,'NetFrameHeight');
frameWidth   =  displayget(options,'NetFrameWidth');

%sixth option
netFitToFrame  = displayget(options,'NetFitToFrame');

%seventh option 
dbname =  displayget(options,'dbname');

%eighth option
dbusername = displayget(options,'dbusername');

% ninth option
dbpassword = displayget(options,'dbpassword');

% check if glycanjava is stored in Glycanstruct object
theglycans =glycanNetModelObj.getGlycanPathway.getSpecies;
for i = 1 : length(theglycans);
     thespeciesstruct = theglycans.get(i).glycanStruct;
      if(~isprop(thespeciesstruct,'glycanjava')) || isempty(thespeciesstruct.glycanjava);
         thespeciesstruct.glycanjava = thespeciesstruct.structMat2Java;
     end
end
% 

% get pathway
javaGlycanPathway = glycanNetModelObj.toJavaPathway;
if(isempty(javaGlycanPathway) || javaGlycanPathway.size==0)
    error('MATLAB:GNAT:PAHTWAYEMPTY','pathway is empty');
end

if(nargin==3)
     ithcomptPathway   = javaGlycanPathway.get(int32(ithCompt));
     javaGlycanPathway = java.util.Vector;
     javaGlycanPathway.add(ithcomptPathway);
end


%create a hashmap
dbHashMap=java.util.HashMap;

try 
     localConn = dbLocalConnect(dbname,dbusername,dbpassword);
     isdbworking = true;
catch err
      isdbworking = false;
end

for i=1:length(theglycans)
    theGlycan = theglycans.get(i).getGlycanStruct();
    % glycanViewer(theGlycan);
    if(isdbworking)
        glycomedbID = dbExactStructSearch(localConn,theGlycan,'glycoct_condensed');
        dbHashMap.put(theGlycan.toGlycoCT,java.lang.Integer(glycomedbID));
    else
         glycomedbID =-1;
         dbHashMap.put(theGlycan.toGlycoCT,java.lang.Integer(glycomedbID)); 
    end    
end

 org.glyco.GlycanNetGraphEditor.createAndShowGUI(javaGlycanPathway,...
    frameChoice,  java.awt.Dimension(int32(frameWidth),int32(frameHeight)),...
    showRedEnd, false, showLinkage,layoutformat,dbHashMap,netFitToFrame);

end