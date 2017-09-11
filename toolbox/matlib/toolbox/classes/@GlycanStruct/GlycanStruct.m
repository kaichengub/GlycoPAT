classdef GlycanStruct < handle
    %GlycanStruct class representing a carbohydrate sequence for a glycan.
    %
    % A GlycanStruct object is a generic representation of biological
    %  carbohydrate sequence data for a glycan. It consists of an
    %  array of residues and linkages, represented in a tree data structure.
    %
    % GlycanStruct properties:
    %  root                   - root for residue tree
    %  bracket             - residues with unknown connections
    %  name                - name of the glycan
    %  attachedMol    - the molecule to which the glycan is attached
    %  massOptions   - the options used for molecular weight calculation
    %
    % GlycanStruct methods:
    %  GlycanStruct      - create a Glycan object.
    %  getnResidues             - retrieve the number of residues.
    %  getnLinkages             - retrieve the number of linkages.
    %  getName                  - retrieve the 'name' property.
    %  getRoot                  - retrieve the 'root' property.
    %  getAttachedMol           - retrieve the 'attachedMol' property.
    %  getMassOptions           - retrieve the 'MassOptions' property.
    %  getAllResidues           - retrieve all the glycan residues from the root tree structure
    %  setName                  - set the 'name' property
    %  setRoot                  - set the 'root' property.
    %  setAttachedMol           - set the 'attachedMol' property.
    %  setMassOptions           - set the 'MassOptions' property.
    %  structMat2Java           - convert a MATLAB GlycanStruct object to a Java GLYCAN object
    %  isempty                  - check if the object is empty
    %  removeNonRedEndResidue   - remove non-reducing end residue
    %  getNonRedEndResidue      - retrieve non-reducing end residue
    %  clone                    - create a clone of the GlycanStruct object
    %  computeMass              - compute molecular mass
    %  computeMZ                - compute MZ values
    %  contains                 - check if the glycan contains a specified structure
    %  isFragment               - check if the glycan is a fragment
    %  hasRepetition            - check if the glyan has a repetitive group
    %  contains                 - return true if the structure contains other glycan structure
    %  computeFormula           - compute chemical formula
    %  compareTo                - compare to other glycan structure
    %  equalStruct              - return true if the structure is same as other glycan structure
    %  isFuzzy                  - return true if some residue has unspecificed linkage
    %  getNoAntennae            - retrieve the number of uncertain antennae of this structure
    %  isFullySpecified         - return true if all linkages are specificied
    %  checkAllLinkages         - return true if all linkages are valid and specificied
    %  getDepth                 - retrieve the maximum distance between the root and the leaf
    %  computeNoMethylPositions - compute the number of positions available for methylation
    %  computeNoAcetylPositions - compute the number of positions available for acetylation
    %  removeResidue            - remove the residue from the glycan structure
    %  isProdOfX                - check if the glycan is a product of another glycan
    %  getComposition           - retrieve composition of glycan residues
    %  toGlycoCT                - retrieve the structure in GlycoCT format
    %  toString                 - retrieve the structure in GlycanBuilder string format
    %  toGlycoCTCondensed       - retrieve the structure in GlycoCT condendsed format
    %
    % See also GlycanResidue, ResidueType, GlycanSpecies.
    
    % Author: Gang Liu
    % Lastly Updated Date: 8/11/13
    
    
    properties
        glycanjava;
    end
    
    properties
        % ROOT  root residue in residue tree for glycan structure
        %    The 'ROOT' property is a GLYCANRESIDUE object.  It contains
        %       the sugar residue, and the links to its neighbouring
        %       residues
        %
        % See also GLYCANSTRUCT,GLYCANRESIDUE
        root;
    end
    
    properties
        % NAME  a short name for Glycan Structure
        %     The 'NAME' property is an array of characters.
        %
        % See also GLYCANSTRUCT
        name;
    end
    
    properties
        % ATTACHEDMOL  the glycan backbone
        %     The 'ATTACHEDMOL' property is a structure with "name and type" fields.
        %
        % See also GLYCANSTRUCT
        attachedMol;
    end
    
    properties
        % MASSOPTIONS the mass options used for molecular weight calculation
        %     The 'MASSOPTIONS' property is a MASSOPTIONS object
        %
        % See also GlycanStruct, MASSOPTIONS
        massOptions;
    end
    
    properties
        % BRACKET the container for all residues with undefined connectivity
        %     The 'BRACKET' property is a RESIDUE object
        %
        % See also GlycanStruct, MASSOPTIONS
        bracket;
    end
    
    methods
        function resetjava(obj)
            obj.glycanjava = structMat2Java(obj); 
        end
    end
    
    methods(Static)
        function glycanobj = loadmat(matfilename)
            glycanstruct = load(matfilename);
            p = fieldnames(glycanstruct);
            if(length(p)~=1)
                 error('MATLAB:GNAT:WRONGINPUT','wrong variable stored');
            end
            glycanobj = glycanstruct.(p{1});
            if(isa(glycanobj,'GlycanStruct'))
               glycanobj.resetjava;
            else
               error('MATLAB:GNAT:WRONGINPUT','wrong variable stored');
            end            
        end
    end  
      
    methods
        function obj= GlycanStruct(varargin)
            % GLYCANSTRUCT create a GlycanStruct object.
            %
            % GLYCAN =  GLYCANSTRUCT(GLYCANJAVA) creates a GlycanStruct object
            % from a GLYCAN java object created using GLYCANBUILDER library. Tree data structure is
            % used to represent the residue and their linkage information.
            %
            % GLYCAN =  GLYCANSTRUCT(RESIDUETREE) creates a GlycanStruct object
            % from a RESIDUETREE.
            %
            % GLYCAN =  GLYCANSTRUCT(STRING,FORMRAT) creates a GlycanStruct object
            % from a FORMAT formatted string STRING.
            %
            % GLYCAN =  GLYCANSTRUCT(RESIDUETREE,MASSOPTIONS) creates a GlycanStruct object
            % from a RESIDUETREE and a MASSOPTIONS.
            %
            % GLYCAN =  GLYCANSTRUCT(RESIDUETREE,BRACKET,MASSOPTIONS) creates a GlycanStruct
            %  object from a RESIDUETREE, a BRACKET and a MASSOPTIONS.
            %
            % GLYCAN =  GLYCANSTRUCT(STRING,FORMRAT,MASSOPTIOINS) creates a GlycanStruct object
            % from a FORMAT formatted string STRING and a MASSOPTONS.
            %
            %  See also GLYCANRESIDUE.
            
            error(nargchk(0,3,nargin));
            
            import java.net.MalformedURLException;
            %import org.eurocarbdb.application.glycanbuilder.*;
            
            if(nargin==1)
                isValidJavaGlycanInput = isa( varargin{1},'org.eurocarbdb.application.glycanbuilder.Glycan');
                isValidResidueInput = isa( varargin{1},'GlycanResidue');
                
                if ~(isValidJavaGlycanInput||isValidResidueInput)
                    errorReport(mfilename,'IncorrectInputType');
                end
                
                if(isValidJavaGlycanInput)
                    GlycanJava        = varargin{1};
                    obj.glycanjava  = GlycanJava;
                    obj.root             = GlycanResidue(GlycanJava.getRoot);
                    if(~isempty(GlycanJava.getBracket))
                        obj.bracket    = GlycanResidue(GlycanJava.getBracket);
                    else
                        obj.bracket    =  [];
                    end
                    obj.massOptions  =  MassOptions(GlycanJava.getMassOptions);
                    obj.name = char(GlycanJava.toStringOrdered(0));
                elseif(isValidResidueInput)
                    residueMap         = load('residueTypes.mat');
                    redEnd                  = residueMap.allresidues('redEnd');
                    redEndResidue    = GlycanResidue(redEnd);
                    obj.root                = redEndResidue;
                    secondresidue    = varargin{1};                   
                    unknownbond   = GlycanBond;
                    resLink                = GlycanLinkage(redEndResidue,secondresidue,unknownbond);
                    obj.root.linkageChildren =   resLink;
                    secondresidue.linkageParent =  resLink;
                    obj.glycanjava     = structMat2Java(obj);
                    %obj.massOptions = obj.glycanjava.getMassOptions;
                end
                
            elseif(nargin==2)   
                % two choice for two input argument 1): string, and input format, and 
                % 2): residue, bracket or root residue/mass option
                if(ischar(varargin{1})&& ischar(varargin{2}))
                    glyStr                   = varargin{1};
                    glyStr                   = strtrim(glyStr);
                    glyStrFormat      = varargin{2};
                    
                    %set up glycan document store
                    glycanDoc = org.eurocarbdb.application.glycanbuilder.GlycanDocument(...
                        org.eurocarbdb.application.glycanbuilder.BuilderWorkspace());
                    
                    % conver string to glycanBuilder.Glycan
                    try
                        glycanDoc.importFromString(glyStr,glyStrFormat);
                    catch exception
                        rethrow(exception);
                        error('MATLAB:GNAT:BadFileFormat','incorrect Glycan file format');
                    end
                    
                    obj.glycanjava        =  glycanDoc.getFirstStructure;
                    obj.root                    =  GlycanResidue(obj.glycanjava.getRoot);
                    obj.massOptions    =  MassOptions(obj.glycanjava.getMassOptions);
                    obj.name                 =  char(obj.glycanjava.toStringOrdered(0));
                    
                elseif(isa(varargin{1},'GlycanResidue') && isa(varargin{2},'MassOptions'))
                    obj.root = varargin{1};
                    obj.massOptions = varargin{2};
                end
            elseif(nargin==3)
                choice1 = ischar(varargin{1})&& ischar(varargin{2})...
                    &&isa(varargin{3},'MassOptions');
                choice2 =  isa(varargin{1},'GlycanResidue') && ...
                    isa(varargin{2},'GlycanResidue') && ....
                    isa(varargin{3},'MassOptions');
                
                if(choice1)
                    glyStr     = varargin{1};
                    glyStr     = strtrim(glyStr);
                    glyStrFormat = varargin{2};
                    
                    %set up glycan document store
                    glycanDoc = GlycanDocument(org.eurocarbdb.application.glycanbuilder.BuilderWorkspace());
                    
                    % conver string to glycanBuilder.Glycan
                    try
                        glycanDoc.importFromString(glyStr,glyStrFormat);
                    catch exception
                        rethrow(exception);
                        error('MATLAB:GNAT:BadFileFormat','incorrect Glycan file format');
                    end
                    
                    obj.glycanjava      = glycanDoc.getFirstStructure;
                    obj.root            = GlycoResidue(obj.glycanjava.getRoot);
                    obj.massOptions     = varargin{3};
                    obj.name            = char(obj.glycanjava.toStringOrdered(0));
                    
                elseif(choice2)
                    obj.root        = varargin{1};
                    obj.bracket     = varargin{2};
                    obj.massOptions = varargin{3};
                    obj.glycanjava = structMat2Java(obj);
                else
                    error('MATLAB:GNAT:BadInputFormat','incorrect input format');
                end
            end
        end
    end
    
    
    methods
        function residueToRootChar = getresiduetoroot(obj,residue)
            %getresiduetoroot return the string starting from specificied
            % residue to the rrot
            %    getresiduetoroot(obj,residue)
            %
            % See also removeNonRedEndResidue
            iterresidue = residue;
            residueToRootChar='';
            count = 0;
            isParent = ~isempty(iterresidue.linkageParent);
            while(isParent)
                residueTypeChar =  strcat(iterresidue.stereoConfig.symbol,...
                    '-');
                resType = iterresidue.residueType;
                if(~strcmp(resType.name,'freeEnd'))
                    residueTypeChar = strcat(residueTypeChar,resType.name);
                    residueTypeChar = strcat(residueTypeChar,',');
                    residueTypeChar = strcat(residueTypeChar,iterresidue.ringType.rSize);
                else
                    residueTypeChar=resType.name;
                end
                
                if(~isempty( iterresidue.linkageParent))
                    LinkageChar = iterresidue.linkageParent.bonds.posParent;
                    LinkageChar = strcat(LinkageChar,...
                        iterresidue.anomer.symbol);
                    LinkageChar = strcat(LinkageChar,...
                        iterresidue.anomer.carbonPos);
                else
                    LinkageChar='';
                end
                
                residueLinkageChar= strcat(LinkageChar,residueTypeChar);
                residueToRootChar = strcat(residueLinkageChar,residueToRootChar);
                
                isParent = ~isempty(iterresidue.linkageParent);
                if(isParent)
                    iterresidue = iterresidue.linkageParent.parent;
                    residueToRootChar = strcat('--',residueToRootChar);
                end;
                
                count =count +1;
            end
            
        end
        
        
        function isResidueAdded = addResidue(obj,residue,...
                varargin)
            %addResidue add residue to existing residue
            %    addResidue(GLYCANSTRUCTObj,residue,residueToAttach,anomerchar,bonds)
            %
            % See also removeNonRedEndResidue
            
            narginchk(5,5);
            residueType=varargin{1};
            anomerchar =varargin{2};
            bonds = varargin{3};
            isResidueAdded   = residue.addChild(residueType,anomerchar,bonds);
            
            % update name
            obj.glycanjava = obj.structMat2Java;
            obj.name = char(obj.glycanjava.toStringOrdered(0));
        end
        %%%%%%%%
        
        
        function isResidueAdded = addResidueToNonRedEnd(obj,...
                varargin)
            %addResidueToNonRedEnd add residue to the non reducing end
            %    addResidueToNonRedEnd(GLYCANSTRUCTObj,residue)
            %    addResidueToNonRedEnd(GLYCANSTRUCTObj,index,residue)
            %    addResidueToNonRedEnd(GLYCANSTRUCTObj,index,residue,bonds)
            %    addResidueToNonRedEnd(GLYCANSTRUCTObj,index,residueType,bonds)
            %    addResidueToNonRedEnd(GLYCANSTRUCTObj,index,residueType,anomer,bonds)
            %
            % See also removeNonRedEndResidue
            %%%%%%%%
            
            if(nargin==2)
                terminalResidueIndex = 1;
                bonds  = GlycanBond(org.eurocarbdb.application.Bond);
                residue = varargin{1};
            elseif(nargin==3)
                bonds = GlycanBond(org.eurocarbdb.application.Bond);
                terminalResidueIndex = varargin{1};
                residue = varargin{2};
            elseif(nargin==4)
                terminalResidueIndex = varargin{1};
                residueType = varargin{2};
                bonds = varargin{3};
                anomerchar='?';
            elseif(nargin==5)
                terminalResidueIndex = varargin{1};
                residueType = varargin{2};
                anomerchar=varargin{3};
                bonds = varargin{4};
            end
            
            terminalResidues = obj.getNonRedEndResidue;
            terminalResidue  = terminalResidues{1,terminalResidueIndex};
            
            if(isa(residue,'GlycanResidue'))
                isResidueAdded   = terminalResidue.addChild(residue,bonds);
            else
                isResidueAdded   = terminalResidue.addChild(residueType,anomerchar,bonds);
            end
            
            %update name
            % update name
            obj.glycanjava = obj.structMat2Java;
            obj.name = char(obj.glycanjava.toStringOrdered(0));
            
            %%%%%%%%
        end
        
        function isResidueDeleted = removeNonRedEndResidue(obj,terminalResidue)
            %removeNonRedEndResidue remove residue on the non-reducing end
            %
            % See also ADDRESIDUES
            if(~isa(terminalResidue,'GlycanResidue'))
                errorReport(mfilename,'IncorrectInputType');
            end
            % change parent linkage to the residue to be removed
            linkageParent =  terminalResidue.getLinkageParent;
            parentResidue =  linkageParent.getParent;
            
            linkageChildren = parentResidue.getLinkageChildren;
            nChildren       = length(linkageChildren);
            
            i=1;
            isFindChild=false;
            terminalResiduePos =-1;
            while((i<=nChildren) &&(~isFindChild))
                ithchild = linkageChildren(i,1).getChild;
                if(ithchild==terminalResidue)
                    isFindChild=true;
                    terminalResiduePos = i;
                end
                i=i+1;
            end
            if(terminalResiduePos==-1)
                isResidueDeleted=0;
                return
                % errorReport(mfilename,'code error');
            end
            parentResidue.unsetLinkageChildren(terminalResiduePos);
            isResidueDeleted=1;
            
            % update name
            obj.glycanjava = obj.structMat2Java;
            obj.name = char(obj.glycanjava.toStringOrdered(0));
        end
        
        function nonredEndResidues = getNonRedEndResidue(obj)
            % GETNONREDENDRESIDUE get residues on the non-reducing end
            %
            %  See also SELECTTERMINALRESIDUE
            if(isempty(obj.root))
                nonredEndResidues=[];
                return;
            end
            allResidues                 =  getAllResidues(obj);
            nonredEndResidues  = selectTerminalResidue(obj,allResidues);
        end
        
        function redEndResidues= selectTerminalResidue(obj,allResidues)
            % SELECTTERMINALRESIDUE select residues on the reducing end
            %  from the residue list
            %
            % See also GlycanStruct
            
            % check number of childs
            nRedEndResidues = 0;
            index=[];
            for i=1: length(allResidues)
                residue=allResidues{1,i};
                nChild = length(getLinkageChildren(residue));
                if(nChild == 0)
                    index = [index;i];
                    nRedEndResidues = nRedEndResidues+1;
                end
            end
            
            redEndResidues = allResidues(index);
        end
        
        function nRes = getnResidues(obj)
            %GETNRESIDUES get number of residues in glycan structure
            %
            % See also setNResidues
            residues = getAllResidues(obj);
            nRes=length(residues);
        end
        
        function nLkgs = getnLinkages(obj)
            %GETNLINKAGES get number of glycan linkages in glycan structure
            %
            % See also setNLinkage
            residues = getAllResidues(obj);
            nLkgs=length(residues)-1;
        end
        
        function root = getRoot(obj)
            %GETROOT get root of glycan sequence in glycan structure
            %
            % See also setRoot
            root = obj.root;
        end
        
        function attachedMol = getAttachedMol(obj)
            % GETATTACHEDMOL get glycan backbone molecule
            %
            % See also SETATTACHEDMOL
            attachedMol = obj.attachedMol;
        end
        
        function  obj= setRoot(obj,root)
            %SETROOT set resiude root in glycan structure
            %
            % See also GETRoot
            obj.root = root;
        end
        
        function  obj= setMassOptions(obj,massOptions)
            %SETMASSOPTIONS set calculation options for glycan molecular weight
            %
            % See also GETMASSOPTIONS
            obj.massOptions = massOptions ;
        end
        
        function massOptions = getMassOptions(obj)
            %GETMASSOPTIONS get calculating optioins for glycan molecular weight
            %
            % See also GETMASSOPTIONS
            massOptions = obj.massOptions;
        end
        
        function  obj = setAttachedMol(attachedMol)
            % SETATTACHEDMOL set the molecule to which the glycan is attached
            %
            % See also GETATTACHEDMOL
            obj.attachedMol =  attachedMol;
        end
        
        function  obj= setName(obj,name)
            % SETNAME set the name for the glycan
            %
            % See also GETNAME
            obj.name =  name;
        end
        
        function  name= getName(obj)
            % GETNAME get the name for the glycan
            %
            % See also SETNAME
            name = obj.name;
        end
        
        
        function  resVector  = getAllResidues(obj,varargin)
            % GETALLRESIDUES get residues from the root property
            %
            % See also GETRESIDUES
            resVector = cell(0,1);
            residue    =  obj.root;
            resVector = getResidues(residue,resVector);
            if(isprop(obj,'bracket') &&~isempty(obj.bracket))
                resVector = getResidues(obj.bracket,resVector);
            end
            
            function resVector = getResidues(residue,resVector)
                % GETRESIDUES retrieve the residue and linkage information from
                % the parent and its children
                %
                %  See also GETALLRESIDUES
                resVector{length(resVector)+1}=residue;
                childLinkageList = residue.getLinkageChildren;
                numChild = size(childLinkageList,1);
                for i=1: numChild
                    childLinkage = childLinkageList(i,1);
                    child = getChild(childLinkage);
                    % recursive operation
                    resVector=getResidues(child,resVector);
                end
            end
        end
        
        function isFragmentTrue = isFragment(obj)
            % ISFRAGMENT true for that the GlycanStruct object is a fragment
            %   isFragment(GLYCANSTRUCTOBJ) returns 1 (true) if the object
            %     is a fragment and otherwise 0 (false)
            %
            %  See also ISEMPTY
            glycanJava = obj.glycanjava; %structMat2Java(obj);
            isFragmentTrue = glycanJava.isFragment;
            return
        end
        
        function numMaxResiduesDepth = getDepth(obj)
            %GETDEPTH the maximum distance between the root and the leaf
            % getDepth(GLYCANSTRUCTOBJ) returns the number of maximum residues
            %  between the root and the leaf.
            %
            %See also GLYCANSTRUCT
            glycanJava          = obj.glycanjava; %structMat2Java(obj);
            numMaxResiduesDepth = glycanJava.getDepth;
        end
        
        function isRepetitionTrue = hasRepetition(obj)
            % HASREPETITION true if the structure contains repeat blocks
            %   hasRepetition() returns 1 (true) if the object
            %     has repeat blocks and otherwise 0 (false)
            %
            % See also ISFRAGMENT
            glycanJava       = obj.glycanjava; %structMat2Java(obj);
            isRepetitionTrue = glycanJava.hasRepetition;
        end
        
        function numAntennae = getNoAntennae(obj)
            % getNoAntennae return the number of uncertain antennae of this structure
            %   getNoAntennae(GLYCANSTRUCTobj) returns the number of uncertain antennae in the
            %    bracket
            %
            % See also GLYCANSTRUCT
            glycanJava       = obj.glycanjava;%structMat2Java(obj);
            numAntennae      = glycanJava.getNoAntennae;
        end
        
        function isAllLinkagesValid = checkAllLinkages(obj)
            % checkAllLinkages return true if all linkages are valid and specificied
            %   checkAllLinkages(GLYCANSTRUCTobj) returns true if all linkages in glycan residues are valid
            %    and specified
            %
            % See also GLYCANSTRUCT
            glycanJava              = obj.glycanjava; %structMat2Java(obj);
            isAllLinkagesValid      = glycanJava.checkLinkages;
        end
        
        function isFullySpecifiedTrue = isFullySpecified(obj)
            % isFullySpecified return true if all linkages are specificied
            %   isFullySpecified(GLYCANSTRUCTobj) returns true if all linkages in glycan residues are
            %    and specified
            %
            % See also GLYCANSTRUCT
            glycanJava                = obj.glycanjava; %structMat2Java(obj);
            isFullySpecifiedTrue      = glycanJava.isFullySpecified;
        end
        
        
        function iscontains = contains(obj,varargin)
            % C0NTAINS true if the structure contains other glycan structure
            %    CONTAINS(GLYCANSTRUCTOBJ2) returns 1 (true) if the object has
            %      contains same structure as GLYCANSTRUCTOBJ2 and otherwise 0
            %      (false). Default comparison options are: 1) comparison
            %      not starting from the reducing end; 2) comparison of all the
            %      residues in the structure; 3) fuzzy comparison.
            %
            %    CONTAINS(GLYCANSTRUCTOBJ2,include_redend)
            %
            %    CONTAINS(GLYCANSTRUCTOBJ2,include_redend,include_all_leaf)
            %
            %    CONTAINS(GLYCANSTRUCTOBJ2,include_redend,include_all_leaf,isfuzzy)
            % See aslo hasRepetition
            narginchk(1,4);
            glycan1Java   = obj.glycanjava; %structMat2Java(obj);
            if(nargin==1)
                iscontains  = true;
            elseif(nargin==2)
                obj2        = varargin{1};
                glycan2Java = obj2.glycanjava; %tructMat2Java(obj2);
                iscontains  = glycan1Java.contains(glycan2Java,...
                    0,0);
            elseif(nargin==3)
                obj2           = varargin{1};
                include_redend = varargin{2};
                glycan2Java = obj2.glycanjava; %structMat2Java(obj2);
                iscontains  = glycan1Java.contains(glycan2Java,...
                    include_redend,0);
            elseif(nargin==4)
                obj2                   = varargin{1};
                include_redend         = varargin{2};
                include_all_leaf       = varargin{3};
                glycan2Java            = obj2.glycanjava;% structMat2Java(obj2);
                iscontains             = glycan1Java.contains(glycan2Java,...
                    include_redend,include_all_leaf);
            elseif(nargin==5)
                obj2                   = varargin{1};
                include_redend         = varargin{2};
                include_all_leaf       = varargin{3};
                isfuzzy                = varargin{4};
                glycan2Java            =obj2.glycanjava;% structMat2Java(obj2);
                iscontains             = glycan1Java.contains(glycan2Java,...
                    include_redend,include_all_leaf,isfuzzy);
            end
            return;
        end
        
        function isemptyObj = isempty(obj)
            %ISEMPTY true for empty GlycanStruct object
            %   isempty(GLYCANSTRUCTOBJ) returns 1 (true) if the object contains on
            %     structure and otherwise O (False)
            %
            %   See also GLYCANSTRUCT
            isemptyObj = isempty(obj.root);
            isemptyObj = isemptyObj && isempty(obj.name);
            isemptyObj = isemptyObj && isempty(obj.attachedMol);
            return;
        end
        
        function string = toGlycoCT(obj)
            % TOGLYCOCT get the string in GlycoCT format
            %
            % See also GLYCANSTRUCT
            glycanJava = obj.glycanjava; %structMat2Java(obj);
            string     = glycanJava.toGlycoCT;
        end
        
        function string = toString(obj)
            % toString get the string in GlycanBuilder string format
            %
            % See also GLYCANSTRUCT
            
            string     = obj.glycanjava.toStringOrdered(0);
            string     = char(string);
        end
        
        function string = toGlycoCTCondensed(obj)
            % toGlycoCTCondensed get the string in Glycoct condensed format
            %
            % See also GLYCANSTRUCT
            
            string     = obj.glycanjava.toGlycoCTCondensed;
            string     = char(string);
        end
        
        function string = toLinucs(obj)
            % toLinucs get the string in LINUCS format
            %
            % See also GLYCANSTRUCT        

            % set up workspace
            import org.eurocarbdb.application.glycanbuilder.*;
            import org.eurocarbdb.application.glycanbuilder.*;
%             import org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
%             import org.eurocarbdb.application.glycanbuilder.GlycanDocument;
            
            glycanWorkSpace = BuilderWorkspace;
            glycanWorkSpace.setAutoSave(true);
            glycanDoc = glycanWorkSpace.getStructures();
            glycanDoc.addStructure(obj.glycanjava);            
            string     = glycanDoc.toString('linucs');
            string     = char(string);
        end       
    end
    
    methods
        function new = clone(obj)
            %CLONE copy a GlycanStruct object
            %  clone(GLYCANSTRUCTOBJ) creates a new GlycanStruct object
            %
            %  See also RXN
            
            % Instantiate new object of the same class.
            new = feval(class(obj));
            
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                if(isa(obj.(p{i}),'handle'))
                    new.(p{i}) = obj.(p{i}).clone;
                else
                    new.(p{i}) = obj.(p{i});
                end
            end
        end
        
        function mass = computeMass(obj)
            %computeMass compute the mass of a glycan object
            %  computeMass(GLYCANSTRUCTobj) computes the mass
            %
            %  See also  GlycanStruct
            glycanJava =  obj.glycanjava; %structMat2Java(obj);
            mass       =  glycanJava.computeMass();
        end
        
        function numMethylPos = computeNoMethylPositions(obj)
            %computeNoMethylPositions compute the number of positions available
            % for methylation
            %  computeNoMethylPositions(GLYCANSTRUCTobj) computes the
            %  number of positions for methylation
            %
            %  See also  GlycanStruct
            glycanJava   =  obj.glycanjava; %structMat2Java(obj);
            numMethylPos =  glycanJava.computeNoMethylPositions();
        end
        
        function numMethylPos = computeNoAcetylPositions(obj)
            %computeNoAcetylPositions compute the number of positions available
            % for acetylation
            %  computeNoAcetylPositions(GLYCANSTRUCTobj) computes the
            %   number of positions for acetylation
            %
            % See also GlycanStruct
            
            glycanJava   =  obj.glycanjava; %structMat2Java(obj);
            numMethylPos =  glycanJava.computeNoAcetylPositions();
        end
        
        function mz   = computeMZ(obj)
            %computeMZ compute the m/z value of a glycan object
            %  computeMZ(GLYCANSTRUCTobj) computes the m/z ratio
            %
            %  See also GlycanStruct
            glycanJava =  obj.glycanjava; %structMat2Java(obj);
            mz         =  glycanJava.computeMZ();
        end
        
        function formulastring = computeFormula(obj)
            %computeFormula compute the chemical formula of a glycan object
            %  computeFormula(GLYCANSTRUCTobj) computes the chemical
            %   formula
            %
            % See also GlycanStruct
            glycanJava      =  obj.glycanjava; %structMat2Java(obj);
            formulastring   =  glycanJava.computeMolecule().tostring;
        end
        
        function hasResidueRemoved = removeResidue(obj,glcanresidueObj)
            %removeResidue remove the residue from the glycan structure
            %
            % See also GlycanStruct
            glycanJava          =  obj.glycanjava; %structMat2Java(obj);
            glycanresidueJava   =  residueMat2Java(glcanresidueObj);
            hasResidueRemoved   =  glycanJava.removeResidue(glycanresidueJava);
            newobj              =  GlycanStruct(glycanJava);
            obj.root            =  newobj.root;
            obj.bracket         =  newobj.bracket;
            obj.massOptions     =  newobj.massOptions;
            obj.name            =  char(glycanJava.toStringOrdered(0));
            obj.glycanjava      =  obj.structMat2Java;
            return;
        end
        
        function isequalglycanobj = compareTo(obj,obj2,varargin)
            %compareTo compare the glycan to another GlycanStruct object
            % compareTo(GLYCANSTRUCTobj) compares the glycan to another
            %  object including the charge info.
            %
            % compareTo(GLYCANSTRUCTobj,isChargeIgnored) compares the glycan to another
            %  object if the charge info. is ignored.
            %
            % See also GlycanStruct
            glycanJava         = obj.glycanjava; %structMat2Java(obj);
            glycanJava2        = obj2.glycanjava;%structMat2Java(obj2);
            
            if(nargin==2)
                isChargeIgnored  = false;
            elseif(nargin==3)
                isChargeIgnored  = varargin{1};
            end
            
            if(isChargeIgnored)
                isequalglycanobj = glycanJava.compareTo(glycanJava2);
            elseif(nargin==3)
                isequalglycanobj = glycanJava.compareToIgnoreCharges(glycanJava2);
            end
        end
        
        function isStructEqual = equalStruct(obj,obj2)
            %equalStruct returns true if two glyan have the same structure
            % equalStruct(GLYCANSTRUCTobj) compares the structures of two glycans
            %
            % See also GlycanStruct
            glycanJavaString    =  obj.toString;
            glycanJava2String   =  obj2.toString;
            % isStructEqual = glycanJava.equalsStructure(glycanJava2);
            isStructEqual     = strcmp(glycanJavaString,glycanJava2String);
        end
        
        function isFuzzyTrue = isFuzzy(obj,varargin)
            %isFuzzy returns true if some residue has unspecificed linkage
            % isFuzzy(GLYCANSTRUCTobj) check if the residue in the
            %  structure has unspeicified linkage
            %
            % isFuzzy(GLYCANSTRUCTobj,tolerate_labile) check if the residue in the
            %  structure has unspeicified linkage and labile residue is not
            %  considered in the search database
            %
            % See also GlycanStruct
            
            
            narginchk(1,2);
            glycanJava    = obj.glycanjava; %structMat2Java(obj);
            if(nargin==1)
                tolerate_labile=false;
            elseif(nargin==2)
                tolerate_labile=varargin{1};
            end
            isFuzzyTrue   = glycanJava.isFuzzy(tolerate_labile);
        end
        
        function composition=getComposition(obj)
            %getComposition returns a structure composition
            % getComposition(GLYCANSTRUCTobj) returns the structure
            % composition
            %
            % See also GlycanStruct
            if(isempty(obj.root))
                composition='';
                return;
            end
            composition = '';            
            composition = setComposition(obj.root,composition);
            
           if(~isempty(obj.bracket))
              composition = setComposition(obj.bracket,composition);
           end            
        end
        
        function compstring = getCompositionString(obj)
           glycancomp = obj.getComposition;
           compfieldnames = fieldnames(glycancomp);
           compstring = '';
           for i = 1: length(compfieldnames)
               if(strcmpi(compfieldnames{i},'freeEnd'))
                   continue
               end
               compstring = [compstring compfieldnames{i} ...
                   int2str(glycancomp.(compfieldnames{i}))];
           end
        end
    end
    
    methods
        isPossibleYisXProd =  isProdOfX(obj,glycanstructObj2,enzObjArray)
        residueToRootChar = getresiduetoterminal(obj,residue,varargin);
    end
    
    methods
        glycanJava =  structMat2Java(obj)
    end
end

