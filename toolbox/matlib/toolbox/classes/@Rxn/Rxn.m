classdef Rxn  < handle
    %Rxn class representing a chemical reaction in the glycosylation 
    % reaction network
    %
    % A Rxn object is a generic representation of a glycosylation reaction.
    %  It consists of an enzyme, a reactant and a product.
    %
    % Rxn properties:
    %  reac               -  the reactant in the reaction, i.e, acceptor
    %  prod              -  the product in the reaction
    %  donor            -  the glycosyl donor
    %  enz                 -  the catalytic enzyme
    %  name             -  the name of the reaction
    %  mark              -  if the reaction is visited
    %  markState      -  if visited, the status of the mark
    %  cost                -  a cost to form the product from the reactant
    %
    % Rxn methods:
    %  RXN                  -  create a Rxn object
    %  getReactant     -  retrieve the "reactant" property
    %  getProduct      -  retrieve the "product" property
    %  getDonor         -  retrieve the "donor" property
    %  getEnzyme      -  retrieve the "enzyme" property
    %  getName         -  retrieve the "name" property
    %  getCost            -  retrieve the "cost" property
    %  setReactant     -  set the "reactant" property
    %  setProduct      -  set the "product" property
    %  setDonor         -  set the "donor" property
    %  setEnzyme      -  set the "enzyme" property
    %  setName         -  set the "name" property
    %  setCost            -  set the "cost" property
    %  setMark           -  set the "mark" property as true
    %  clearMark        -  set the "mark" property as false
    %  isMarked         -  return the "mark" property
    %  clone                - copy a Rxn object
    %
    % See also Pathway,GlycanSpecies,Compt,Enz.
    
    % Author: Gang Liu
    % Date Lastly Updated 9/20/13
    
    properties
    %REAC a reactant in the glycosylation reaction
    % REAC property is a GlycanSpecies object
    %
    %
    %See also Rxn
       reac
    end
    
    properties
    %PROD a product in the glycosylaiton reaction
    % PROD property is a GlycanSpecies object
    %
    %See also Rxn
       prod
    end
    
    properties
    %DONOR a glycosyl donor in the reaction
    % DONOR property is a GlycanSpecies object
    %
    %See also Rxn
       donor
    end
    
    properties
    %ENZ a glycosyltransferase in the reaction
    % ENZ property is a ENZ object
    %
    %See also Rxn
       enz
    end
    
    properties
    %COST a cost to form the product from the reactant
    % COST property is a numeric scalar.
    %
    %See also Rxn
        cost   % for graph structure purpose
    end
    
    properties
    %MARK the status if the reaction is visited
    % MARK property is a logical scalar
    %
    %See also Rxn
        mark  % for graph structure purpose
    end
    
    properties
    %MARKSTATE the state of the mark if visisted
    % MARKSTATE property is a character array
    %
    %See also Rxn
        markState  % for graph structure purpose
    end
    
    properties
    %NAME name of the reaction
    % NAME property is a character arrray
    %
    %See also Rxn
        name
    end
    
     methods (Static)
        function rxnobj=loadmat(matfilename)
            rxnstruct=load(matfilename);
            p = fieldnames(rxnstruct);
            if(length(p)~=1)
                 error('MATLAB:GNAT:WRONGINPUT','wrong variable stored');
            end
            rxnobj = rxnstruct.(p{1});
            if(isa(rxnobj,'Rxn'))
               rxnobj.resetjava;
            else
               error('MATLAB:GNAT:WRONGINPUT','wrong variable stored');
            end
        end
    end
    
    methods
        function resetjava(obj)
            
            if ~(isempty(obj.getReactant))
                obj.getReactant.glycanStruct.resetjava;
            end
            
            if ~(isempty(obj.getProduct))
                obj.getProduct.glycanStruct.resetjava; 
            end
            
        end
    end
    
    methods
        function obj = Rxn(varargin)
        %Rxn create a Rxn object.
        %
        % GR  = Rxn(REACTANT,PRODUCT) creates a Rxn object with its
        %  acceptor REACTANT and the product PRODUCT.
        %
        % GR  = Rxn(REACTANT,PRODUCT,ENZYME) creates a Rxn object with its
        %  acceptor REACTANT, the product PRODUCT and its catalytic
        %  enzyme ENZYME.
        %
        % GR  = Rxn(REACTANT,PRODUCT,ENZYME,COST) specifies the cost of PRODUCT formation
        %  from REACTANT using Enzyme.
        %
        % See also GlycanStruct,Compt,Pathway,GlycanNetModel.
            
            %input number check
            % validate the number of input arguments
%             if(~verLessThan('matlab','7.13'))
%                 narginchk(0,5);
%             else
                error(nargchk(0,5,nargin));
%             end
            
            if (nargin == 0)
                obj.name    = 'empty';
            elseif(nargin==1)
                errorReport(mfilename,'IncorrectInputNumber');
            elseif(nargin==2)
                if(isa(varargin{1},'GlycanSpecies') || isa( varargin{2},'GlycanSpecies'))
                    obj.reac  =  varargin{1};
                    obj.prod =  varargin{2};
                    obj.cost =  0;
                else
                    errorReport(mfilename,'IncorrectInputType');
                end
            elseif(nargin==3)
                if(isa(varargin{2},'GlycanSpecies') && isa( varargin{2},'GlycanSpecies')...
                        &&isa(varargin{3},'Enz'))
                    obj.reac   = varargin{1};
                    obj.prod  =  varargin{2};
                    obj.enz    =  varargin{3};
                    obj.cost  =  0;
                elseif     ( (  isa(varargin{1},'GlycanSpecies') ||  isa(varargin{2},'GlycanSpecies') )...
                        &&isa(varargin{3},'char'))
                    obj.reac      =  varargin{1};
                    obj.prod      =  varargin{2};
                    obj.name    =  varargin{3};
                    obj.cost  =  0;
                else
                    fprintf(1,'%i %i  %i ',isa(varargin{2},'GlycanSpecies'),isa(varargin{2},'GlycanSpecies'),isa(varargin{3},'char'));
                    errorReport(mfilename,'IncorrectInputType');
                end
            elseif(nargin==4)
                if(isa( varargin{2},'GlycanSpecies') && isa( varargin{2},'GlycanSpecies')...
                        &&isa( varargin{3},'Enz') &&isa( varargin{4},'double'))
                    obj.reac  =  varargin{1};
                    obj.prod  =  varargin{2};
                    obj.enz    =  varargin{3};
                    obj.cost   =  varargin{4};
                else
                    errorReport(mfilename,'IncorrectInputType');
                end
            end
        end % end constructor
    end
    
    methods
        function prodToForm = getProduct(obj)
            % getProduct get the prodcut of the reaction
            %
            % See also Rxn
            prodToForm = obj.prod;
        end
        
        function setProduct(obj,prodToForm)
            % setProduct set the prodcut of the reaction
            %
            % See also Rxn
            obj.prod = prodToForm ;
        end
        
        function reacToAct = getReactant(obj)
            % getReactant get the reactant of the reaction
            %
            % See also Rxn
            reacToAct = obj.reac;
        end
        
        function setReactant(obj,reacToAct )
            % setReactant set the reactant of the reaction
            %
            % See also Rxn
            obj.reac = reacToAct;
        end
        
        function enzToFind = getEnzyme(obj)
            % getEnzyme get the enzyme of the reaction
            %
            % See also Rxn
            enzToFind = obj.enz;
        end
        
        function setEnzyme(obj,enzToSet)
            % setEnzyme set the enzyme of the reaction
            %
            % See also Rxn
            obj.enz = enzToSet;
        end
        
        function donor = getDonor(obj)
            % getDonor get the donor of the reaction
            %
            % See also Rxn
            donor = obj.donor;
        end
        
        function setDonor(obj,donor)
            % setDonor set the donor of the reaction
            %
            % See also Rxn
            obj.donor = donor;
        end
        
        function name = getName(obj)
            % getName get the name of the reaction
            %
            % See also Rxn
            name = obj.name;
        end
        
        function setName(obj,name)
            % setName set the name of the reaction
            %
            % See also Rxn
            obj.name = name;
        end
        
        function costOfRxn = getCost(obj)
            % getCost get the cost of the reaction
            %
            % See also Rxn
            costOfRxn = obj.cost;
        end
        
        function  setCost(obj,costOfRxn)
            % setCost set the cost of the reaction
            %
            % See also Rxn
            obj.cost = costOfRxn;
        end
        
        function setMark(obj)
            % setMark set the reaction "visited"
            %
            % See also Rxn
            obj.mark = true;
        end
        
        function clearMark(obj)
            % clearMark set the reaction "NOT visited"
            %
            % See also Rxn
            obj.mark = false;
        end
        
        function markStatus = isMarked(obj)
            % isMarked return true if the reaction is "visted"
            %
            % See also Rxn
            markStatus=obj.mark;
        end
    end
    
    methods
        toNameStr = toString(obj);
    end
    
    methods
        function new = clone(obj)
            %CLONE copy a Rxn object
            %  clone(RXNobj) creates a new RXN object
            %
            %  See also RXN
            
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


