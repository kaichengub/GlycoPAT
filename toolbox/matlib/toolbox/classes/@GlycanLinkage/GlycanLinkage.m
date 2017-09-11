classdef GlycanLinkage <handle
%GlycanLinkage class representing a linkage between two monosaccharide residues.
%
% A GlycanLinkage object is a generic representation of glycan linkage 
%  information. It consists of two glycan monosaccharide residues 
%  (parent and child), and the glycosidic bonds.
%
% GlycanLinkage properties:
%  parent                - parent carbohydrate residue
%  child                  - child carbohydrate residue
%  bonds                - linkage position in parent and child residues
%  name                 - linkage name
%
% GlycanLinkage methods:
%  GlycanLinkage        - create a GlycanLinkage object
%  getParent            - retrieve the parent residue
%  getChild             - retrieve the child residue
%  getBonds             - retrieve the glycosidic bonds
%  setParent            - set the parent residue
%  setChild             - set the child residue
%  setBonds             - set the glycosidic bonds
%  linkMat2Java         - convert a GlycanLinkage object to a Java Linkage object
%  clone                - copy a GlycanLinkage object
%
%  See also GlycanResidue, GlycanStruct, Rxn.

%   Author: Gang Liu
%   CopyRight 2012 Neelamegham Lab.
    
    properties(SetAccess=private)
        % PARENT  parent carbohydrate residue
        %      PARENT property is a GLYCANRESIDUE object
        %
        % See also GLYCANLINKAGE
        parent
    end
    
    properties(SetAccess=private)
        % CHILD  child carbohydrate residue
        %      CHILD property is a GLYCANRESIDUE object
        %
        % See also GLYCANLINKAGE
        child
    end
    
    properties(SetAccess=private)
        % BONDS glycosidic bonds between the parent and children residue
        %  BONDS property is an array of GLYCANBOND objects
        %
        % See also GLYCANLINKAGE
        bonds
    end
    
    properties(SetAccess=private)
        % NAME name of the glycosidic linkage between two residues
        %  NAME property is a character array
        %
        % See also GLYCANLINAKGE
        name;
    end
    
    methods    % constructor
        function obj = GlycanLinkage(varargin)
        %GLYCANLINKAGE create a GlycanLinkage object.
        %
        %  L = GLYCANLINKAGE(GLYCANLIINKAGEJAVA) converts a java Linkage object to a MATLAB
        %   GlycanLinkage object
        %
        %  L = GLYCANLINKAGE(PARENTRESIDUE,CHILDRESIDUE,GLYCOSIDICBOND) creates a
        %   GlycanLinkage object with glycosidic bond GLYCOSIDICBOND between parent PARENTRESIDUE
        %   and child residue CHILDRESIDUE
        %
        %  L = GLYCANLINKAGE(PARENTRESIDUE,CHILDRESIDUE,GLYCOSIDICBOND,LINKAGENAME) defines the 
        %   name of a GlycanLinkage object as LINKAGENAME.
        %
        %  L = GLYCANLINKAGE(PARENTRESIDUE, CHILDRESIDUE,POSPARENT,POSCHILD,LINKAGENAME) defines a glycosidic
        %   linkage linking from parent residue at POSPARENT to child residue at POSCHILD.
        %
        %  See also GLYCANLINKAGE


            error(nargchk(0,5,nargin));
            if (nargin==1)  % Java Library input
                if(~isa(varargin{1},'org.eurocarbdb.application.glycanbuilder.Linkage'))
                    error('MATLAB:GNAT:IncorrectInputType','Incorrect Input Type');
                end
                import org.eurocarbdb.application.glycanbuilder.Linkage;
                import org.eurocarbdb.application.glycanbuilder.Bond;
                
                linkageResJava       = varargin{1};
                obj.parent                  = GlycanResidue(linkageResJava.getParentResidue);
                obj.child                     = GlycanResidue(linkageResJava.getChildResidue);
                bondsLinkResJava    = linkageResJava.getBonds;
                obj.bonds =[];
                for i=1: bondsLinkResJava.size
                    bondJava            = bondsLinkResJava.elementAt(i-1);
                    obj.bonds           = [obj.bonds;GlycanBond(bondJava)];
                end
            elseif(nargin==3)
                obj.parent                 =  varargin{1};
                obj.child                    =  varargin{2};
                obj.bonds                 =  varargin{3};  % can be vector of GlyBond
                %  obj.name                  =  varargin{4};
            elseif(nargin==4)
                obj.parent                 =  varargin{1};
                obj.child                    =  varargin{2};
                obj.bonds                 =  varargin{3};  % can be vector of GlyBond
                obj.name                  =  varargin{4};
            elseif(nargin==5)  %single bond
                obj.parent                =  varargin{1};
                obj.child                   =  varargin{2};
                obj.bonds                =  Glycanbond(varargin{3},varargin{4});
                obj.name                 =  varargin{5};
            end
        end
    end   % end constructor
    
    methods
        
        % GET METHODS
        function parent = getParent(obj)
        %GETPARENT get parent resiude defined in the linkage
        %
        % See also GLYCANLINKAGE
            parent = obj.parent;
        end
        
        function child = getChild(obj)
        %GETCHILD get child resiude defined in the linkage
        %
        % See also GLYCANLINKAGE
            child = obj.child;
        end
        
        function name = getName(obj)
            %GETNAME get the name of the linkage
            %
            % See also GLYCANLINKAGE
            name = obj.name;
        end
        
        function bonds = getBonds(obj)
            %GETBONDS get the bonds defined in the linakge
            %
            % See also GLYCANLINKAGE
            bonds = obj.bonds;
        end
        
        % SET METHODS
        function  setParent(obj,parent)
            %SETPARENT set parent resiude in the linkage
            %
            % See also GLYCANLINKAGE
            obj.parent =  parent;
        end
        
        function setName(obj,name)
            %SETNAME set the name of the linkage
            %
            % See also GLYCANLINKAGE
            obj.name = name;
        end
        
        function setChild(obj,child)
            %SETCHILD set the child of the linkage
            %
            % See also GLYCANLINKAGE
            obj.child = child;
        end
        
        function setBonds(obj,bonds)
            %SETBONDS set the bonds of the linkage
            %
            % See also GLYCANLINKAGE
            obj.bonds  = bonds;
        end
    end
    
    methods
        objJava = linkMat2Java(obj)
    end
    
    methods
        function new = clone(obj)
            %CLONE copy a GlycanLinkage object
            % CLONE(GLYCANLINKAGEobj) creates a new GlycanLinkage object
            %
            % See also GLYCANLINKAGE
            
            % Instantiate new object of the same class.
            new = feval(class(obj));
            
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                new.(p{i}) = obj.(p{i}); % not deep copying
            end
        end
    end
    
end

