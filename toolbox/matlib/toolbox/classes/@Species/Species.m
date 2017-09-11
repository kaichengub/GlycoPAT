classdef Species <handle
    %Species abstract class representing a species in the reaction network.
    %
    % A Species object is a generic representation of any
    %  molecules in the glycosylation network. It consists of an array of
    %  species property including molecular concentration, mass amount,
    %  compartment location. And it is is considered as a node (species)
    %  in the graph (reaction networks).
    %
    % Species properties:
    %  listOfReacRxns         - a list of reactions in which the glycan is involved as a reactant
    %  listOfProdRxns         - a list of reactions in which the glycan is involved as a product
    %  mark                   - if the species is marked when the path is searched
    %  markState              - the state of the mark
    %  initConc               - initial concentration
    %  initAmount             - initial amount
    %  compartment            - the compartment where the species resides
    %  units                  - units for the concentration
    %  name                   - name of the species
    %  id                     - id of the species
    %  timeConc               - time-dependent concentrations
    %
    % See also GlycanStruct,GlycanResidue.
    
    % Author: Gang Liu
    % Copyright 2012 Neelamegham Lab.
    % Date Last Modified: 1/21/2013
    
    properties
        listOfReacRxns;
        listOfProdRxns;
        mark;  % for graph structure
        markState; % for graph structure
        initConc;
        initAmount;
        compartment;
        units;
        name;
        id;
        timeConc;
    end
    
    methods
        function obj = Species(varargin)
            %SPECIES create a Species object
            %
            %   SpeciesObj = SPECIES() creates a GlycanSpecies object with
            %   the default value for empty fields.
            %
            % See also GLYCANSPECIES
            % validate the number of input arguments
            
            error(nargchk(0,1,nargin));
            
            if(nargin==0)  % empty glycan species
                obj.mark = false;
                obj.name ='';
                obj.listOfReacRxns=CellArrayList();
                obj.listOfProdRxns=CellArrayList();
                
            elseif(nargin==1)
                
                if(~isa(varargin{1},'char'));
                    errorReport(mfilename,'IncorrectInputType');
                end;
                
                obj.name = varargin{1};
                obj.mark = false;
                obj. listOfReacRxns=CellArrayList();
                obj. listOfProdRxns=CellArrayList();
            end
        end
        
       function isRxnAdded = addRxn(obj,rxnToAdd)
            % ADDRXN add a reaction where the species functions as a reactant or a product to either listOfReacRxns or listOfProdRxns property
            %
            %    STATUS = ADDRXN(GSPECIES, RXNTOADD) add the reaction RXNTOADD
            %      to the GSPECIES's property LISTOFREACRXNS or LISTOFPRODRXNS.
            %      If STATUS is false, it indicates that GSPECIES is not involved in the reaction
            %      RXNTOADD and no change is made in the GSPECIES object.  Alternative equilvalent
            %      syntax:  STATUS = GSPECIES.ADDRXN(RXNTOADD).
            %
            % See also Species.
            
            % input type check
            if(~isa(rxnToAdd,'Rxn'))
                errorReport(mfilename,'IncorrectInputType');
            end
            
            if(~isempty(rxnToAdd.getReactant) && (rxnToAdd.getReactant==obj) && (~obj.listOfReacRxns.contains(rxnToAdd)))
                obj.listOfReacRxns.add(rxnToAdd);
                isRxnAdded = true;
            elseif(~isempty(rxnToAdd.getProduct)&&(rxnToAdd.getProduct==obj))&&(~obj.listOfProdRxns.contains(rxnToAdd))
                obj.listOfProdRxns.add(rxnToAdd);
                isRxnAdded = true;
            else
                isRxnAdded = false;
            end
        end
        
        function addReacRxn(obj,prodToAdd,varargin)
            % ADDREACRXN add a reaction Rxn object where the species functions as reactant to the listOfReacRxns property
            %
            %  ADDREACTRXN(GSPECIES, RRODTOADD) creates a reaction
            %   where the reactant is current Species object  and the
            %   product is the Species PRODTOADD and add this reaction to
            %   GSPECIES's property of  LISTOFREACRXNS
            %
            %  ADDREACTRXN(GSPECIES, RRODTOADD,ENZTOADD) specifies the
            %   enzyme ENZTOADD involved in the reaction where GSPECIES is the reactant and
            %   RRODTOADD is the product.
            %
            % See also Species
            
            % input number check
            narginchk(0,2);
            
            if(length(varargin)==1)
                enzToAdd = varargin{1};
                rxnToAdd = Rxn(obj,prodToAdd,enzToAdd);
            else
                rxnToAdd = Rxn(obj,prodToAdd);
            end
            
            obj.listOfReacRxn.add(rxnToAdd);
        end
        
        function addProdRxn(obj,reacToAdd,varargin)
            % ADDPRODRXN add a reaction Rxn object where the species functions as product to the listOfProdRxns property
            %
            %      ADDPRODRXN(GSPECIES, REACTOADD) creates a reaction
            %  where the reactant is Species REACTOADD object  and the
            %  product is the Species GSPECIES and add this reaction to
            % GSPECIES's property of  LISTOFPRODRXNS
            %
            %       ADDPRODRXN(GSPECIES, REACTOADD,ENZTOADD) specify the
            %   enzyme ENZTOADD involved in the reaction where GSPECIES is the product and
            %   REACTOADD is the reactant.
            %
            %  See also Species
            
            % input number check
            narginchk(0,2);
            
            if(length(varargin)==1)
                enzToAdd = varargin{1};
                rxnToAdd = Rxn(reacToAdd,obj,enzToAdd);
            else
                rxnToAdd =Rxn(reacToAdd,obj);
            end
            obj.listOfProdRxn.add(rxnToAdd);
        end
        
        function hasRxn = hasRxn(obj,varargin)
            % HASRXN returns true if the species is involved in a specified reaction
            %
            %      HASRXN(SPECIES, RXNTOCHECK) specifies the reaction as
            %        the RXN referenced as input argument RXNTOCHECK
            %
            %       HASRXN(SPECIES1, SPECIES2) specify the reaction
            %       which has two species including GLYCANSPECIES1 and GLYCANSPECIES2
            %
            %  See also Species
            
            % input type check
            if ~ (isa(varargin{1},'Rxn') || isa(varargin{1},'Species'))
                errorReport(mfilename,'IncorrectInputType');
            end
            
            if(isa(varargin{1},'Rxn'))
                rxnToCheck = varargin{1};
                hasRxn = obj.listOfReacRxn.contains(rxnToCheck) ...
                    || obj.listOfProdRxn.contains(rxnToCheck);
            elseif(isa(varargin{1},'Species'))
                Dest =  varargin{1};
                hasRxn = isempty(findRxn(obj,Dest));
            else
                errorReport(mfilename,'IncorrectInputType');
            end
        end
        
        function isRxnRemoved = removeRxn(obj,rxnToRemove)
            % REMOVERXN remove the reaction from the property "listOfReacRxn" or "listOfProdRxn "
            %
            %  STATUS=REMOVERXN(GSPECIES, RXNTOREMOVE) remove the RXN
            %   object RXNTOREMOVE from the "listOfReacRxn" if  GSPECIES
            %   functions as a reactant, or from the "listOfProdRxn" if
            %   GSPECIES functions as a product. If STATUS is true, the
            %   operation is successful. If false, it indicates that the
            %   GSPECIES is not involved in the reaction rxnToRemove
            %
            %  See also Species
            
            % input type check
            if(~isa(rxnToRemove,'Rxn'))
                errorReport(mfilename,'IncorrectInputType');
            end
            
            if(rxnToRemove.getReactant==obj)
                rxnToRemoveLoc = obj.listOfReacRxns.locationsOf(rxnToRemove);
                obj.listOfReacRxns.remove(rxnToRemoveLoc);
                isRxnRemoved = true;
            elseif(rxnToRemove.getProduct==obj)
                rxnToRemoveLoc = obj.listOfProdRxns.locationsOf(rxnToRemove);
                obj.listOfProdRxns.remove(rxnToRemoveLoc);
                isRxnRemoved = true;
            else
                isRxnRemoved = false;
            end
        end
        
        function numReacRxns = getNumReacRxns(obj)
            % GETNUMREACRXNS get the number of reactions in which the species functions as a reactant.
            %
            % See also Species
            numReacRxns = obj.listOfReacRxns.length;
        end
        
        function numProdRxns = getNumProdRxns(obj)
            %  GETNUMPRODRXNS get the number of reactions in which the species functions as a product.
            %
            %  See also Species
            numProdRxns = obj.listOfReacRxns.length;
        end
        
        function isVisited = visited(obj)
            % VISITED set the mark status as visted and return the status
            %
            % See also Species
            markObj(obj);
            isVisited  = obj.mark;
        end
        
        function markObj(obj)
            %  MARKOBJ set the mark status as visted
            %
            %  See also Species
            obj.mark = true;
        end
        
        function clearMark(obj)
            % CLEARMARK set the mark status of Species as NOT visited
            %
            % See also Species
            obj.mark = false;
        end
        
        function clearMarkState(obj)
            % CLEARMARKSTATE set the mark of Species as empty
            %
            % See also Species
            obj.markState = '';
        end
        
        function reacRxns = getReacRxns(obj)
            % GETREACRXNS get a list of reactions where the species functions as a reactant
            %
            % See also Species
            reacRxns = obj.listOfReacRxns;
        end
        
        function prodRxns = getProdRxns(obj)
            % GETPRODRXNS get a list of reactions where the species functions as a product
            %
            % See also Species
            prodRxns = obj.listOfProdRxns;
        end
        
        function reacRxn = getReacRxn(obj,i)
            % GETREACRXN get the ith reaction in the reaction list where the species functions as a reactant
            %
            % See also Species
            reacRxn = obj.listOfReacRxns.get(i);
        end
        
        function prodRxn = getProdRxn(obj,i)
            % GETPRODRXN get the ith reaction in the reaction list where the species functions as a product
            %
            % See also Species
            prodRxn = obj.listOfProdRxns.get(i);
        end
        
        function compartment = getCompartment(obj)
            % GETCOMPARTMENT get the "compartment" property
            %
            %
            %  See also SPECIES
            compartment = obj.compartment;
        end
        
        function setCompartment(obj,compartment)
            % SETCOMPARTMENT set the "compartment" property
            %
            %
            %  See also SPECIES
            obj.compartment = compartment;
        end
        
          function units = getUnits(obj)
            %GETUNITS ge the "units" property
            %
            %
            %  See also SPECIES
            units = obj.units;
        end
        
        function setUnits(obj,units)
            % SETUNITS set the "units" property
            %
            %
            %  See also SPECIES
            obj.units = units;
        end
        
        function name = getName(obj)
            % GETNAME get the "name" property
            %
            %
            %  See also SPECIES
            name = obj.name;
        end
        
        function setName(obj,name)
            % SETNAME set the "name" property
            %
            %
            %  See also SPECIES
            obj.name = name;
        end
        
        function id = getID(obj)
            % GETID get the "id" property
            %
            %
            %  See also SPECIES
            id = obj.id;
        end
        
        function setID(obj,id)
            % SETID set the "id" property
            %
            %
            %  See also SPECIES
            obj.id = id;
        end
        
        function rxnToReturn = findRxn(obj,varargin)
            % FINDRXN search all possible reactions starting from the species as a reactant to form another species
            %
            %  RXFOUND = FINDRXN(GSPECIES1,GSPECIES2) returns a reference to a reaction
            %   where GPSECIES is a reactant and GSPECIES2 is a product.
            %
            %  RXFOUND = FINDRXN(GSPECIES1,RXN) returns a reference to a reaction
            %   where GPSECIES is a reactant in the RXN.
            %
            % See also Species
            
            if(nargin==2)
                if(isa(varargin{1},'Species'))
                    prodToForm = varargin{1};
                    for i=1: length(obj.listOfReacRxns)
                        rxnToCheck = obj.listOfReacRxns.get(i);
                        if(rxnToCheck.getProd==prodToForm)
                            rxnToReturn = rxnToCheck;
                            return;
                        end
                    end
                    rxnToReturn=[];
                    return;
                elseif(isa(varargin{1},'Rxn'))
                    rxnTofind =  varargin{1};
                    if(obj.listOfReacRxns.contatins(rxnTofind))
                        rxnToReturn =    rxnTofind;
                        return;
                    else
                        rxnToReturn = [];
                    end
                end
            end
        end
        
        function costToFormDest = cost(obj,Dest)
            %  COST find a cost function for a path starting from a species to another species.
            %
            %  See also Species
            
            if(Dest==obj)
                costToFormDest = 0;
                return
            end
            
            rxnToFormDest = findRxn(Dest);
            if(isempty(rxnToFormDest))
                costToFormDest = rxnToFormDest;
            end
        end
    end
    
    methods
        function new = clone(obj)
            %CLONE deep copy a Species object
            %  CLONE(SPECIESOBJ) creates a new Species object
            %
            %  See also PECIES
            
            % Instantiate new object of the same class.
            new = feval(class(obj));
            
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                if(isa(obj.(p{i}),'CellArrayList'))
                    obj.(p{i})=CellArrayList();
                elseif(isa(obj.(p{i}),'handle'))
                    new.(p{i}) = obj.(p{i}).clone;
                else
                    new.(p{i}) = obj.(p{i});
                end
            end
        end
    end
    
end
