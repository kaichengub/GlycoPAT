classdef TFEnz < Enz
    %TFENZ class representing a transferase enzyme
    %
    % A TFENZ object is a generic representation of a transferase.
    %  It consists of a list of transferase properties including donor,
    %   acceptor, functional group transferred, donor product, and acceptor
    %   product.
    %
    % TFENZ properties :
    %  donor            - the donor containing functional group transferred
    %  acceptor         - the substrate enzyme catalyzed
    %  funcgroup        - functional group transferred
    %  donorprod        - the product that the donor transforms into
    %  acceptorprod     - the product that the acceptor transforms into
    %
    % See also PATHWAY, RXN, COMPT, GLYCANSPECIES.
    
    % Author: Gang Liu
    % Date Last Updated: 12/24/2013
    
    properties
        %DONOR the donar sugar for the enzyme-catalyzed reaction
        %     DONOR property is a sugarSpecies array.
        %
        %  See also TFENZ
        donor
    end
    
    properties
        %DONORPROD the donor product for the enzyme-catalyzed reaction
        %     DONORPROD property is a sugarNucSpecies array.
        %
        %  See also TFENZ
        donorProd
    end
    
    properties
        %ACCEPTOR the acceptor for the enzyme-catalyzed reaction
        %     ACCEPTOR property is a GlycanStruct object.
        %
        %  See also TFENZ
        acceptor
    end
    
    properties
        %ACCEPTORPROD the acceptor product for the enzyme-catalyzed reaction
        %     ACCEPTORPROD property is a GlycanStruct object.
        %
        %  See also TFENZ
        acceptorProd
    end
    
    properties
        %resfuncgroup the functional glycosyl group for the enzyme-catalyzed reaction
        %     resfuncgroup property is a ResidueType object.
        %
        %  See also TFENZ
        resfuncgroup
    end
    
    methods
        function obj=TFEnz(varargin)
            narginchk(0,3);
            
            if(nargin==0)
                obj.ecno=[2;0;0;0];
                return;
            end
            
            if(nargin==3)
                obj.donor = varargin{1};
                obj.acceptor = varargin{2};
                obj.resfuncgroup = varargin{3};
            else
                error('MATLAB:GEAT:WrongInput','Wrong Input Number');
            end
            
            if(nargin==1)
                obj.ecno = varargin{1};
            end
            
            if(isprop(obj,'ecno')&&(~isempty(obj.ecno)))
                try
                    queryEnzRes    = queryIUBMBDB(obj.ecno);
                    obj.name       = queryEnzRes.name ;
                    obj.systname   = queryEnzRes.systname;
                    obj.othernames = queryEnzRes.othernames;
                    obj.reaction   = queryEnzRes.rxn;
                catch err
                    % do nothing
                    % keep the field empty
                    
                end
            end
            
        end
    end
    
    % final value
    properties
        %ecnopre_disp enzyme ECNO prefix
        %     ecnopre_disp property is a character array.
        %
        %  See also TFENZ
        ecnopre_disp='ec2';
        
        %familyname enzyme family class
        %     familyname property is a character array.
        %
        %  See also TFENZ
        familyname ='transferases';
    end
    
end

