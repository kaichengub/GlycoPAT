function varargout  = queryGlycomeDB(glycomeDBID,varargin)
%queryGlycomeDB retrieve glycan structure information from GlycomeDB database
%
% GLYCOMEDBQUERY = queryGlycomeDB(GLYCOMEDBID) searches for the database ID 
%  GLYCOMEDBID in the Glycome Database and returns a structure containing  
%  information about the glyan.
%
% GLYCANSTRUCTOBJ = queryGlycomeDB(GLYCOMEDBID,'sequenceonly',true)
%  returns the GlycanStruct object GLYCANSTRUCTOBJ ONLY.
%
% GLYCOMEDBQUERY contains three fields
%  1)species
%     This field includes the name of the species reported
%     bearing the glycan structure, their corresponding NCBI ID
%     and the references in other databases such as CFG and BCDS.
%  2)dbIDs:
%     If glycan structure was also reported in other databases,
%     this field includes a list of IDs and the resource names.
%  3)glycanSeq:
%     This field has four subfields, including the GLYCANSTRUCT
%     object,and the glycan sequence strings in GLYDE, GlycoCT, 
%     and GlycoCT-condensed formats. 
%                             
% Example 1:
%  queryResult = queryGlycomeDB('123');
%
% Example 2:
%  queryGlycan = queryGlycomeDB('123','sequenceOnly',true);
%
% See also webGlycomicsDB,queryCFGDB.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.

% check if java jvm is installed
if ~usejava('jvm')
    error(message('queryGlycomeDB:NeedJVM', mfilename));
end

% check number of inputs
if(~verLessThan('matlab','7.13'))
    narginchk(1,3);       
else
    error(nargchk(1,3,nargin));
end

if(nargin==2)
       errorReport(mfilename,'IncorrectInputNumber');      
 end    

% check the option setup
if~((length(varargin)==2)||(isempty(varargin)))
    errorReport(mfilename,'InproperOptionSetup');
end

%setup query option
if(length(varargin)==2)
    if(strcmpi(varargin{1},'sequenceonly') )
        querySeqOnly=varargin{2};
    else
        errorReprot(mfilename,'InproperOptionSetup');
    end
else
    querySeqOnly=false;
end

% check input variables
if(~isa(glycomeDBID,'char'))
    errorReport(mfilename,'NonStringInput');
end

glycomeDBurl = 'http://www.glycome-db.org/';
actionName = 'database/showStructure.action';
glycomeDBurlFullName = [glycomeDBurl actionName];
queryRes = urlread(glycomeDBurlFullName,'get',{'glycomeId',glycomeDBID});

%create a temporary file
import org.xml.sax.InputSource
import javax.xml.parsers.*
import java.io.*

iS= InputSource();
iS.setCharacterStream(StringReader(deblank(queryRes)));
queryDOM  =  xmlread(iS);

% convert XML string to a tree structure
queryXMLTree=parseChildNodes(queryDOM);

if(~querySeqOnly)
    
    % set species name and ncbiid
    speciesNodes = searchChildNodes(queryXMLTree,'species');
    numSpecies =  length(speciesNodes.Children);
    allocell = cell(1,numSpecies);
    speciesStruct = struct('name',allocell,'ncbiid',allocell,'refs',allocell);
    for i=1:numSpecies
        speciesStruct(1,i).name = speciesNodes.Children(1,i).Attributes(1,1).Value;
        speciesStruct(1,i).ncbiid = speciesNodes.Children(1,i).Attributes(1,2).Value;
        
        numRefs = length(speciesNodes.Children(1,i).Children);
        allocell = cell(1,numRefs);
        speciesStruct(1,i).refs = struct('name',allocell,'id',allocell);
        for j=1:numRefs
            childNodeRef = speciesNodes.Children(1,i).Children(1,j);
            speciesStruct(1,i).refs(1,j).name=childNodeRef.Attributes(1,1).Value;
            speciesStruct(1,i).refs(1,j).id = childNodeRef.Attributes(1,2).Value;
        end
    end
    
    % set ids for link to other database
    dbIDsNodes = searchChildNodes(queryXMLTree,'remote');
    numdbIDS =  length(dbIDsNodes.Children);
    allocell = cell(1,numdbIDS);
    dbIDsStruct = struct('name',allocell,'id',allocell);
    for i=1:numdbIDS
        dbIDsStruct(1,i).name = dbIDsNodes.Children(1,i).Attributes(1,1).Value;
        dbIDsStruct(1,i).id = dbIDsNodes.Children(1,i).Attributes(1,2).Value;
    end
    
    % set glycan structure field for structural information
    condensNode = searchChildNodes(queryXMLTree,'condenced');
    condenString = condensNode.Children.Data;
    
    glycoctStringNode = searchChildNodes(queryXMLTree,'glycoct');
    glycoctString  = glycoctStringNode.Children.Data;
    
    glydeNode     = searchChildNodes(queryXMLTree,'glyde');
    glydeString    = glydeNode.Children.Data;
    
    glycanSeqStruct.glyde =glydeString;
    glycanSeqStruct.glycoct = glycoctString;
    glycanSeqStruct.glycoctCondensed =condenString;
    glycanSeqStruct.class = GlycanStruct(glycoctString,'glycoct_xml');
    
    glycomeDBStruct.species = speciesStruct;
    glycomeDBStruct.dbIDs = dbIDsStruct;
    glycomeDBStruct.glycanSeq = glycanSeqStruct;
    
    varargout{1} = glycomeDBStruct;
else
    glycoctStringNode = searchChildNodes(queryXMLTree,'glycoct');
    glycoctString  = glycoctStringNode.Children.Data;
    glycanSeq =  GlycanStruct(glycoctString,'glycoct_xml');
    
    varargout{1} = glycanSeq;
end

end

function nodeStruct = searchChildNodes(rootNode,nodeName)
nodeStruct = [];
for i=1:length(rootNode)
    nodeStruct = getChildNodeByName(rootNode(1,i),nodeName);
    if(~isempty(nodeStruct) )
        return;
    end
end
end

function nodeStruct = getChildNodeByName(parentNode, nodeName)
nodeStruct=[];
if(strcmpi(parentNode.Name,nodeName))
    nodeStruct=parentNode;
    return;
else
    for i=1:length(parentNode.Children)
        childNode =  parentNode.Children(i);
        nodeStruct=getChildNodeByName(childNode,nodeName);
        if(~isempty(nodeStruct))
            return
        end
    end
end
end

% ----- Subfunction PARSECHILDNODES -----
function children = parseChildNodes(theNode)
% Recurse over node children. slightly modified version from codes provide
% in matlab xmlread example
children = [];
if theNode.hasChildNodes
    childNodes = theNode.getChildNodes;
    numChildNodes = childNodes.getLength;
    
    numTrueChildNodes=0;
    trueChildNodeIndex = [];
    for i=1:numChildNodes
        theChild = childNodes.item(i-1);
        if(~isNodeEmpty(theChild))
            numTrueChildNodes = numTrueChildNodes+1;
            trueChildNodeIndex=[trueChildNodeIndex;i];
        end
    end
    
    % disp(['number of true childrens is ',num2str(numTrueChildNodes)]);
    
    allocCell = cell(1, numTrueChildNodes);
    children = struct( 'Name', allocCell, 'Attributes', allocCell,    ...
        'Data', allocCell, 'Children', allocCell);
    
    for count = 1:numTrueChildNodes
        index = trueChildNodeIndex(count);
        theChild = childNodes.item(index-1);
        children(count) = makeStructFromNode(theChild);
    end
    
end

end

%subfunction isNodeEmptry
function isEmpty = isNodeEmpty(theNode)
% check attributes, data and childrens emtpry
nodeAttribute=parseAttributes(theNode);
if any(strcmp(methods(theNode), 'getData'))
    nodeData = char(theNode.getData);
else
    nodeData = '';
end
nodeChild = parseChildNodes(theNode);
if(isempty(nodeAttribute) && isempty(deblank(nodeData))...
        && isempty(nodeChild))
    isEmpty = true;
else
    isEmpty = false;
end

end


% ----- Subfunction MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
% Create structure of node info.

nodeStruct = struct(                        ...
    'Name', char(theNode.getNodeName),       ...
    'Attributes', parseAttributes(theNode),  ...
    'Data', '',                              ...
    'Children', parseChildNodes(theNode));

if any(strcmp(methods(theNode), 'getData'))
    nodeStruct.Data = char(theNode.getData);
else
    nodeStruct.Data = '';
end

end

% ----- Subfunction PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.
attributes = [];
if theNode.hasAttributes
    theAttributes = theNode.getAttributes;
    numAttributes = theAttributes.getLength;
    allocCell = cell(1, numAttributes);
    attributes = struct('Name', allocCell, 'Value', ...
        allocCell);
    
    for count = 1:numAttributes
        attrib = theAttributes.item(count-1);
        attributes(count).Name = char(attrib.getName);
        attributes(count).Value = char(attrib.getValue);
    end
end
end