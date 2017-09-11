classdef GlycanResidue  < handle
%GlycanResidue class representing a glycan residue and the linkages
% to its neighboring residues
%
% A GlycanResidue object is a generic representation of carbohydrate
%  unit for a glycan. It consists of a set of residue molecular properties,
%  including anomer, stereoconfig, aldiotol, the linkages between itself
%  and its parents, the linkages between itself and its children, etc.
%
% GlycanResidue properties:
%  residueType             - carbohydrate residue type;
%  name                         - name of the monosaccharide residue
%  anomer                     - orientation of anomeric hydroxyl group
%  stereoConfig            - fischer systematic series
%  ringType                   - cyclic hemiacetal
%  alditol                        - if the residue is alditol
%  linkageParent           - glycosidic linkage to the parent of the residue
%  linkageChildren        - glycosidic linkage to the children of the residue
%
% GlycanResidue methods:
%  GlycanResidue           - create a GlycanResidue object.
%  getResidueType          - retrieve the 'residueType' property.
%  getName                 - retrieve the 'name' property.
%  getAnomericState        - retrieve the state of an anomer
%  getAnomericCarbon       - retrieve the position of an anomeric carbon
%  getAlditol              - retrieve the alditol property
%  getLinkageParent        - retrieve the linkage to parent
%  getLinkageChildren      - retrieve the linkage to children
%  getStereoConfig         - retrieve the "StereoConfig" property
%  getRingSize                - retrieve the size of the carbon ring
%  setResidueType         - set the "residueType" property
%  setName                     - set the 'name' property.
%  setAnomer                 - set the "anomer"' property
%  setStereoConfig        - set the 'stereoConfig' property.
%  setRingType               - set the 'ringType' property
%  setAlditol                    -  set the "alditol" property
%  setLinkageParent       - set the linkage to the parent
%  setLinkageChildren   - set the linkage to the children
%  residueMat2Java              - convert a MATLAB residue object to a Java residue object 
%  unsetLinkageChildren    - unset the linkage to the children
%  clone                   - create a clone of GlycanResidue object
%
% See also GLYCANLINKAGE,GLYCANSTRUCT.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab.
    
    properties
        % IDRES the IDs of the residue
        %     IDRES is a numeric type (double)
        %
        %  See also GLYCANRESIDUE
        IDres;
    end
    
    properties
        % RESIDUETYPE the description of the residue family type
        %    RESIDUETYPE property is a RESIDUETYPE object
        %
        % See also GLYCANRESIDUE
        residueType;
    end
    
    properties
        % NAME the description of residue IUPAC name
        %    NAME property is a character array
        %
        % See also GLYCANRESIDUE
        name;
    end
    
    properties
        % ANOMER the description of residue IUPAC name
        %    ANOMER property is an ANOMER object
        %
        % See also GLYCANRESIDUE
        anomer;
    end
    
    properties
        % STEREOCONFIG the description of the fisher configuration
        %   STEREOCONFIG property is an STEREOCONFIG object
        %
        %  See also GLYCANRESIDUE
        stereoConfig;
    end
    
    properties
        % RINGTYPE the ring type, either Pyranose (p), or Furanose (f).
        %     RINGTYPE property is a RINGTYPE object
        %
        %  See also GLYCANRESIDUE
        ringType;
    end
    
    properties
        %  ALDITOL indicate if the residue molecular is the alditol or not
        %     ALDITOL property is a logical value
        %
        %  See also GLYCANRESIDUE
        alditol;
    end
    
    properties
        % LINKAGEPARENT  the description of the linkage of the residue object to its parent residue
        %    LINKAGEPARENT property is a GLYCANLINKAGE object
        %
        %  See also GLYCANRESIDUE
        linkageParent;
    end
    
    properties
        % LINKAGECHILDREN  the description of the linkage of the residue
        % object to its children residue
        %   LINKAGECHILDREN property is a GLYCANLINKAGE object
        %
        %  See also GLYCANRESIDUE
        linkageChildren;
    end
    
    % getter and setter methods
    methods
        function residueType = getResidueType(obj)
            %  GETRESIDUETYPE get the type of the residue
            %    return type: RESIDUETYPE
            %
            %  See also GLYCANRESIDUE
            residueType = obj.residueType;
        end
        
        function name = getName(obj)
            %  GETNAME get the name of the residue
            %    return type: char array
            %
            %  See also GLYCANRESIDUE
            name = obj.name;
        end
        
        function anomeriState = getAnomericState(obj)
            %  GETANOMERICSTATE get the state of the anomer
            %    return type: char array
            %
            %  See also GLYCANRESIDUE
            anomeriState = getSymbol(obj.anomer);
        end
        
        function anomericCarbon = getAnomericCarbon(obj)
            %  GETANOMERICCARBON get the position of the anomeric carbon
            %    return type: numeric double
            %
            %  See also GLYCANRESIDUE
            anomericCarbon = getCarbonPos(obj.anomer);
        end
        
        function chirality = getChirality(obj)
            %  getChirality get the chirality
            %    return type: char
            %
            %  See also GLYCANRESIDUE
            chirality = getSymbol(getStereoConfig(obj));
        end
        
        function stereoConfig = getStereoConfig(obj)
            %  getStereoConfig get the stereochemical configuration of the residue
            %    return type: STEREOCONFIG
            %
            %  See also GLYCANRESIDUE
            stereoConfig = obj.stereoConfig;
        end
        
        function ringSize = getRingSize(obj)
            %  GETRINGSIZE get the size of a carbon ring
            %    return type: numeric double
            %
            %  See also GLYCANRESIDUE
            ringSize = obj.ringType.getRingSize;
        end
        
        function alditol = getAlditol(obj)
            %  getAlditol get  1 if the residue is an alditol and 0 otherwise.
            %    return type: logical value
            %
            %  See also GLYCANRESIDUE
            alditol = obj.alditol;
        end
        
        function linkageParent = getLinkageParent(obj)
            %  getLinkageParent get the residue's linkage to its parents
            %    return type: GlycanLinkage
            %
            %  See also GLYCANRESIDUE
            linkageParent = obj.linkageParent;
        end
        
        function parentRes = getParent(obj)
            %  getParent get the parent residue
            %    return type: GlycanResidue
            %
            %  See also GLYCANRESIDUE
            if( isprop(obj,'linkageParent') && ~isempty(obj.linkageParent) )
                  linkageparent = obj.linkageParent;
                  parentRes = linkageparent.getParent;
            end
        end
        
        
        function childrenRes = getChildren(obj)
            %  getChildren get the children residue
            %    return type: GlycanResidue
            %
            %  See also GLYCANRESIDUE
              if(isprop(obj,'linkageChildren') && (~isempty(obj.linkageChildren) ))
                  childrenRes=[];
                  linkagechildren = obj.linkageChildren;
                  for i = 1: length(linkagechildren)
                      childrenRes = [childrenRes;linkagechildren(i,1).getChild];
                  end
              else
                  childrenRes =[];
              end
        end
        
        function linkageChildren = getLinkageChildren(obj)
            %  getLinkageChildren get the residue's linkage to its children
            %    return type: GlycanLinkage
            %
            %  See also GLYCANRESIDUE
            linkageChildren = obj.linkageChildren;
        end
        
        % SET METHODS
        function obj = setResidueType(residueType)
            % SETRESIDUETYPE set the property of "ResidueType"
            %    Input type: RESIDUETYPE
            %
            %  See also GLYCANRESIDUE
            obj.residueType =  residueType;
        end
        
        function obj = setName(name)
            % SETNAME set the name of the residue
            %    Input type: CHAR
            %
            %  See also GLYCANRESIDUE
            obj.name = name;
        end
        
        function obj = setAnomer(anomer)
            % SETANOMER set the property of "Anomer"
            %    Input type: ANOMER
            %
            %  See also GLYCANRESIDUE
            obj.anomer = anomer;
        end
        
        function  obj= setStereoConfig(StereoConfig)
            % SETSTEREOCONFIG set the property of "StereoConfig"
            %    Input type: STEREOCONFIG
            %
            %  See also GLYCANRESIDUE
            obj.StereoConfig = StereoConfig  ;
        end
        
        function  obj= setRingType(ringType)
            % SETRINGTYPE set the property of "RingType"
            %    Input type: RINGTYPE
            %
            %  See also GLYCANRESIDUE
            obj.ringType =  ringType;
        end
        
        function  obj = setAlditol(alditol)
            % SETALDITOL set the property of "Alditol"
            %    Input type: logic
            %
            %  See also GLYCANRESIDUE
            obj.alditol = alditol;
        end
        
        function  obj= setLinkageParent(obj,linkageParent)
            % SETLINKAGEPARENT set the property of "LINKPAGEPARENT"
            %    Input type: GLYCANLINKAGE
            %
            %  See also GLYCANRESIDUE
            obj.linkageParent = linkageParent  ;
        end
        
        function  obj= unsetLinkageChildren(obj,ithPos)
            % unsetLinkageChildren unset the ith positionof "LINKPAGECHILDREN"
            %    Input type: GLYCANLINKAGE
            %
            %  See also GLYCANRESIDUE
            count=1;
            for i=1:length(obj.linkageChildren)
                if(i~=ithPos)
                    newLinkageChildren(count,1)=obj.linkageChildren(i,1);
                    count=count+1;
                end
            end
            if(count==1)
                obj.linkageChildren = [];
            else
                obj.linkageChildren =newLinkageChildren;
            end
        end
        
        function  obj= setLinkageChildren(obj,linkageChildren)
            % SETLINKAGECHILDREN set the property of "LINKPAGECHILDREN"
            %    Input type: GLYCANLINKAGE
            %
            %  See also GLYCANRESIDUE
            obj.linkageChildren =  linkageChildren;
        end
    end
    
    methods
        function obj= GlycanResidue(varargin)
            %  GLYCANRESIDUE create a GlycanResidue object
            %
            %  GRES = GLYCANRESIDUE(RESIDUEJAVA) creates a GlycanResidue object
            %       from a RESIDUE java object created using GLYCANBUILDER library.
            %
            %  GRES = GLYCANRESIDUE(residueAnomer,residueStereoConfig,residueRingType,residueType)
            %      creates a GlycanResidue object using four inputs including "ANOMER","StereoConfig", "RingType"
            %     and "ResidueType".
            %
            %   GRES = GLYCANRESIDUE(residueAnomer,residueStereoConfig,residueRingType,residueType,residueLinkageParent,
            %     residueLinkageChildren)  creates a GlycanResidue object using six inputs including "ANOMER","StereoConfig", "RingType"
            %    "ResidueType", "LinkageParent", and "LinkageChildren".
            %
            %  See also GLYCANRESIDUE.
            
            % validate the number of input arguments
            
            error(nargchk(0,6,nargin));
            
            if(nargin==0)
                % obj= obj@IDobject();
            elseif(nargin==1)
                if(isempty(varargin{1}))
                    %do nothing
                elseif(isa(varargin{1},'org.eurocarbdb.application.glycanbuilder.Residue') )
                    resJava = varargin{1};
                    obj.anomer = Anomer(char(resJava.getAnomericState),char(resJava.getAnomericCarbon));
                    obj.stereoConfig = StereoConfig(char(resJava.getChirality));
                    obj.ringType = RingType(char(resJava.getRingSize));
                    obj.residueType = ResidueType(resJava.getType);
                    
                    obj.alditol = resJava.isAlditol;
                    obj.IDres    = resJava.id;
                    
                    childrenLinkageArrayJava = resJava.getChildrenLinkages;
                    numChildren = childrenLinkageArrayJava.size;
                    
                    %retrieve linkage information
                    obj.linkageChildren=[];
                    for i = 1: numChildren
                        LinkageResJava = childrenLinkageArrayJava.elementAt(i-1);
                        
                        % convert children residue from Java to Matlab format
                        childrenResJava = LinkageResJava.getChildResidue;
                        obj_children       =  GlycanResidue(childrenResJava);
                        
                        % convert linkage bonds from Java to Matlab format
                        for j=1:LinkageResJava.getBonds.size
                            bondJava = LinkageResJava.getBonds.elementAt(j-1);
                            bonds(j,1)= GlycanBond(bondJava);
                        end
                        
                        glyLinkageMat = GlycanLinkage(obj,obj_children,bonds);
                        obj.linkageChildren = [obj.linkageChildren;glyLinkageMat];
                        
                        obj_children.linkageParent = glyLinkageMat;
                    end
                elseif(isa(varargin{1},'ResidueType'))
                    obj.residueType = varargin{1};
                    obj.anomer =Anomer('?',varargin{1}.anomericCarbon);
                    obj.stereoConfig = StereoConfig(varargin{1}.chirality);
                    obj.ringType = RingType(varargin{1}.ringSize);
                end
               
             elseif(nargin==2)
                 obj.residueType  = varargin{1};
                 anomersymbol  = varargin{2};                 
                 obj.anomer = Anomer(anomersymbol,varargin{1}.anomericCarbon);
                obj.stereoConfig =StereoConfig(varargin{1}.chirality);
                obj.ringType =RingType(varargin{1}.ringSize);                
                
            elseif(nargin==4)
                anomer_res = varargin{1};
                stereoConfig_res =  varargin{2};
                ringType_res = varargin{3};
                residueType_res =  varargin{4};
                
                obj.anomer = anomer_res;
                obj.stereoConfig = stereoConfig_res;
                obj.ringType = ringType_res;
                obj.residueType = residueType_res;
                
                
            elseif(nargin==6)
                anomer_res = varargin{1};
                stereoConfig_res =  varargin{2};
                ringType_res = varargin{3};
                residueType_res =  varargin{4};
                linkageParent_res = varargin{5};
                linkeageChildren_res = varargin{6};
                
                obj.anomer = anomer_res;
                obj.stereoConfig = stereoConfig_res;
                obj.ringType = ringType_res;
                obj.residueType = residueType_res;
                
                obj.linkageParent = linkageParent_res;
                obj.linkageChildren = linkeageChildren_res;
            end
        end
    end
    
    methods
        resJava = residueMat2Java(obj)
    end
    
    methods
           function res = dispResidueInfo(obj)
            % dispResidueTypeInfo display residue type info.
            %
            %  See also GlycanResidue
            res = obj.residueType.name;
            res = strcat(res,'{');
            res = strcat(res,obj.anomer.getSymbol);
            res = strcat(res,'}');
            if(~isempty(obj.linkageParent))
              res = strcat(res,obj.linkageParent.bonds.disp);
            end
            
        end % end    
        
        function composition=setComposition(obj,composition)
           %setComposition returns a structure composition
            %   setComposition(glycanResidueObj) returns the structure
            %     composition
            %
            %  See also GlycanResidue
            resType = obj.getResidueType.name;
%             disp(resType);
             
             if(isfield(composition,resType))
                 composition.(resType)= composition.(resType)+1;
             else
                 composition.(resType)= 1;
             end
             
            childRes           = obj.getChildren;
            numChildren  = length(childRes);
%             disp(composition);
            
            for i = 1 : numChildren
                     child =childRes(i,1);
                     composition = setComposition(child,composition);
%                      if(numChildren>1) 
%                          disp('check point');
%                          disp(num2str(child.IDres));
%                      end
%                     disp(composition);
            end
            
%             if(numChildren==0)
%                 disp('end');
%             end
            
            
        end         
        
        function isChildAdded = addChild(obj,varargin)
       %addChild add the children residue to the parent
       %    isAdded = addChild(obj,childResidue) 
       %    isAdded = addChild(obj,childResidue,bonds) 
       %    isAdded = addChild(obj,childResidueType,bonds)
       %    isAdded = addChild(obj,childResidueType,anomerchar,bonds)
       %
       % See also GlycanResidue
       
             if(nargin==2)
                if(isa(varargin{1},'GlycanResidue'))
                   glycanResObj2 = varargin{1};
                 elseif(isa(varargin{1},'ResidueType'))
                   glycanResObj2 = GlycanResidue(varargin{1});
                 end 
                bonds = GlycanBond(org.eurocarbdb.application.glycanbuilder.Bond);                 
            elseif(nargin==3)
                 if(isa(varargin{1},'GlycanResidue'))
                   glycanResObj2 = varargin{1};
                 elseif(isa(varargin{1},'ResidueType'))
                   glycanResObj2 = GlycanResidue(varargin{1});
                 end 
                 bonds = varargin{2};   
             elseif(nargin==4)
                resType =         varargin{1};
                anomerChar = varargin{2};      
                glycanResObj2 = GlycanResidue(resType,anomerChar);
                bonds = varargin{3};      
            end
           
            link = GlycanLinkage(obj,glycanResObj2,bonds);
            if(isempty(obj.linkageChildren))
                obj.linkageChildren = link;
            else
                obj.linkageChildren = [obj.linkageChildren;link];
            end
            glycanResObj2.linkageParent = link;
            
            isChildAdded=true;
        end
        
        function new = clone(obj)
            %CLONE copy a GlycanResidue object
            %  CLONE(GLYCANRESIDUEobj) creates a new GlycanResidue object
            %
            %  See also GLYCANRESIDUE
            
            % Instantiate new object of the same class.
            if(isempty(obj))
                 new = [];
                 return;                 
            end
            
            new = feval(class(obj));
            
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                if(~isa(obj.(p{i}),'handle'))
                    new.(p{i}) = obj.(p{i});
                end
            end
            
            if(~isempty(obj.anomer))
                new.anomer = obj.anomer.clone;
            end
            
             if(~isempty(obj.stereoConfig))
                 new.stereoConfig = obj.stereoConfig.clone;
            end
               
            if(~isempty(obj.ringType))
                  new.ringType =  obj.ringType.clone;
            end
            
            if(~isempty(obj.residueType))
                    new.residueType =  obj.residueType.clone;
            end
           
            %retrieve linkage information from children
            linkageToChildren = obj.getLinkageChildren;
            numChildren=length(linkageToChildren);
            newlinkageToChildren =[];
            
            for i = 1: numChildren
                linkageToChild = linkageToChildren(i);
                childResidue = linkageToChild.getChild;
                newChildResidue =  childResidue.clone;
                
                % create a new GlycanLinkage object
                for j=1:length(linkageToChild.getBonds)
                    bonds = linkageToChild.getBonds;
                    newbonds(j)=bonds(j).clone;
                end
                
                try
                    newlinkageToChild = GlycanLinkage(new,newChildResidue,newbonds);
                    newlinkageToChildren = [newlinkageToChildren;newlinkageToChild];
                    newChildResidue.linkageParent = newlinkageToChild;
                catch err
                    disp('error');
                end
            end
            new.linkageChildren=newlinkageToChildren;
            
        end
        
        function new = copy(obj)
            % obj_new = OBJ.clone;
            %
            % Use this syntax to make a deep copy of an object OBJ, i.e. OBJ_OUT has the same field values,
            % but will not behave as a handle-copy of OBJ anymore.
            %
            meta = metaclass(obj);
            obj_out = feval(class(obj));
            s = warning('off', 'My_hgsetget:dimension');
            for i = 1:length(meta.Properties)
                prop = meta.Properties{i};
                if ~(prop.Dependent || prop.Constant) && ~(isempty(obj.(prop.Name)) && isempty(obj_out.(prop.Name)))
                    if isobject(obj.(prop.Name)) && isa(obj.(prop.Name),'handleplus')
                        obj_out.(prop.Name) = obj.(prop.Name).clone;
                    else
                        try
                            obj_out.(prop.Name) = obj.(prop.Name);
                        catch
                            warning('handleplus:copy', 'Problem copying property "%s"',prop.Name)
                        end
                    end
                end
                warning(s)
            end
            
            % Check lower levels ...
            props_child = {meta.PropertyList.Name};
            
            CheckSuperclasses(meta)
            
            % This function is called recursively ...
            function CheckSuperclasses(List)
                for ii=1:length(List.SuperclassList(:))
                    if ~isempty(List.SuperclassList(ii).SuperclassList)
                        CheckSuperclasses(List.SuperclassList(ii))
                    end
                    for jj=1:length(List.SuperclassList(ii).PropertyList(:))
                        prop_super = List.SuperclassList(ii).PropertyList(jj).Name;
                        if ~strcmp(prop_super, props_child)
                            obj_out.(prop_super) = obj.(prop_super);
                        end
                    end
                end
            end
        end
    end
end

