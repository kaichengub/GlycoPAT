classdef GlycanBond < handle
%GlycanBond class representing a glycosidic bond between two monosaccharide residues.
%
% A GlycanBond object is a generic representation of a glycosidic
%  bond. It consists of the glycosidic positions on both parent and 
%  children residues
%
% GlycanBond properties:
%  posParent        - glycosidic position on parent carbohydrate residue
%  posChild         - glycosidic position on children carbohydrate residue
%
% GlycanBond methods:
%  GlycanBond       - create a GLYCANBOND object.
%  getPosParent     - retrieve the glycosidic position on parent residue
%  getPosChild      - retrieve the glycosidic position on children residue
%  setPosParent     - set the glycosidic position on parent residue
%  setPosChild      - set the glycosidic position on children residue
%  bondMat2Java     - convert a MATLAB GlycanBond object to a Java Bond object
%  clone            - copy a GlycanBond object
%
% See also GlycanResidue,GlycanStruct,Rxn.

% Author: Gang Liu
% CopyRight 2012 Neelamegham Lab.
    
    
    properties%(SetAccess=private,GetAccess=private)
        %POSPARENT the glycosidic position on parent residue
        %   POSPARENT is a character array
        %
        % See also GLYCANBOND
        posParent
    end
    
    properties
        %POSCHILD the glycosidic position on child residue
        %   POSCHILD is a character
        %
        % See also GLYCANBOND
        posChild
    end
    
    methods
        % constructor
        function obj = GlycanBond(varargin)
        %GLYCANBOND create a GlycanBond object.
        %
        %  B = GLYCANBOND(BONDJAVA) converts a Java Bond
        %   object to a MATLAB GlycanBond object
        %
        %  B = GLYCANBOND(POSPARENT,POSCHILD) creates a
        %   GlycanBond object with linkage position POSPARENT on
        %   parent residue and position POSCHILD on child residue
        %
        %
        %  See also GLYCANBOND
            error(nargchk(0,2,nargin));
            if(nargin==1)
                bondJava = varargin{1};
                if(isa(bondJava,'org.eurocarbdb.application.glycanbuilder.Bond'))
                    obj.posParent = char(bondJava.getParentPositions);
                    obj.posChild = char(bondJava.getChildPosition);
                 else
                    error('MATLAB:GNAT:WrongInputType','Incorrect Input Type');
                end
            elseif (nargin==2)
                obj.posParent  =   varargin{1};
                obj.posChild   =   varargin{2};
                if ~( isa(obj.posParent,'char') && isa(obj.posChild,'char') )
                    error('MATLAB:GNAT:WrongInputType','Incorrect Input Type');
                end
            elseif(nargin==0)   
                obj.posParent  =  '?';
                obj.posChild   =   '?';
            end
        end
        
        % setter methods
        function name = disp(obj)
            %disp display the linkage position at parent residue
            %
            %
            %   See also GLYCANBOND
            name = strcat(obj.posChild,',');
            name = strcat(name,obj.getPosParent);
        end
        
        
        % setter methods
        function posParent = getPosParent(obj)
            %GETPOSPARENT get the linkage position at parent residue
            %
            %
            %   See also GLYCANBOND
            posParent = obj.posParent;
        end
        
        function posChild = getPosChild(obj)
            %GETPOSCHILD get the linkage position at child residue
            %
            %
            %   See also GLYCANBOND
            posChild = obj.posChild;
        end
        
        % getter methods
        function setPosParent(obj, posParent)
            %SETPOSPARENT set the linkage position at parent residue
            %
            %
            %   See also GLYCANBOND
            obj.posParent = posParent;
        end
        
        function setPosChild(obj, posChild)
            %SETPOSCHILD set the linkage position at child residue
            %
            %
            %   See also GLYCANBOND
            obj.posChild  = posChild ;
        end
    end
    
    methods
        function isObjempty =  isempty(obj)
            isObjempty = isempty(obj.getPosParent) && isempty(obj.getPosParent);
        end
    end
    
    methods
        objJava= bondMat2Java(obj)
    end
    
    methods
        function new = clone(obj)
            %CLONE copy a GlycanBond object
            %  CLONE(GLYCANBONDobj) copy a new GlycanBond object
            %
            %  See also GLYCANBOND
            
            % Instantiate new object of the same class.
            new = feval(class(obj));
            
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                 new.(p{i}) = obj.(p{i});         
            end
        end
    end
end

