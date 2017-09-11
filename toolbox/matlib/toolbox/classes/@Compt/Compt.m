classdef Compt < handle
%Compt class representing a compartment where the reactions/network
% take place
%
% A Compt object is a generic representation of a biological  compartment
%  in cell, tissue or organ. It consists of a list of compartment properties
%  including the size, the volume, the biological name, its ID number, etc.
%
% Compt properties:
%  volume             - compartment volume
%  units              - volume units
%  size               - compartment size
%  name               - name of the compartment.
%  ID                 - the ID number
%  thepathway         - the pathway taking place in the compartment
%  spatialdimensions  - the spatial dimensions for the volume
%
% Compt methods:
%  Compt              - create a COMPT object
%  isempty            - return true if the COMPT object is empty
%  getVolume          - retrieve the property "volume"
%  getUnits           - retrieve the property "units"
%  getSize            - retrieve the property "size"
%  getName            - retrieve the property "name"
%  getID              - retrieve the property "ID"
%  setVolume          - set the property "volume"
%  setUnits           - set the property "units"
%  setSize            - set the property "size"
%  setName            - set the property "name"
%  setID              - set the property "ID"
%  clone              - copy a COMPT object
%
% See also Rxn,GlycanSpecies,Pathway,Enz.

% Author: Gang Liu
% CopyRight 2012 Neelamegham Lab.
    
    properties
        % SIZE size of the compartment
        %     SIZE property is a numeric double scalar
        %
        % See also COMPT
        size
    end
    
    properties
        % VOLUME volume of the compartment
        %     VOLUME property is a numeric double scalar
        %
        % See also COMPT
        volume
    end
    
    properties
        % NAME name of the compartment
        %     NAME property is a character array
        %
        % See also COMPT
        name
    end
    
    properties
        % UNITS volume units for the compartment
        %     UNITS property is a character array
        %
        % See also COMPT
        units
    end
    
    properties
        % spatialDimensions spatial dimensions used for the size
        %     spatialDimensions property is a numeric double scalar
        %
        % See also COMPT
        spatialDimensions
    end
    
    properties
        % ID  identification number for the compartment
        %     ID property is a character array
        %
        % See also COMPT
        id
    end
    
    properties
        % THEPATHWAY the molecular pathway which takes place in the compartment
        %    THEPATHWAY property is a reference to the PATHTWAY object
        %
        % See also COMPT
        thePathway
    end
    
    methods
        function obj = Compt(varargin)
        %COMPT create a Compt object
        %
        %  L = COMPT() It creates a default empty compartment object.
        %
        %  L = COMPT(Name) It creates a default compartment object 
        %   with the Name property.
        %
        %  L = COMPT(SBML_COMPARTMENT, SBMLLEVEL, SBMLVERSION). It
        %   converts a SBML_Compartment structure to a Compt object.
        %
        %  L = COMPT(Volume, Size,Name, ID). It create a compartment
        %   using the value of comaprtment volume, size, name and its
        %   ID.
        %
        %  See also COMPT.
            
            % validate the number of input arguments
%             if(~verLessThan('matlab','7.13'))
%                 narginchk(0,4);
%             else
                error(nargchk(0,4,nargin));
%             end    
            
             
            if (nargin == 0) %default constructor
                obj.size=1;
                obj.spatialDimensions =3;
            elseif(nargin==1)
                obj.name =varargin{1};
                obj.size=1;
                obj.spatialDimensions =3;
            elseif(nargin==3)
                sbmlCompt = varargin{1};
                level = varargin{2};
                version = varargin{3};
                
                if(~isSBML_Compartment(varargin{1},level,version))
                    errorReport(mfilename,'IncorrectInputType');
                end
                
                obj.size=sbmlCompt.size;
                if(~isempty(sbmlCompt.name))
                     obj.name= sbmlCompt.name;
                elseif(~isempty(sbmlCompt.id))
                    obj.name = sbmlCompt.id;
                else
                    obj.name = 'unknown';
                end
                obj.units=sbmlCompt.units;
                obj.spatialDimensions=sbmlCompt.spatialDimensions;
            elseif (nargin==4)
                typeCheck = isa( varargin{1},'double') ...
                    && isa( varargin{2},'char') ...
                    && isa( varargin{3},'char')...
                    && isa( varargin{4},'double') ;
                if(~typeCheck)
                    errorReport(mfilename,'IncorrectInputType');
                end
                obj.size                             = varargin{1};
                obj.name                            = varargin{2};
                obj.units                             =  varargin{3};
                obj.spatialDimensions   = varargin{4};
            end
        end
    end
    methods
        function res = getSize(obj)
            % GETSIZE  get the size of the compartment
            %
            % See also COMPT
            res = obj.size;
        end % end
        
        function res = getUnits(obj)
            % GETUNITS get the units for the compartment volume
            %
            %
            % See also COMPT
            res = obj.units;
        end % end
        
        
        function res = getName(obj)
        % GETNAME get the comaprtment name
        %
        % See also COMPT
            res = obj.name;
        end % end
        
        function res = getID(obj)
        % GETID get the identification number for the compartment
        %
        % See also COMPT
            res = obj.id;
        end % end
        
        function res = getSpatialDimensions(obj)
        % GETSPATIALDIMENSIONS get the spatial dimension number used for annoation of the compartment units/values.
        %
        % See also COMPT
            res = obj.spatialDimensions;
        end % end
        
        function res = getPathway(obj)
            % GETPATHWAY get the pathway reference in the compartment.
            %
            % See also COMPT
            res = obj.thePathway;
        end % end
        
        function setPathway(obj,pathwayObj)
            % SETPATHWAY set the pathway reference in the compartment.
            %
            % See also COMPT
            obj.thePathway = pathwayObj;
        end % end
        
        
        function setUnits(obj,units)
            % SETUNITS set the units for the compartment volume
            %
            % See also COMPT
            obj.units=units;
        end % end
        
        function setSize(obj,size)
            % SETSIZE set the compartment size
            %
            % See also COMPT
            obj.size = size;
        end % end
        
        function setName(obj,name)
            % SETNAME set the compartment name
            %
            % See also COMPT
            obj.name = name;
        end % end
        
        function setVolume(obj,volume)
            % SETVOLUME set the compartment volume
            %
            % See also COMPT
            obj.volume = volume;
        end % end
        
        function volume= getVolume(obj)
            % GETVOLUME get the compartment volume
            %
            % See also COMPT
            volume = obj.volume;
        end % end
        
        function setID(obj,id)
            % SETID set the compartment ID
            %
            % See also COMPT
            obj.id = id;
        end % end
        
        
        function setSpatialDimensions(obj,spatialDimensions)
            % setSpatialDimensions set the spatialDimensions for volume/unit
            %
            % See also COMPT
            obj.spatialDimensions = spatialDimensions;
        end % end
        
    end
    
    methods
        sbml_compt = compt2SBML(comptMat);
    end
    
    methods
        function isComptEmpty= isempty(comptObj)
            % ISEMPTY return true if the Compt object is empty
            %
            % See also COMPT
            isComptEmpty = isempty(comptObj.getSize) ...
                && isempty(comptObj.getName) ...
                && isempty(comptObj.getUnits)...
                && isempty(comptObj.getSpatialDimensions) ;
            return
        end
        
        %         function isValid = isValidCompt(compObj) end
        
    end
    
    methods
        function new = clone(obj)
            %CLONE copy a Compt object
            %  CLONE(Comptobj) copys a Compt object to a new object
            %
            %  See also COMPT
            
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
    end
    
    
end

