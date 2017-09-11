classdef GlycanSpecies <Species
%GlycanSpecies class representing a glycan species in the reaction network.
%
% A GlycanSpecies object is a generic representation of carbohydrate
%  molecules in the glycosylation network. It consists of an array of 
%  species property including molecular concentration, mass amount, 
%  compartment location. And it is is considered as a node (species) 
%  in the graph (reaction networks).
%
% GlycanSpecies properties:
%  glycanStruct             - the structure of the species
%
% See also GlycanStruct, GlycanResidue.

% Author: Gang Liu
% Date Last Updated: 1/28/13

% Rev: add the support to transport events
    properties
        % GLYCANSTRUCT the structure of the glycan species
        %    GLYCANSTRUCT property is a GLYCANSTRUCT object
        %
        % See also GlycanSpecies
        glycanStruct; % glycan structure
    end
    
    properties
        % glycanTypeSpec the substrate group enzyme can act on 
        %    glycanTypeSpec property is a string character describing the
        %    type of glycan structure (e.g.N-linked glycan, O-linked
        %    glycan)
        %    
        %  See also GlycanSpecies
        glycanTypeSpec
    end    
    
    methods  %constructor
        
        function obj = GlycanSpecies(varargin)
            %GLYCANSPECIES create a GlycanSpecies object
            %
            %   GSpecies = GLYCANSPECIES() creates a GlycanSpecies object with the default value for each fields including empty GLYCANSTRUCT,
            %          false MARK, empty name,empty LISTOFREACRXNS and LISTOFPRODRXNS
            %
            %   GSpecies = GLYCANSPECIES(GLYCANNAMESTRING) takes the String as an input and creates a GlycanSpecies object named as GLYCANNAMESTRING and other fields in the object
            %          use the default value.
            %
            %   GSpecies = GLYCANSPECIES(GLYCANSTRUCTOBJ) takes the GlycanStruct object as an input and creates a GlycanSpecies object using GLYCANSTRUCTOBJ's structure
            %           and name
            %
            %   GSpecies = GLYCANSPECIES(GLYCANSTRUCTOBJ,NAMESTRING) creates a GlycanSpecies object using GLYCANSTRUCTOBJ as value of GLYCANSTRUCT field and NAMESTRING
            %           as the value of NAME
            %
            %   GSpecies = GLYCANSPECIES(GLYCANSTRUCTOBJ,COMPTOBJ) creates a GlycanSpecies object using GLYCANSTRUCTOBJ as the value of GLYCANSTRUCT field and COMPT object COMPTOBJ
            %           as the value of compartment
            %
            %   GSpecies = GLYCANSPECIES(GLYCANSTRUCTOBJ,NAMESTRING,INITCONC) creates a GlycanSpecies object using  GLYCANSTRUCTOBJ  as value of GLYCANSTRUCT field and NAMESTRING
            %           as the value of NAME, and INITCONC as the value of INITCONC.
            %
            %   GSpecies = GLYCANSPECIES(SBML_SPECIES,LEVEL,VERSION)   creates a  GLYCANSPECIES object using a SBML_SPECIES struct, the level and the version as the inputs.
            %
            %   GSpecies = GLYCANSPECIES(GLYCANSTRUCTOBJ,NAMESTRING,INITCONC,UNITS)   creates a  GLYCANSPECIES object using GLYCANSTRUCTOBJ as value of GlycanStruct field and NAMESTRING
            %           as the value of NAME, INITCONC as the value of INITCONC, UNITS as the value of UNITS
            %
            %   GSpecies = GLYCANSPECIES(GLYCANSTRUCTOBJ,NAMESTRING,INITCONC,UNITS,COMPARTMENT) creates a GlycanSpecies object using GLYCANSTRUCTOBJ as value of GlycanStruct field and NAMESTRING
            %           as the value of NAME, INITCONC as the value of INITCONC, UNITS as the value of UNITS, COMPARTMENT as the value of COMPARTMENT.
            %
            % See also GLYCANSPECIES
             % validate the number of input arguments
            
            error(nargchk(0,5,nargin));
                        
            if(nargin==0)  % empty glycan species
                obj.glycanStruct=GlycanStruct;
                obj.mark = false;
                obj.name ='';
                obj.listOfReacRxns=CellArrayList();
                obj.listOfProdRxns=CellArrayList();
                
            elseif(nargin==1)  % input can be just string of glycan name or SBML_species or  glycan
                isCharName = ischar(varargin{1});
                isGlycan = isa(varargin{1},'GlycanStruct');
                obj. listOfReacRxns=CellArrayList();
                obj. listOfProdRxns=CellArrayList();
                
                if(isCharName)  % if input is species name in string format
                    obj.name = varargin{1};
                    obj.mark = false;
                elseif(isGlycan)
                    obj.glycanStruct= varargin{1};
                    obj.name = obj.glycanStruct.getName;
                else
                    errorReport(mfilename,'IncorrectInputType');
                end
                
            elseif(nargin==2)
                
                if(~isa(varargin{1},'GlycanStruct'));
                    errorReport(mfilename,'IncorrectInputType');
                end;
                
                if(~isa(varargin{2},'Compt') && ~isa(varargin{2},'char') );
                    errorReport(mfilename,'IncorrectInputType');
                end;
                
                obj.glycanStruct = varargin{1};
                if(isa(varargin{2},'char') )
                    obj.name = varargin{2};
                else
                    obj.compartment= varargin{2};
                    obj.name = obj.glycanStruct.getName;
                end
                obj.mark = false;
                obj. listOfReacRxns=CellArrayList();
                obj. listOfProdRxns=CellArrayList();
                
            elseif(nargin==3)
                
                sbmlcase = isa(varargin{1},'struct') &&  isa(varargin{2},'double') && isa(varargin{3},'double');
                nonsbmlcase1 = isa(varargin{1},'GlycanStruct') &&  isa(varargin{2},'char') && isa(varargin{3},'double');
                nonsbmlcase2 = isa(varargin{1},'GlycanStruct') &&  isa(varargin{2},'Compt') && isa(varargin{3},'char');
                
                if(nonsbmlcase1)
                    obj.glycanStruct = varargin{1};
                    obj.name            = varargin{2};
                    obj.initConc        = varargin{3};
                    obj.mark              = false;
                    obj. listOfReacRxns=CellArrayList();
                    obj. listOfProdRxns=CellArrayList();
                elseif(nonsbmlcase2)
                     obj.glycanStruct = varargin{1};
                    obj.compartment            = varargin{2};
                    obj.name        = varargin{3};
                    obj.mark              = false;
                    obj.listOfReacRxns=CellArrayList();
                    obj.listOfProdRxns=CellArrayList();
                elseif(sbmlcase|| isSBML_Species(varargin{1},varargin{2},varargin{3}))   % convert SBML species to GlycanSpecies class  in matlab
                    sbmlSpecies = varargin{1};
                    obj.mark = false;
                    obj.name = Species_getName(sbmlSpecies);
                    obj.id = Species_getId(sbmlSpecies);
                    if(isfield(sbmlSpecies, 'isSetInitialAmount'))
                        if(Species_isSetInitialAmount(sbmlSpecies))
                            obj.initAmount =  Species_getInitialAmount(sbmlSpecies);
                        end
                    end
                    
                    if(isfield(sbmlSpecies, 'isSetInitialConcentration'))
                        if(Species_isSetInitialConcentration(sbmlSpecies))
                            obj.initConc =  Species_getInitialConcentration(sbmlSpecies);
                        end
                    end
                    
                    if(isfield(sbmlSpecies, 'units'))
                        if(Species_isSetUnits(sbmlSpecies))
                            obj.units =  Species_getUnits(sbmlSpecies);
                        end
                    end
                    
                    if(isfield(sbmlSpecies, 'spatialSizeUnits'))
                        if(Species_isSetSpatialSizeUnits(sbmlSpecies))
                            obj.units =  Species_getSpatialSizeUnits(sbmlSpecies);
                        end
                    end
                    
                    if(isfield(sbmlSpecies, 'isSetSubstanceUnits'))
                        if(Species_isSetSubstanceUnits(sbmlSpecies))
                            obj.units =  Species_getSubstanceUnits(sbmlSpecies);
                        end
                    end
                    
                    % note here: so far test code use notes to store
                    % glycan structure should be in annotation section
                    
                    glycanStructString = annotation2GlycanStr(sbmlSpecies.annotation);
                    obj.glycanStruct = GlycanStruct(strtrim(glycanStructString),'glycoct_xml');
                    
                    obj. listOfReacRxns=CellArrayList();
                    obj. listOfProdRxns=CellArrayList();
                    
                else
                    errorReport(myFilName,'Too many inputs');
                end
                
            elseif(nargin==4)
                obj.glycanStruct = varargin{1};
                obj.name = varargin{2};
                obj.initConc = varargin{3};
                obj.units = varargin{4};
                obj.mark = false;
                obj. listOfReacRxns=CellArrayList();
                obj. listOfProdRxns=CellArrayList();
                
                
            elseif(nargin==5)
                obj.glycanStruct = varargin{1};
                obj.name = varargin{2};
                obj.initConc = varargin{3};
                obj.units = varargin{4};
                obj.compartment = varargin{5};
                obj.mark = false;
                obj. listOfReacRxns=CellArrayList();
                obj. listOfProdRxns=CellArrayList();
            end
            
            function glycanStructString = notes2GlycanStr(noteStr)
                try
                    glycanStructString=strrep(noteStr,'<notes>','');
                    glycanStructString=strrep(glycanStructString,'</notes>','');
                    glycanStructString=strrep(glycanStructString,'<body xmlns="http://www.w3.org/1999/xhtml">', '<?xml version="1.0" encoding="UTF-8"?>');
                    glycanStructString=strrep(glycanStructString,'</body>','');
                catch err
                    disp(['error' err]);
                end
            end
            
            function glycanStructString = annotation2GlycanStr(annotationStr)
                try
                    glycanStructString=strrep(annotationStr,'<annotation>','');
                    glycanStructString=strrep(glycanStructString,'</annotation>','');
                    glycanStructString=strrep(glycanStructString,'<glycoct xmlns="http://www.eurocarbdb.org/recommendations/encoding">', '<?xml version="1.0" encoding="UTF-8"?>');
                    glycanStructString=strrep(glycanStructString,'</glycoct>','');
                catch err
                    disp(['error' err]);
                end
            end
        end
    end
        
    methods  % getter and setter
        function glycanStruct = getGlycanStruct(obj)
            % GETGLYCANSTRUCT get the "glycanStruct" property
            %
            %
            %  See also GLYCANSPECIES
            glycanStruct = obj.glycanStruct;
        end
        
        function setGlycanStruct(obj,glycanStruct)
            % SETGLYCANSTRUCT set the "glycanStruct" property
            %
            %
            %  See also GLYCANSPECIES
            obj.glycanStruct = glycanStruct;
        end
    end      
    
end
