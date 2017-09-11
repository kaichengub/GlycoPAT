classdef Pathway  < handle
    %Pathway class representing a glycosylation reaction network
    %
    % A Pathway object is a generic representation of a glycosylation
    %  reaction network. It consists of a number of species, reactions and
    %  enzymes involved.
    %
    % Pathway properties:
    %  theRxns             - a list of the reactions in the network
    %  theSpecies          - a list of the species in the network
    %  theEnzs             - a list of enzymes in the network
    %  initGlycans         - initial glycan structures
    %  finalGlycans        - final glycan structures
    %  compartment         - the compartment where the reactions take place
    %  name                - the name of the network
    %
    % Pathway methods:
    %  Pathway             - create a Pathway object    
    %  getReactions        - retrieve the "theRxns" property
    %  getSpecies          - retrieve the "theSpecies" property
    %  getEnzymes          - retrieve the "theEnzs" property
    %  getInitGlycans      - retrieve the "initGlycans" property
    %  getFinalGlycans     - retrieve the "finalGlycans" property
    %  getCompartment      - retrieve the "compartment" property
    %  getGlycanStruct     - get the glycan structure of the ith species in the network
    %  getName             - retrieve the "name" property    
    %  setReactions        - set the "theRxns" property
    %  setSpecies          - set the "theSpecies" property
    %  setEnzymes          - set the "theEnzs" property
    %  setInitGlycans      - set the "initGlycans" property
    %  setFinalGlycans     - set the "finalGlycans" property
    %  setCompartment      - set the "compartment" property
    %  setName             - set the "name" property
    %  isempty             - return true if no reactions is in the network
    %  clearSpeciesMark    - reset all the species' marks as false
    %  clearRxnsMark       - reset all the reactions' mark as false
    %  removeRxn           - delete the reaction from the network
    %  removeSpecies       - remove species from the network
    %  addGlycans          - add the glycans to the reaction network
    %  addGlycan           - add a glycan to the reaction network
    %  findSpeciesByStruct - find the species by the given structure
    %  findSpeciesByName   - find the species by the given name
    %  findComptByName     - find the compartment by the given name
    %  setSpeciesIsolated  - set the species "isolated"
    %  clone               - copy a PATHWAY object
    %
    % See also Rxn,GlycanSpecies,Compt.
    
    % Author: Gang Liu
    % Date Last updated: 8/2013
    
    properties (Constant)
        VISIT_COLOR_WHITE = 1;
        VISIT_COLOR_GREY = 2;
        VISIT_COLOR_BLACK = 3;
    end
    
    properties
        %THERXNS the reactions in the network.
        %  THERXNS is an array of RXN objects.
        %
        % See also Pathway.
        theRxns
        % list of edges in graph structures
        %In graph theory, they are called list of edges in graph structure
    end
    
    properties
        %THESPECIES the species in the network.
        %  THESPECIES  is an array of GLYCANSPECIES objects
        %
        % See also Pathway.
        theSpecies;
        % In graph theory, they are called list of verticies in graph structure
    end
    
    properties
        %INITGLYCANS the initial structures in the network.
        %  In graph theory, they are called the roots of the graph.
        %  INITGLYCANS property is an array of GLYCANSPECIES objects.
        %
        % See also Pathway.
        initGlycans
    end
    
    properties
        %FINALGLYCANS the terminal structures in the network.
        %  In graph theory, they are called the endings of the graph.
        %  FINALGLYCANS property is an array of GLYCANSPECIES objects.
        %
        % See also Pathway.
        finalGlycans % ending of the graph. biological insights what's the end product
    end
    
    properties
        %THEENZS the enzymes involved in the network
        %     THEENZS is an array of Enzs objects.
        %
        % See also Pathway.
        theEnzs
    end
    
    properties
        %COMPARTMENT the cellular location where the reactions take place
        %    COMPARTMENT is a Compt object
        %
        % See also Pathway.
        compartment;
    end
    
    properties
        %NAME the name of the network
        %    NAME property is a character array.
        %
        % See also Pathway.
        name;
    end
    
    methods (Static)
        function pathobj=loadmat(matfilename)
            pathstruct=load(matfilename);
            p = fieldnames(pathstruct);
            if(length(p)~=1)
                 error('MATLAB:GNAT:WRONGINPUT','wrong variable stored');
            end
            pathobj = pathstruct.(p{1});
            if(isa(pathobj,'Pathway'))
                pathobj.resetjava;
            else
                error('MATLAB:GNAT:WRONGINPUT','wrong variable stored'); 
            end
        end
    end
    
    methods
        function resetjava(obj)
             for i = 1:obj.theSpecies.length
                thejthspecies = obj.theSpecies.get(i);
                thejthspecies.glycanStruct.resetjava; 
            end
        end
    end
    
    methods
        
        function isemp = isempty(obj)
            %isempty return true if the reaction network contains no reaction
            %  isempty return type is logical
            %
            %  See also Pathway.
            
            isemp = (obj.theRxns.length==0);
        end
        
        function obj = Pathway(varargin)
            %Pathway create a Pathway object.
            %
            %  GP = Pathway creates an empty Pathway object
            %
            %  GP = Pathway(SBML_MODEL,LEVEL,VERSION) converts a SBML_model structure to
            %   a Pathway object and glycan structure format uses GlycoCT format
            %
            %  GP = Pathway(SBML_MODEL,LEVEL,VERSION,GLYCANFORMAT)
            %   specify the structure format of glycans as GLYCANFORMAT
            %   string inputs.
            %
            %  See also Rxn,GlycanSpecies.
            
            % input number check
            % validate the number of input arguments
            %             if(~verLessThan('matlab','7.13'))
            %                 narginchk(0,4);
            %             else
            error(nargchk(0,4,nargin));
            %             end
            
            if (nargin == 0)
                obj.theRxns = CellArrayList();
                obj.theSpecies = CellArrayList();
                obj.theEnzs = CellArrayList();
                obj.compartment = CellArrayList();
                obj.name = '';
                return
            elseif ((nargin ==3)||(nargin==4))  %take SBML input
                
                % check arrays of sbml_reaction
                if(~isSBML_Model(varargin{1}))
                    errorReport(mfilename,'IncorrectInputType');
                end
                
                sbmlModel = varargin{1};
                level = varargin{2};
                version = varargin{3};
                
                glycanformat = 'glycoct_xml';
                if(nargin==4)
                    glycanformat = varargin{4};
                end
                
                obj.theRxns = CellArrayList();
                obj.theSpecies = CellArrayList();
                obj.compartment = CellArrayList();
                
                % add compartments to pathway  1st step
                obj.addCompts(sbmlModel.compartment,level,version);
                
                % add array of species in sbmlspecies format 2nd step
                obj.addGlycans(sbmlModel.species,level,version,glycanformat);
                
                %fprintf(1,'number of species is : %i \n',numSpeices);
                
                % add reactions to pathway %3rd step
                obj.addRxns(sbmlModel.reaction);
                
                %fprintf(1,'number of reactions is: %i\n',numRxns);
                
                % add enzyme type
                % currently empty
            end
        end % end constructor
    end
    
    methods
        function isGlycan= find(obj,species)
            % find check if the species exist in the species list.
            %
            %  isGlycan =  find(species) check if the species exisits
            %    in the list
            %
            %  See also Rxn,GlycanSpecies
            isGlycan=false;
            for i = 1 : length(obj.theSpecies)
                if(obj.theSpecies.get(i)==species)
                    isGlycan=true;
                    return
                end
            end
        end
        
        function glycanIndex = locspecies(obj,species)
            % locspecies return location of the species  in the species list.
            %
            %  isGlycan =  locspecies(species) check if the species exisits
            %    in the list
            %
            %  See also Rxn,GlycanSpecies
            glycanIndex=[];
            for i = 1 : length(obj.theSpecies)
                if(obj.theSpecies.get(i)==species)
                    glycanIndex = [glycanIndex;i];
                end
            end
        end
        
        
        
        % set all compartments based on the sbml_compartment
        function numCompts = addCompts(obj,varargin)  % cellarraylist
            % addCompts add an array of Compt objects to the network.
            %
            %  NUMCOMPTSADDED =  addCompts(LISTOFCOMPTS) takes an
            %   CellArrayList object and adds a series of Compt
            %   objects to the network.
            %
            %  NUMCOMPTSADDED =  addCompts(SBMLCOMPTS,LEVEL,VERSION) takes an
            %   SBML Compartment structure, SBML-level and version, converts
            %   to a number of Compt objects, and add them to the network.
            %
            %  See also Rxn,GlycanSpecies.
            
            numCompts=0;
            if (isa(varargin{1},'CellArrayList'))
                comptsToAdd = varargin{1};
                for i=1:  length(comptsToAdd);
                    isAdded=obj.addCompt(comptsToAdd.get(i));
                    if(isAdded)
                        numCompts=numCompts+1;
                    end
                end
            elseif (isa(varargin{1},'struct'))  %SBML-compartment
                level = varargin{2};
                version = varargin{3};
                comptsToAdd = varargin{1};
                
                for i=1:  length(comptsToAdd);
                    isAdded =obj.addCompt(comptsToAdd(i),level,version);
                    if(isAdded)
                        numCompts=numCompts+1;
                    end
                end
            end
        end
        
        % add a compartment to pathway
        function isAdded = addCompt(obj,varargin)
            % addCompt add a Compt object to the network
            %
            %  ISCOMPTADDED =  addCompt(GCOMPT) takes an
            %   Compt object and adds it to the network
            %
            %  ISCOMPTADDED =  addCompt(SBMLCOMPARTMENT,LEVEL,VERSION) takes an
            %   SBML_COMPARTMENT structure, SBML-level and verions, and
            %   adds a series of Compt objects to the network.
            %
            %  See also Rxn,Compartment.
            
            % add exception control
            if((length(varargin)==3))
                sbmlCompt = varargin{1};
                level = varargin{2};
                version = varargin{3};
                comptToAdd = Compt(sbmlCompt,level,version); % convert from sbml-compartment to compt
            elseif(length(varargin)==1)
                comptToAdd = varargin{1};
                if(~isa(comptToAdd,'Compt'))
                    errorReport(mfilename,'IncorrectInputType');
                end
            end
            
            if(~obj.compartment.contains(comptToAdd))
                %  fprintf('size of original glycan array is: %i \n ', length(obj.theSpecies));
                obj.compartment.add(comptToAdd);
                % fprintf('size of new glycan array: %i \n ', length(obj.theSpecies));
                isAdded = true;
            else
                % fprintf('species name is %s  \n',sbml_species.name);
                % fprintf('size of glycan array remains at : %i \n ', length(obj.theSpecies));
                isAdded = false;
            end
        end
        
        % set all glycans based on the sbml_species
        function numGlycans = addGlycans(obj,varargin)  % cellarraylist
            % addGlycans add an array of GlycanSpecies objects to the network.
            %
            %  NUMGLYCANADDED =  addGlycans(LISTOFGLYCANS) takes an
            %   CellArrayList object and adds a series of GlycanSpecies
            %    objects to the network.
            %
            %  NUMGLYCANADDED =  addGlycans(SBMLSPECIES,LEVEL,VERSION) takes an
            %   SBML species object, SBML-level and version, and adds a series
            %   of GlycanSpecies objects to the network.
            %
            %  See also Rxn,GlycanSpecies.
            
            numGlycans=0;
            if (isa(varargin{1},'CellArrayList'))
                glycansToAdd = varargin{1};
                for i=1:  length(glycansToAdd);
                    isAdded=obj.addGlycan(glycansToAdd.get(i));
                    if(isAdded)
                        numGlycans=numGlycans+1;
                    end
                end
            elseif (isa(varargin{1},'struct'))  %SBML-species
                level = varargin{2};
                version = varargin{3};
                glycanformat = 'glycoct_xml';
                if(nargin==4)
                    glycanformat = varargin{4};
                end
                glycansToAdd = varargin{1};
                for i=1:  length(glycansToAdd);
                    isAdded =obj.addGlycan(glycansToAdd(i),level,version,glycanformat);
                    if(isAdded)
                        numGlycans=numGlycans+1;
                    end
                end
            end
            %numGlycans
          %  fprintf(1,'number of glycan added: %i',numGlycans);
        end
        
        %
        function locs=findsameStructGlycan(obj,glycanSpeciesObj)
            %findsameStructGlycan find a GlycanSpecies object in the species
            %list sharing the same structure
            %
            % locs =  findsameStructGlycan(glycanSpeciesObj) find the
            %   position of species sharing the same glyan structure. If not
            %   found, return 0.
            %
            %  See also Rxn,GlycanSpecies.
            locs = 0;
            try
                b=glycanSpeciesObj.glycanStruct;
            catch error
                disp('error');
            end
            for i = 1 : length(obj.theSpecies)
                a=obj.theSpecies.get(i).glycanStruct;
                if(a.equalStruct(b))
                    locs=i;
                    return  % assume only one same structure in the list
                end
            end
        end
        
        function locs=findsameStructRxn(obj,rxnObj)
            %findsameStructRxn find a reaction object in the reaction
            %list sharing the same reactant and product structure
            %
            % locs =  findsameStructRxn(glycanRxnObj) find the
            % position of reaction sharing the same glyan reaction. If not
            % found, return 0.
            %
            %  See also Rxn,GlycanSpecies.
            locs = 0;
            for i = 1 : length(obj.theRxns)
                %isSameRxn = false;
                react = obj.theRxns.get(i).getReactant;
                prod = obj.theRxns.get(i).getProduct;
                
                if(equalStruct(react.glycanStruct, ....
                        rxnObj.getReactant.glycanStruct)...
                        &&equalStruct(prod.glycanStruct,...
                        rxnObj.getProduct.glycanStruct))
                    locs=i;
                    return  % assume only one same structure in the list
                end
            end
        end
        
        
        % add glycan to pathway
        function isAdded = addGlycan(obj,varargin)
            %addGlycan add a GlycanSpecies object to the network
            %
            % ISGLYCANADDED =  addGlycan(GLYCANSPEC) takes an
            %  GlycanSpecies object and adds it to the network
            %
            % ISGLYCANADDED =  addGlycan(SBMLSPECIES,LEVEL,VERSION) takes an
            %  SBML Species structure, SBML-level and version, and adds a
            %  number of GlycanSpecies objects to the network.
            %
            %  See also Rxn,GlycanSpecies.
            
            % add exception control
            if((length(varargin)==3)||length(varargin)==4)
                sbml_species = varargin{1};
                level = varargin{2};
                version = varargin{3};
                if(isSBML_Species(sbml_species,level,version))
                    glycanToAdd = GlycanSpecies(sbml_species,level,version); % convert from sbml-speceis to theSpecies
                    
                    % set compartment for glycan
                    theComptName = Species_getCompartment(sbml_species);
                    theCompt = obj.findComptByName(theComptName);  
                    glycanToAdd.setCompartment(theCompt);
                else
                    error('MATLAB:GNAT:WRONGSBMLVER','sbml version is not right');
                end
            elseif(length(varargin)==1)
                glycanToAdd = varargin{1};
                if(~isa(glycanToAdd,'GlycanSpecies'))
                    error('MATLAB:GNAT:IncorrectInputType','Wrong Input Type');
                end
            end
            
            if(~obj.theSpecies.contains(glycanToAdd)) % check if there is equal object
                % fprintf('size of original glycan array is: %i \n ', length(obj.theSpecies));
                locs=findsameStructGlycan(obj,glycanToAdd);
                % fprintf('find same structure pos: %i \n',locs);
                if(locs==0)
                    isAdded=true;
                elseif((isprop(glycanToAdd,'compartment'))...
                        &&(isprop(obj.theSpecies.get(locs),'compartment')))
                    % fprintf('find same structure : %i \n ', locs);
                    comptToAdd  = glycanToAdd.getCompartment;
                    comptCurrent = obj.theSpecies.get(locs).getCompartment;
                    if(isequal(comptToAdd,comptCurrent))
                        isAdded =false;
                    else
                        isAdded = true;
                    end
                else
                    isAdded=false;
                end
            end
            
            if(isAdded)
                 % fprintf('add structure \n ');
                obj.theSpecies.add(glycanToAdd);
                if(isprop(glycanToAdd,'Compartment') ...
                        &&(~isempty(glycanToAdd.getCompartment)) )
                    obj.addCompt(glycanToAdd.getCompartment);
                end
            else
                % fprintf('species name is %s  \n',sbml_species.name);
                % fprintf('size of glycan array remains at : %i \n ', length(obj.theSpecies));
                %isAdded = false;
            end
        end
        
        % add a new pathway to the network
        function [numSpeciesAdded,numRxnsAdded,numEnzAdded] =  addGlyPath(obj,pathtoadd)
            % addGlyPath add a pathway to the network
            %
            %  NUMRXNSADDED =  addGlyPath(obj,pathtoadd) takes an
            %   pathway object and adds a number of Rxn and Species
            %   objects in the list to the network
            %
            %  See also Pathway.
            
            rxnsToAdd               = pathtoadd.theRxns;
            speciesToAdd         = pathtoadd.theSpecies;
            enzsToAdd              = pathtoadd.theEnzs;
            
            numSpeciesAdded =obj.addGlycans(speciesToAdd); % check structure and object equality
            numRxnsAdded     = obj.addRxns(rxnsToAdd);
            numEnzAdded       = obj.addEnzs(enzsToAdd);
            %obj.addRxns(rxnsToAdd);
        end
        
        % add a new pathway to the network based on the structure
        function [newGlycans,newRxns,newEnzs] =  addGlyPathByStruct(obj,pathtoadd)
            % addGlyPath add a pathway to the network
            %
            %  NUMRXNSADDED =  addGlyPath(obj,pathtoadd) takes an
            %   pathway object and adds a number of Rxn and Species
            %   objects in the list to the network
            %
            %  See also Pathway.
            
            rxnsToAdd       = pathtoadd.theRxns;
            speciesToAdd = pathtoadd.theSpecies;
            enzsToAdd      = pathtoadd.theEnzs;
            
            newGlycans =obj.addGlycansByStruct(speciesToAdd); % check structure and object equality
            newRxns     = obj.addRxnsByStruct(rxnsToAdd);
            newEnzs       = obj.addEnzs(enzsToAdd);
            %obj.addRxns(rxnsToAdd);
        end
        
        % add reactions to pathway
        function newRxns =  addRxnsByStruct(obj,varargin)
            % addRxnsByStruct add an array of Rxn object(s) to the network
            %
            %  NUMRXNSADDED =  addRxnsByStruct(LISTOFRXNS) takes an
            %   CellArrayList object and adds a number of Rxn
            %   objects in the list to the network
            %
            %
            %  See also Pathway.
            
            newRxns = CellArrayList;
            if(isa(varargin{1},'CellArrayList'))
                rxnsToAdd = varargin{1};
                for i=1:rxnsToAdd.length
                    %fprintf(1,' ith reaction %f\n',i);
                    isAdded = obj.addRxnByStruct(rxnsToAdd.get(i));
                    if(isAdded)
                        newRxns.add(rxnsToAdd.get(i));
                    end
                end
            end
        end
        
        % add reaction to pathway by structure
        function isAdded = addRxnByStruct(obj,varargin)
            % addRxnByStruct add a Rxn object to the network
            %
            %   ISRXNADDED =  addRxnByStruct(THEREAC, THERPODUCT) takes the GlycanSpecies objects
            %    THEREACT and THERPODUCT as an inputs to create a reaction and adds it to
            %    the network
            %
            %   ISRXNADDED =  addRxnByStruct(THEREAC,THERPODUCT,THEENZ) takes the
            %      GlycanSpecies objects THEREACT and THERPODUCT and the
            %      Enz object THEENZ as the inputs to create a reaction and adds
            %      it to the network
            %
            %  See also Pathway.
            
            % narginchk(1,3);
            
            if(length(varargin)==1)
                if isa(varargin{1},'Rxn')
                    rxnToAdd = varargin{1};
                    reactant = rxnToAdd.getReactant;
                    product  = rxnToAdd.getProduct;
                elseif(length(varargin)==2)
                    reactant = varargin{1};
                    product  = varargin{2};
                    rxnToAdd = Rxn(reactant,product);
                elseif(length(varargin)==3)
                    reactant     = varargin{1};
                    product     = varargin{2};
                    enzyme     =  varargin{3};
                    rxnToAdd = Rxn(reactant,product,enzyme);
                end
                
                reactlocs=obj.findsameStructGlycan(reactant);
                prodlocs =obj.findsameStructGlycan(product);
                
                if((~isempty(reactant)) &&(reactlocs==0))
                    errorReport(mfilename,'reactant species is not in the network');
                    %isAdded = false;
                    return
                end
                
                if((~isempty(product) && (prodlocs==0)))
                    errorReport(mfilename,'product species is not in the network');
                end
                
                % check if reactant or product is already included in the
                % species list
                if(reactlocs>0)  % if structure is same
                    reactant =obj.theSpecies.get(reactlocs);
                end
                
                if(prodlocs>0)  % if structure is same check compartment
                    product =obj.theSpecies.get(prodlocs);
                end
                
                if(isempty(rxnToAdd.enz))
                    rxnToAdd = Rxn(reactant,product);
                else
                    rxnToAdd = Rxn(reactant,product,rxnToAdd.enz);
                end
                
                rxnlocs = obj.findsameStructRxn(rxnToAdd);
                
                if(rxnlocs==0)
                    obj.theRxns.add(rxnToAdd);
                    isAdded = true;
                    if(~isempty(reactant))
                        reactant.addRxn(rxnToAdd);
                    end
                    if(~isempty(product))
                        product.addRxn(rxnToAdd);
                    end
                else
                    isAdded = false;
                end
            end
        end
        
        % set all glycans based on the structure
        function newGlycans = addGlycansByStruct(obj,varargin)
            % addGlycansByStruct add an array of GlycanSpecies objects to the existing network.
            %
            %  NUMGLYCANADDED =  addGlycansByStruct(LISTOFGLYCANS) takes an
            %   CellArrayList object and adds a series of GlycanSpecies
            %    objects to the network.
            %
            %
            %  See also Rxn,GlycanSpecies.
            
            newGlycans=CellArrayList;
            if (isa(varargin{1},'CellArrayList'))
                glycansToAdd = varargin{1};
                for i=1:  length(glycansToAdd);
                    isAdded=obj.addGlycanByStruct(glycansToAdd.get(i));
                    if(isAdded)
                        newGlycans.add(glycansToAdd.get(i));
                    end
                end
            end
        end
        
        % add glycan to pathway by structure
        function isAdded = addGlycanByStruct(obj,varargin)
            %addGlycanByStruct add a GlycanSpecies object to the network
            % by structure
            %
            % ISGLYCANADDED =  addGlycanByStruct(GLYCANSPEC) takes an
            %  GlycanSpecies object and adds it to the network
            %
            %
            %  See also Rxn,GlycanSpecies.
            
            % add exception control
            if(length(varargin)==1)
                glycanToAdd = varargin{1};
                %                 if(~isa(glycanToAdd,'GlycanSpecies'))
                %                     error('MATLAB:GNAT:IncorrectInputType','Incorrect Input Type');
                %                 end
            end
            
            locs=findsameStructGlycan(obj,glycanToAdd);
            if(locs==0)
                isAdded=true;
            else
                isAdded=false;
            end
            
            if(isAdded)
                obj.theSpecies.add(glycanToAdd);
                if(isprop(glycanToAdd,'Compartment') ...
                        &&(~isempty(glycanToAdd.getCompartment)) )
                    obj.addCompt(glycanToAdd.getCompartment);
                end
            else
                % fprintf('species name is %s  \n',sbml_species.name);
                % fprintf('size of glycan array remains at : %i \n ', length(obj.theSpecies));
                %isAdded = false;
            end
        end
        
        % add an array of Enzymes to pathway
        function newEnzs =  addEnzs(obj,varargin)
            % addRxns add an array of Enz object(s) to the network
            %
            %  numEnzs =  addEnzs(LISTOFENZS) takes an
            %   CellArrayList object and adds a number of Enz
            %   objects in the list to the network
            %
            %  See also Pathway.
            
            newEnzs = CellArrayList;
            if(isa(varargin{1},'CellArrayList'))
                enzsToAdd = varargin{1};
                for i=1:enzsToAdd.length
                    %fprintf(1,' ith reaction %f\n',i);
                    isAdded = obj.addEnz(enzsToAdd.get(i));
                    if(isAdded)
                        newEnzs.add(enzsToAdd.get(i));
                    end
                end
            end
        end
        
        % add an  Enzymes to the pathway
        function numEnzs =  addEnz(obj,varargin)
            % addEnz add an Enz object to the network
            %
            %  numEnzs =  addEnz(enz) takes an
            %   Enz object to the network
            %
            %  See also Pathway.
            
            numEnzs = 0;
            enztoadd = varargin{1};
            if(~obj.theEnzs.contains(enztoadd))
                obj.theEnzs.add(enztoadd);
            end
        end
        
        % add reactions to pathway
        function numRxns =  addRxns(obj,varargin)
            % addRxns add an array of Rxn object(s) to the network
            %
            %  NUMRXNSADDED =  addRxns(LISTOFRXNS) takes an
            %   CellArrayList object and adds a number of Rxn
            %   objects in the list to the network
            %
            %  NUMRXNSADDED =  addRxns(SBML_REACTION,LEVEL,VERSION) takes an
            %   SBML reaction structure, SBML-level and version, and adds a
            %   series of Rxn objects to the network.
            %
            %  See also Pathway.
            
            numRxns = 0;
            if(isa(varargin{1},'CellArrayList'))
                rxnsToAdd = varargin{1};
                for i=1:rxnsToAdd.length
                    %fprintf(1,' ith reaction %f\n',i);
                    isAdded = obj.addRxn(rxnsToAdd.get(i));
                    if(isAdded)
                        numRxns = numRxns+1;
                    end
                end
            elseif(isa(varargin{1},'struct'))  %ccheck valid of sbml-reaction
                rxnsToAdd = varargin{1};
                for i=1:length(rxnsToAdd)
                   % fprintf(1,' ith reaction %f\n',i);
                    isAdded = obj.addRxn(rxnsToAdd(1,i));
                    if(isAdded)
                        numRxns = numRxns+1;
                    else
                        disp('reaction is already included in the pathway');
                    end
                end
            end
        end
        
        % add reaction to pathway
        function isAdded = addRxn(obj,varargin)
            % addRxn add a Rxn object to the network
            %
            %   ISRXNADDED =  addRxn(SBMLRXN) takes a SBML reaction structure SBMLRXN
            %    as an input and adds it to the network
            %
            %   ISRXNADDED =  addRxn(THEREAC, THERPODUCT) takes the GlycanSpecies objects
            %    THEREACT and THERPODUCT as an inputs to create a reaction and adds it to
            %    the network
            %
            %   ISRXNADDED =  addRxn(THEREAC,THERPODUCT,THEENZ) takes the
            %      GlycanSpecies objects THEREACT and THERPODUCT and the
            %      Enz object THEENZ as the inputs to create a reaction and adds
            %      it to the network
            %
            %  See also Pathway.
            
            % narginchk(1,3);
            
            if(length(varargin)==1)
                if isa(varargin{1},'Rxn')
                    rxnToAdd = varargin{1};
                    reactant = rxnToAdd.getReactant;
                    product  = rxnToAdd.getProduct;
                elseif ( isValid(varargin{1}) &&...
                        isSBML_Reaction(varargin{1},GetLevel(varargin{1}))...
                        )
                    sbmlRxn =varargin{1};
                    %[level,version]=GetLevelVersion(sbmlRxn);
                    
                    if(~isempty(sbmlRxn.reactant))
                        reactant = obj.findSpeciesByID(sbmlRxn.reactant(1).species);
                    else
                        reactant = [];
                    end
                    
                    if(~isempty(sbmlRxn.product))
                        product  = obj.findSpeciesByID(sbmlRxn.product(1).species);
                    else
                        product = [];
                    end
                    
                    if((isempty(reactant))&&(isempty(product)))
                        errorReport(mfilename,'wrong reaction assignment')
                    end
                    
                    if(isempty(sbmlRxn.name))
                        if~isempty(reactant)
                            reactantname =reactant.name;
                        else
                            reactantname = 'null';
                        end
                        
                        if~isempty(product)
                            productname =product.name;
                        else
                            productname = 'null';
                        end
                        
                        rxnName = [reactantname '_to_' productname];
                    else
                        rxnName = sbmlRxn.name;
                    end
                    
                    if(isempty(rxnName))
                        rxnName ='unknown';
                    end
                    
                    rxnToAdd = Rxn(reactant,product,rxnName);
                end
            elseif(length(varargin)==2)
                reactant = varargin{1};
                product  = varargin{2};
                rxnToAdd = Rxn(reactant,product);
            elseif(length(varargin)==3)
                reactant     = varargin{1};
                product     = varargin{2};
                enzyme     =  varargin{3};
                rxnToAdd = Rxn(reactant,product,enzyme);
            end
                        
            if(~isempty(reactant))
                reactlocs=obj.findsameStructGlycan(reactant);
            end
            
            if(~isempty(product))
                prodlocs =obj.findsameStructGlycan(product);
            end
            
            if((~isempty(reactant)) &&(~obj.theSpecies.contains(reactant))...
                    && (reactlocs==0))
                errorReport(mfilename,'reactant species is not in the network');
                %isAdded = false;
                return
            end
            
            if((~isempty(product) &&~obj.theSpecies.contains(product))...
                    && (prodlocs==0))
                errorReport(mfilename,'product species is not in the network');
                %isAdded = false;
            end
            
            % check if reactant or product is already included in the
            % species list
            if(~isempty(reactant))
            isReactsInList = obj.theSpecies.contains(reactant);
            if(isReactsInList)
                ithpos =  locationsOf(obj.theSpecies,reactant);
                reactant =obj.theSpecies.get(ithpos);
            elseif(reactlocs>0)  % if structure is same check compartment
                %  if(~(obj.theSpecies.get(reactlocs).compartment.equal(reactant.compartment)))
                reactant =obj.theSpecies.get(reactlocs);
                %                 else
                %                     errorReport(mfilename,'reactant species is not in the network');
                %                 end
            end
            end
            
             if(~isempty(product))
            isProdInlist = obj.theSpecies.contains(product);
            if(isProdInlist)
                ithpos =  locationsOf(obj.theSpecies,product);
                product =obj.theSpecies.get(ithpos);
            elseif(prodlocs>0)  % if structure is same check compartment
                %                 if(~(obj.theSpecies.get(prodlocs).compartment.equal(product.compartment)))
                product =obj.theSpecies.get(prodlocs);
                %                 else
                %                     errorReport(mfilename,'reactant species is not in the network');
                %                 end
            end
             end
            
            if(isempty(rxnToAdd.enz))
                rxnToAdd = Rxn(reactant,product);
            else
                rxnToAdd = Rxn(reactant,product,rxnToAdd.enz);
            end
            
            if(~obj.theRxns.contains(rxnToAdd))
                obj.theRxns.add(rxnToAdd);
                isAdded = true;
                if(~isempty(reactant))
                    reactant.addRxn(rxnToAdd);
                end
                if(~isempty(product))
                    product.addRxn(rxnToAdd);
                end
            else
                isAdded = false;
            end
        end
        
        % remove glycan from the pathway
        function isRemoved = removeSpecies(obj,speciesToRemove)
            % removeSpecies remove the species from the network
            %
            %  isRemoved = removeSpecies(THEPATHWAY,SPECIESTOREMOVE) removes
            %   the GlycanSpecies speciesToRemove from the Pathway Object
            %   THEPATHWAY.
            %
            % See also Pathway
            
            if( ~obj.theSpecies.contains(speciesToRemove))
                isRemoved = false;
                return
            else
                speciesLoc =  obj.theSpecies.locationsOf(speciesToRemove);
            end
            
            obj.theSpecies.remove(speciesLoc);
            
            % check the rxn list which contains the species to remove and
            % remove it
            for i=1:obj.theRxns.length
                theReactant = obj.theRxns.get(i).getReactant;
                if(isequal(speciesToRemove,theReactant))
                    obj.theRxns.remove(i);
                    continue;
                end
                
                theProduct = obj.theRxns.get(i).getProduct;
                if(isequal(speciesToRemove,theProduct))
                    obj.theRxns.remove(i);
                end
            end
            
            %             %remove the reaction associated with species from the network
            %             %being a reactant
            %             for i=1:speciesToRemove.getNumReacRxns
            %                 reacRxn = speciesToRemove.getReacRxn(i);
            %                 speciesToRemove.removeRxn(reacRxn);
            %                 prod = reacRxn.getProduct;
            %                 prod.removeRxn(reacRxn);
            %                 reacRxnLoc = obj.theRxns.locationsOf(reacRxn);
            %                 obj.theRxns.remove(reacRxnLoc);
            %             end
            %
            %             %remove the reaction associated with species from the network
            %             %being a product
            %             for i=1:speciesToRemove.getNumProdRxns
            %                 prodRxn = speciesToRemove.getProdRxn(i);
            %                 speciesToRemove.remove(prodRxn);
            %                 reac = prodRxn.getReac;
            %                 reac.remove(prodRxn);
            %                 obj.theRxns.remove(prodRxn);
            %             end
            
            isRemoved = true;
        end
        
        % remove rxn from the pathway
        function isRemoved = removeRxn(obj,reac,prod)
            % removeRxn remove a reaction from the network
            %   STATUS =  REMOVERXN(REACTANT,PRODUCT) remove a reaction
            %    where the reactant is REACTANT and the product is
            %    PRODUCT.
            %
            % See also Pathway
            rxn = reac.findRxn(prod);
            if(isempty(rxn))
                isRemoved = false;
                return;
            else
                reac.remove(rxn);
                prod.remove(rxn);
                obj.theRxns.remove(rxn);
                isRemoved=true;
            end
        end
        
        function isequal = equalPath(obj,obj2)
            if(obj.theSpecies.length~=obj2.theSpecies.length)
                isequal = false;
                return
            end
            
            for i = 1 : obj.theSpecies.length
                ithspecies         =  obj.theSpecies.get(i);
                isspeciesfound = obj2.findsameStructGlycan(ithspecies);
                if(~isspeciesfound)
                    isequal=false;
                    return
                end
            end
            
            isequal = true;
        end
        
        
        function clearSpeciesMark(obj)
            % clearSpeciesMark reset all marks as false
            %
            % See also Pathway
            for i=1:obj.theSpecies.length
                obj.theSpecies.get(i).clearMark;
                obj.theSpecies.get(i).clearMarkState;
            end
        end
        
        function clearRxnsMark(obj)
            % clearRxnsMark remove all reactions'a marks from the network
            %
            % See also Pathway
            for i=1:obj.theRxns.length
                obj.theRxns.get(i).clearMark;
            end
        end
    end
    
    methods
        function speciesToFindByName = findSpeciesByName(obj,specName)
            % findSpeciesByName search species in the network by its name
            %
            %   SP = FINDSPECIESBYNAME(PATHWAY,SPNAME) takes SPNAME as an
            %    input and returns the reference to the species which has the same
            %    name. If no same name is found, SP is returns as an empty
            %    value
            %
            % See also Pathway.
            speciesToFindByName =[];
            for i=1: obj.theSpecies.length
                theithSpecies = obj.theSpecies.get(i);
                if(strcmpi(theithSpecies.getName,specName))
                    speciesToFindByName = theithSpecies;
                    return;
                end
            end
        end
        
        function comptToFindByName = findComptByName(obj,comptName)
            % findComptByName search compartment in the network by its name
            %
            %   COMPT = FINDCOMPTBYNAME(PATHWAY,COMPTNAME) takes
            %    COMPTNAME as an input and returns the reference to the
            %    compartment which has the same name. If no same name is found,
            %     COMPT is returns as an empty value.
            %
            % See also Pathway.
            comptToFindByName =[];
            for i=1: obj.compartment.length
                theithcompartment = obj.compartment.get(i);
                if (strcmpi(theithcompartment.getName,comptName))
                    comptToFindByName = theithcompartment;
                    return;
                end
            end
        end
        
        % search the species by glycan name
        function speciesToFindByID = findSpeciesByID(obj,id)
            % findSpeciesByID search species in the network by its id
            %
            %   SP = FINDSPECIESBYID(PATHWAY,SPID) takes SPID as an
            %    input and returns the reference to the species which has the same
            %    ID. If no same name is found, SP is returns as an empty
            %    value
            %
            % See also Pathway.
            speciesToFindByID =[];
            for i=1: obj.theSpecies.length
                theithSpecies = obj.theSpecies.get(i);
                if(strcmpi(theithSpecies.getID,id))
                    speciesToFindByID = theithSpecies;
                    return;
                end
            end
        end
        
        function isStructinPath = isStructinPath(obj,spec)
            isStructinPath = ~isempty(obj.findSpeciesByStruct(spec));
        end
        
        function savepathway(obj,filename)
            pathtosave = obj.clone;
            for i=1: pathtosave.getNSpecies
                ithspecies=pathtosave.theSpecies.get(i);
                ithspecies.glycanStruct.glycanjava=[];
            end
            save(filename,'pathtosave');
        end
        
        % search the species by
        function speciesToFindByStruct = findSpeciesByStruct(obj,spec)
            % findSpeciesByStruct search species in the network by its structure
            %
            %     SP = FINDSPECIESBYSTRUCT(PATHWAY,SPSTRUCT) takes SPSTRUCT as an
            %    input and returns the reference to the species which has the same
            %    structure. If no same structure is found, SP is returns as empty
            %    value
            %
            % See also Pathway.
            
            speciesToFindByStruct =[];
            for i=1: obj.theSpecies.length
                if(spec.glycanStruct.equalStruct(obj.theSpecies.get(i).glycanStruct))
                    speciesToFindByStruct = obj.theSpecies.get(i);
                    return;
                end
            end
        end        
    end
    
    methods  %getter methods
        function res = getInitGlycans(obj)
            % getInitGlycans get the initial glycan species
            %
            % See also Pathway
            res = obj.initGlycans;
        end
        
        function res = getFinalGlycans(obj)
            % getFinalGlycans get the final glycan species
            %
            % See also Pathway
            res = obj.initGlycans;
        end
        
        function setInitGlycans(obj,initGlycans)
            % setInitGlycans set the initial glycan species
            %
            % See also Pathway
            obj.initGlycans= initGlycans;
            
            if (~obj.theSpecies.contains(initGlycans))
                obj.theSpecies.add(initGlycans)
            end
        end
        
        function setFinalGlycans(obj,finalGlycans)
            % setFinalGlycans set the initial glycan species
            %
            % See also Pathway
            obj.finalGlycans= finalGlycans;
            if (~obj.theSpecies.contains(finalGlycans))
                obj.theSpecies.add(finalGlycans)
            end
        end
        
        function setCompartment(obj,compartment)
            % setCompartment set the compartment in the network
            %
            % See also Pathway
            obj.compartment = compartment;
        end
        
        function res = getCompartment(obj)
            % getCompartment get the compartment in the network
            %
            % See also Pathway
            res = obj.compartment;
        end % end
        
        function res = getReactions(obj)
            % getReactions get the reactions in the network
            %
            % See also Pathway
            res = obj.theRxns;
        end % end
        
        function res = getNReactions(obj)
            % getNReactions get the number of the reactions in the network
            %
            % See also Pathway
            res = obj.theRxns.length;
        end % end
        
        function res = getEnzymes(obj)
            % getEnzymes get the enzymes in the network
            %
            % See also Pathway
            res = obj.enzs;
        end % end
        
        function res = getName(obj)
            % getName get the name of  the network
            %
            % See also Pathway
            res = obj.name;
        end % end
        
        function res = getNSpecies(obj)
            % getNSpecies get the number of the species in  the network
            %
            % See also Pathway
            res = obj.theSpecies.length;
        end % end
        
        function res = getSpecies(obj)
            % getSpecies get the species in  the network
            %
            % See also Pathway
            res = obj.theSpecies;
        end % end
        
        function res = getGlycanStruct(obj,i)
            % getGlycanStruct get the glycan structure of ith species in  the network
            %
            % See also Pathway
            res = obj.theSpecies.get(i).getGlycanStruct;
        end % end
    end
    
    methods  % setter methods
        
        function setReactions(obj,reactions)
            % SETREACTIONS set the reactions in the network
            %
            %See also PATHWAY
            obj.theRxns = reactions;
        end % end
        
        function setSpecies(obj,species)
            % SETSPECIES set the species in the network
            %
            %See also PATHWAY
            obj.theSpecies = species;
        end % end
        
        function setName(obj,name)
            % SETNAME set the name of the network
            %
            % See also PATHWAY
            obj.name = name;
        end % end
        
        function setEnzymes(obj,enzymes)
            % SETENZYMES set the enzymes in the network
            %
            % See also PATHWAY
            obj.enzs = enzymes;
        end % end
        
        function setSpeciesIsolated(obj,glycanstructobj)
            % setSpeciesIsolated set the species in the network isolated
            %
            % See also PATHWAY
            for i = 1 : obj.getNSpecies
                ithspecies = obj.theSpecies.get(i);
                
                if(ithspecies.glycanStruct.equalStruct(glycanstructobj))
                        ithspecies.listOfReacRxns=CellArrayList();
                        ithspecies.listOfProdRxns=CellArrayList();
                        continue;
                end
                
                 removereactindex = [];
                 for ii = 1: ithspecies.listOfReacRxns.length
                     theprod = ithspecies.listOfReacRxns.get(ii).getProduct;
                     if(theprod.glycanStruct.equalStruct(glycanstructobj))
                         removereactindex =[removereactindex;ii];
                     end
                 end
                 if(~isempty(removereactindex))
                     ithspecies.listOfReacRxns.remove(removereactindex);
                 end
                
                removeprodtindex = [];
                for ii = 1: ithspecies.listOfProdRxns.length
                    thereact = ithspecies.listOfProdRxns.get(ii).getReactant;
                    if(thereact.glycanStruct.equalStruct(glycanstructobj))
                        removeprodtindex =[removeprodtindex;ii];
                    end
                end
                
                if(~isempty(removeprodtindex))
                    ithspecies.listOfProdRxns.remove(removeprodtindex);
                end
            end
            
            removeindex = [];
            for i = 1 : obj.getNReactions
                ithrxn = obj.theRxns.get(i);
                theReact = ithrxn.getReactant.glycanStruct;
                theProd  = ithrxn.getProduct.glycanStruct;
                if(theReact.equalStruct(glycanstructobj))
                    removeindex = [removeindex;i];
                    continue;
                end
                
                if(theProd.equalStruct(glycanstructobj))
                    removeindex = [removeindex;i];
                    continue;
                end
            end
            obj.theRxns.remove(removeindex);
        end
        
    end
    
    methods
        glycanNetJava = pathwayMat2Java(obj )
    end
    
    methods
        function new = clone(obj)
            %CLONE deep copy a Pathway object
            %  clone(RATHWAYobj) creates a new PATHWAY object
            %
            %  See also Pathway
            
            % Instantiate new object of the same class.
            meta = metaclass(obj);
            new = feval(class(obj));
            for i = 1:length(meta.Properties)
                prop = meta.Properties{i};
                if ~(prop.Dependent || prop.Constant) ...
                        && ~(isempty(obj.(prop.Name)) ...
                        && isempty(new.(prop.Name)))
                    if ~isa(obj.(prop.Name),'handle')
                        new.(prop.Name) = obj.(prop.Name);
                    end
                end
            end
            
            new.theRxns = CellArrayList();
            new.theSpecies = CellArrayList();
            new.compartment = CellArrayList();
            new.theEnzs = CellArrayList();
            
            % add enzs to the pathway
            for i=1:length(obj.theEnzs)
                theEnz = obj.theEnzs.get(i).clone;
                new.addEnz(theEnz);
            end
            
            % add species to the pathway
            for i=1:length(obj.theSpecies)
                theGlycan = obj.theSpecies.get(i).clone;
                new.addGlycan(theGlycan);
            end
            
            % add reactions to the pathway
            for i=1:length(obj.theRxns)
                theRxnToCopy = obj.theRxns.get(i);
                
                % find reactant and add it to a new reaction
                theReactant = theRxnToCopy.getReactant;
                if(~isempty(theReactant))
                    reacLoc = obj.theSpecies.locationsOf(theReactant);
                    reac = new.theSpecies.get(reacLoc);
                else
                    reac = [];
                end
                
                % find product and add it to a new reaction
                theProduct = theRxnToCopy.getProduct;
                if(~isempty(theProduct))
                    prodLoc = obj.theSpecies.locationsOf(theProduct);
                    prod = new.theSpecies.get(prodLoc);
                else
                    prod = [];
                end
                
                % find eznyme and add it to a new reaction
                theEnz = theRxnToCopy.getEnzyme;
                if(~isempty(theEnz))
                    enzLoc = obj.theEnzs.locationsOf(theEnz);
                    enz = new.theEnzs.get(enzLoc);
                else
                    enz = [];
                end
                if(~isempty(enz))
                    theRxnClone = Rxn(reac,prod,enz);
                else
                    theRxnClone = Rxn(reac,prod);
                end
                new.addRxn(theRxnClone);
            end
            
            % add compartments to the pathway
            for i=1:length(obj.compartment)
                new.addCompts(obj.compartment.get(i).clone);
            end
            
        end
    end
end