classdef MassOptions < handle
%MassOptions class representing an option set for mass calculation
%
% A MassOptions object is a generic representation of options used to
%  calculate the mass of the oligosaccharide structure. It consists of
%  four properties: isoTope (average/mono), derivatization, redEndType, ionCloud, and
%  neutralExchange.
%
% MassOptions properties:
%  isoTope                     - isotopic mass
%  derivatization              - derivatization technique
%  redEndType                  - the residue type of reducing end
%  ionCloud                    - the ion used in mass spectrometry, e.g., Na+, K+,
%
% MassOptions methods:
%  MASSOPTIONS                 - create a MASSOPTIONS object.
%  getIsoTope                  - retrieve the "isoTope" property
%  getDerivatization           - retrieve the "derivatization" property
%  getRedEndType               - retrieve the "redEndType" property
%  getIonCloud                 - retrieve the "ioncloud" property
%  setIsoTope                  - set the "isoTope" property
%  setDerivatization           - set the "derivatization" property
%  setRedEndType               - set the "redEndType" property
%  setIonCloud                 - set the "ioncloud" property
%  massOptMat2Java             - convert a MATLAB MASSOPTIONS object to a Java MASSOPTIONS object
%  clone                       - copy a MASSOPTIONS object
%
% See also GlycanResidue,GlycanStruct,Rxn.

% Author: Gang Liu
% CopyRight 2012 Neelamegham Lab.
    
    properties
        % ISOTOPE isotopic mass, either average or monoisotopic molecular weight
        %      ISOTOPE property is a character array
        %
        % See also MassOptions
        isoTope;
    end
    
    properties
        % DERIVATIZATION derivatization technique used  in mass spectrometry,
        %    e.g., methylation, demethylation, acetylation, deacetylation
        %      DERIVATIZATION property is a character array
        %
        % See also MassOptions
        derivatization;
    end
    
    properties
        % REDENDTYPE  the residue type of reducing end
        %     REDENDTYPE property is an REDENDTYPE object
        %
        % See also MassOptions
        redEndType;
    end
    
    properties
        % ionCloud  the ions cloud used in mass spectrometry
        %     ionCloud property is a character array
        %
        % See also MassOptions
        ionCloud;
    end
    
    methods  % contructor
        function obj= MassOptions(varargin)
            % MassOptions create a MassOptions object
            %
            %   MOPTS = MassOptions(MASSOPTIONSJAVA) converts a Java MassOptions object to a MATLAB MassOptions object
            %
            %   MOPTS = MassOptions(isotope, derivatization) creates a MASSOPTIONS object with the iostope (char array),
            %   derivatization (char array) two input arguments
            %
            %   MOPTS = MassOptions(isotope, derivatization,ionCloud) creates a MASSOPTIONS object with the iostope (char array),
            %   derivatization (char array) and ionCloud  (char array) three input arguments
            %
            %   MOPTS = MassOptions(isotope, derivatization, ionCloud,redEndType) creates a MASSOPTIONS object with the iostope (char array),
            %   derivatization (char array), ionCloud  (character) and redEndType (residueType) four input arguments
            %
            % See also MassOptions
            
            % validate the number of input arguments
%             if(~verLessThan('matlab','7.13'))
%                 narginchk(0,4);
%             else
                error(nargchk(0,4,nargin));
%             end            
            
            if(nargin==0)
                obj.isoTope = 'MONO';
                obj.derivatization = 'perMe';
                obj.redEndType = ResidueType;
                obj.ionCloud = 'Na';
            elseif(nargin==1)
                massOptionJava = varargin{1};
                obj.isoTope = char(massOptionJava.getIsotope);
                obj.derivatization =char(massOptionJava.getDerivatization);
                obj.redEndType = ResidueType(massOptionJava.getReducingEndType);
            elseif (nargin==2)
                obj.isoTope = varargin{1};
                obj.derivatization =varargin{2} ;
            elseif (nargin==3)
                obj.isoTope = varargin{1};
                obj.derivatization =varargin{2} ;
                obj.ionCloud = varargin{3};
            elseif (nargin==4)
                obj.isoTope = varargin{1};
                obj.derivatization =varargin{2} ;
                obj.ionCloud = varargin{3};
                obj.redEndType = varargin{4};
            end
        end
    end
    
    methods
        function isoTope = getIsoTope(obj)
            % GETISOTOPE retrieve the "isoTope" property
            %
            % See also MassOptions
            isoTope = obj.isoTope;
        end
    end
    
    methods
        function ionCloud = getIonCloud(obj)
            % getIonCloud retrieve the "ionCloud" property
            %
            % See also MassOptions
            ionCloud = obj.ionCloud;
        end
    end
    
    methods
        function derivatization = getDerivatization(obj)
            % getDerivatization retrieve the "derivatization" property
            %
            % See also MassOptions
            derivatization = obj.derivatization;
        end
    end
    
    methods
        function redEndType = getRedEndType(obj)
            % getRedEndType retrieve the "redEndType" property
            %
            % See also MassOptions
            redEndType = obj.redEndType;
        end
    end
    
    methods
        function  setIsoTope(obj,isoTope)
            % setIsoTope set the "isoTope" property
            %
            % See also MassOptions
            obj.isoTope =  isoTope;
        end
    end
    
    methods
        function  setIonCloud(obj,ionCloud)
            % setIonCloud set the "ionCloud" property
            %
            % See also MassOptions
            obj.ionCloud =  ionCloud;
        end
    end
    
    methods
        function setDerivatization(obj,derivatization)
            % setDerivatization set the "derivatization" property
            %
            % See also MassOptions
            obj.derivatization = derivatization;
        end
    end
    
    methods
        function  setRedEndType(obj,redEndType)
            % setRedEndType set the "redEndType" property
            %
            % See also MassOptions
            obj.redEndType =  redEndType;
        end
    end
    
    methods
        function new = clone(obj)
            %CLONE copy a MassOptions object
            %
            %  CLONE(MASSOPTIONSobj) creates a new MassOptions object
            %
            %  See also MASSOPTIONS
            
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

