classdef GlycanNetModel < handle
%GlycanNetModel construct an object of a glycosylation reaction network model
%
% A GlycanNetModel object is a generic presentation of a mathematical
%  model of glycosylation reaction networks in Golgi comparment. It
%  consists of several properties including compartments,
%  glycan pathway, simulated data and its name.
%
% GlycanNetModel properties:
%  compartment           - the compartment(s) listed in the model
%  glycanpathway        - the glycosylation network(s) listed in the model
%  simuData                  - the data simulated using the model
%  name                         - the name of the model
%
% GlycanNetModel methods:
%  GlycanNetModel      - create a GlycanNetModel object
%  setCompartment      - set the property "compartment "
%  setglycanpathway    - set the property "glycanpathway"
%  setsimuData              - set the property "simudata"
%  setname                    - set the property "name"
%  getcompartment     - get the property "compartment "
%  getglycanpathway   - get the property "glycanpathway"
%  getsimuData             - get the property "simudata"
%  getname                   - get the property "name"
%  clone                        - copy a GlycanNetModel object
%
% See also Pathway, Compt,GlycanSpecies.

%   Author: Gang Liu
%   Date Lastly Updated: 3/4/13

    properties
        % COMPARTMENT the compartment(s) listed in the model
        %  COMPARTMENT property is an array of Compt object
        %
        % See also GLYCANNETMODEL
        compartment
    end
    
    properties
        % GLYCANPATHWAY the glycosylation reaction network(s)
        %   GLYCANPATHWAY property is an array of Pathway objects
        %
        % See also GLYCANNETMODEL
        glycanpathway
    end
    
    properties
        % SIMUDATA the simulation data using the model
        %    SIMUDATA property  is a Matlab struct with three fields, "Species",
        %    [n*1, cell],  "time" [m*1, double matrix ], and "data" [m*n
        %    double matrix].
        %
        % See also GLYCANNETMODEL
        simuData
    end
    
    properties
        % NAME the name of the model 
        %    NAME property is a character array.
        %
        % See also GLYCANNETMODEL
        name
    end
    
    properties
        % glycanNet_sbmlmodel MATLAB SBML structure for the glycosylation reaction network
        %
        % See also GLYCANNETMODEL
        glycanNet_sbmlmodel
    end
    
    %constructor
    methods
        function obj = GlycanNetModel(varargin)
        %GLYCANNETMODEL create a GlycanNetModel object
        %
        % GModel =  GLYCANNETMODEL(SBML_Model) converts a SBML_MODLE
        %  structure to a GlycanNetModel object. Glycan structure are annoated in SBML_Model
        %  annoation section using glycoct_xml format.
        %
        % GModel =  GLYCANNETMODEL(SBML_Model,GLYCANFORMAT) specify the
        %  glycan structure format "GLYCANFORMAT"
        %
        % GModel = GLYCANNETMODEL(THECOMPT,THEPATHWAY,NAME) constructs a
        %  GlycanNetModel object using three inputs: THECOMPT, THEPATHWAY
        %  and the NAME.
        %
        %
        % See also GLYCANNETMODEL

         % validate the number of input arguments
            
            error(nargchk(0,3,nargin));            
                        
            if(nargin>0)
                if(nargin==1) || (nargin==2) % SBML_Model structure
                    if (~isSBML_Model(varargin{1}))&&(~isa(varargin{1},'char'))
                        errorReport(mfilename,'IncorrectInputType');
                    end
                    
                    if(isa(varargin{1},'char'));
                        xmlfilename = which(varargin{1});
                        if(isempty(xmlfilename))
                            errorReport(mfilename,'FileNotFound');
                        end
                        sbml_model=TranslateSBML(xmlfilename);
                    else
                        sbml_model = varargin{1};
                    end
                    
                    % read inputs
                    obj.glycanNet_sbmlmodel = sbml_model;
                    
                    glycanFormat = 'glycoct_xml';
                    if(nargin==2)
                        glycanFormat = varargin{2};
                    end
                    
                    obj.name =   sbml_model.name;
                    [level,version] = GetLevelVersion(sbml_model);
                    %
                    %                     numCompts = length(sbml_model.compartment);
                    %                     obj.compartment = cell(numCompts,1);
                    %                     compts = sbml_model.compartment;
                    %                     for i=1:numCompts;
                    %                         sbml_compt = compts(1,i);
                    %                         obj.compartment{i,1} = Compt(sbml_compt,level,version);
                    %                     end
                    
                    obj.glycanpathway = Pathway(sbml_model,level,version,glycanFormat);
                    obj.compartment   = obj.glycanpathway.getCompartment;
                    
                elseif(nargin==3)
                    obj.compartment      =  varargin{1};   %  compartment;
                    obj.glycanpathway    = varargin{2};  %  glyPathway;
                    obj.name                    =  varargin{3};   % name;
                    
                    for i = 1: length(obj.glycanpathway.theSpecies)
                         obj.glycanpathway.theSpecies.get(i).compartment=obj.compartment;                        
                    end    
                    
                    obj.glycanpathway.compartment.add(obj.compartment);
                        
                end
            end
        end
    end
    
    % getter
    methods
        function compt = getCompartment(obj)
            % GETCOMPARTMENT get the compartment(s) in the model
            %
            %
            % See also GLYCANNETMODEL
            compt=obj.compartment;
        end
        
        function glycanPath = getGlycanPathway(obj)
            % GETGLYCANPATHWAY get the glycosylation network(s)
            %    in the model
            %
            %
            % See also GLYCANNETMODEL
            glycanPath = obj.glycanpathway;
        end
        
        function simuData=getSimuData(obj)
            % GETSIMUDATA get the simulation data
            %
            %
            % See also GLYCANNETMODEL
            simuData = obj.simuData;
        end
        
        function name = getName(obj)
            %GETNAME get the name of the model
            %
            %
            % See also GLYCANNETMODEL
            name = obj.name;
        end
    end
    
    % setter
    methods
        function setCompartment(obj,compt)
            % SETCOMPARTMENT set the compartment(s) 
            %
            %
            % See also GLYCANNETMODEL
            obj.compartment = compt;
        end
        
        function setGlycanPathway(obj,glycanPathway)
            %SETGLYCANPATHWAY set the glycosylation pathway(s) 
            %
            %
            % See also GLYCANNETMODEL
            obj.glycanpathway = glycanPathway;
        end
        
        function   setSimuData(obj,simuData)
            %SETSIMUDATA set the simulation data
            %
            %
            % See also GLYCANNETMODEL
            obj.simuData = simuData;
        end
        
        function  setName(obj,name)
            %SETNAME set the name of the model
            %
            %
            % See also GLYCANNETMODEL
            obj.name = name;
        end
    end
    
    methods
        modelMerge(modelToAdd);
    end
    
    methods
        javaPathway=toJavaPathway(obj)
    end
    
    methods
        smblstruct =toSBMLStruct(obj);
    end
    
    methods
        function new = clone(obj)
            %CLONE copy a GlycanNetModel object
            %  clone(GLYCANNETMODELobj) creates a new GlycanNetModel object
            %
            %  See also GLYCANNETMODEL
            
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