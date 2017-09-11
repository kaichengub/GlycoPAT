classdef GTEnz  <  TFEnz
    %GTENZ class representing a GlycosylTranferase(GT) enzyme
    %
    % A GTENZ object is a generic representation of a glycosyltranferase enzyme.
    %  It consists of a list of properties and methods as below.
    %
    % GTENZ properties:
    %  name                - accepted name
    %  systname            - systematic name
    %  othernames          - alternative name(s)
    %  ecno                - enzyme commission number
    %  reaction            - the reaction that the enzyme catalyzes
    %  organism            - the species where the enzyme is expressed
    %  compartment         - the enzyme location
    %  donor               - the donor containing functional group transferred
    %  acceptor            - the substrate enzyme catalyzed
    %  donorprod           - the product that the donor transforms into
    %  acceptorprod        - the product that the acceptor transforms into
    %  resfuncgroup        - residue of functional group transferred
    %  resAtt2FG           - residue attaching to functional group
    %  linkFG              - linkage between functional group and attaching residue
    %  linkresAtt2FG       - linkage between attaching residue and its next neighbouring residue
    %  substMinStruct      - minimal structure of substrate that enzyme can act on
    %  substMaxStruct      - maximal structure of substrate that enzyme can act on
    %  substNABranch       - substrate branch that is not allowed
    %  substNAStruct       - substrate structure that is not allowed
    %  substNAResidue      - any residue taht is not allowed in substrate
    %  targetBranch        - targeting branch that enzyme acts on
    %  targetNABranch      - targeting branch that enzyme will not act on
    %  isTerminalTarget    - if the enzyme acts on terminal residue only
    %  glycanTypeSpec      - type of glycan structures that enzyme act on
    %  targetBranchContain - subset structure of target branch that enzyme acts on
    %
    % GTEnz methods:
    %  GTEnz               - create a GTENZ object
    %  clone               - copy a GTENZ object
    %  dispAttachResLink   - display residue type and linkage info. of residue attaching to functional group
    %  dispFuncResLink     - display functional group residue and linkage info.
    %
    %
    % Examples:
    %  Example 1: create a GTEnz object of D-xylose transferase
    %            xyloTF = GTEnz([2;4;2;26]);
    %            residueMap = load('residueTypes.mat');
    %            xyloTF.resfuncgroup = residueMap.allresidues('Xyl');
    %
    %  Example 2: create a GTEnz object of N-acetylglucosaminyltransferase II
    %            mgat2 = GTEnz([2;4;1;143]);
    %            residueMap = load('residueTypes.mat');
    %            mgat2.resfuncgroup = residueMap.allresidues('GlcNAc');
    %
    % See also TFEnz, HLEnz, Enz, PATHWAY, RXN, COMPT, GLYCANSPECIES.
    
    % Author: Gang Liu
    % Date Lastly Updated: 8/2/13
    
    properties
        %resAtt2FG the residue in the acceptor that enzyme acts upon
        %  resAtt2FG property is a ResidueType object.
        %
        % See also GTENZ
        resAtt2FG
    end
    
    properties
        %LINKFG enzyme linkage specificity
        %  linkFG property is a structure containing two fields:anomer and
        %     bond
        %
        %  See also GTENZ
        linkFG
    end
    
    properties
        %linkResAtt2FG enzyme linkage specificity
        %  linkResAtt2FG property is a structure containing two fields:anomer and
        %     bond
        %
        %  See also GTENZ
        linkresAtt2FG
    end
    
    properties
        % substMinStruct substrate minimal structure
        %     substMinStruct property is a GlycanStruct object
        %
        %  See also GTENZ
        substMinStruct
    end
    
    properties
        % substMaxStruct substrate minimal structure
        %     substMaxStruct property is a GlycanStruct object
        %
        %  See also GTENZ
        substMaxStruct
    end
    
    properties
        % substNABranch the branch structure substate should not have
        %     substNABranch property is a GlycanStruct object
        %
        %  See also GTENZ
        substNABranch
    end
    
    properties
        %substNAStruct not allowed structure for the substrate
        %  substNAStruct property is a GlycanStruct object
        %
        %  See also GTENZ
        substNAStruct
    end
    
    properties
        %substNAResidue not allowed sugar residue for the substrate
        %     substNAResidue property is a ResidueType object
        %
        % See also GTENZ
        substNAResidue
    end
    
    properties
        %targetNABranch not allowed target branch in the substrate
        % for enzyme to act on targetNABranch property is a ResidueType object
        %
        %  See also GTENZ
        targetNABranch
    end
    
    
    
    properties
        % glycanTypeSpec the substrate group enzyme can act on
        %    glycanTypeSpec property is a string character describing the
        %    type of glycan structure (e.g.N-linked glycan, O-linked
        %    glycan)
        %
        % See also GTENZ
        glycanTypeSpec
    end
    
    properties
        % targetBranch the branch enzyme can act on
        %    targetBranch property is a GlycanStruct object describing the
        %     branching linking to the freeEnd residue
        %
        %  See also GTENZ
        targetBranch;
    end
    
    properties
        %isTerminalTarget returns true if the enzyme acts on terminal only
        %    isTerminalTarget property is a logical value
        %
        %  See also GTENZ
        isTerminalTarget;
    end
    
    properties
        %targetbranchcontain the subset structure necessary in target branch
        % that enzyme acts on.
        %   targetbranchcontain property is a logical value
        %
        % See also GTENZ
        targetbranchcontain;
    end
    
    methods
        function obj = GTEnz(varargin)
            %GTENZ create a GTENZ object.
            %
            % L = GTENZ(ecno) creates a GT Enzyme object
            %
            %See also Reaction.
            obj.ecnopre_disp='ec2.4';
            obj.familyname = 'glycosyltransferases';
            if (nargin == 0)
                obj.ecno=[];
                return
            end
            
            obj.ecno    =  varargin{1};
            try
                queryEnzRes= queryIUBMBDB(obj.ecno);
                obj.name = queryEnzRes.name ;
                obj.systname = queryEnzRes.systname;
                obj.othernames = queryEnzRes.othernames;
                obj.reaction = queryEnzRes.rxn;
            catch error
                % do nothing
                % keep the field empty
                
            end
            
            % assign donor, acceptor, donor prod, acceptor prod to each
            % field
            numPlus = length(strfind(obj.reaction,'+'));
            numEqual = length(strfind(obj.reaction,'='));
            if((numPlus==2)&&(numEqual==1))
                speciesnames =regexp(obj.reaction,'(?<names>[\S->]+)','names');
                obj.donor = speciesnames(1,1).names;
                obj.acceptor = speciesnames(1,3).names;
                obj.donorProd = speciesnames(1,5).names;
                obj.acceptorProd = speciesnames(1,7).names;
            end
            
        end % end constructor
    end
    
    methods
        function res = dispAttachResLink(obj)
            % dispAttachResLink get residue type and linkage specificity on
            %  acceptor residue attaching to the functional group
            %
            % See also GTENZ.
            if( isprop(obj,'resAtt2FG') && ~isempty(obj.resAtt2FG) &&...
                    isprop(obj,'linkresAtt2FG') && ~isempty(obj.linkresAtt2FG))
                res = obj.resAtt2FG.name;
                res = strcat(res,'{');
                res = strcat(res,obj.linkresAtt2FG.anomer);
                res = strcat(res,'}');
                res = strcat(res,obj.linkresAtt2FG.bond.disp);
            else
                res ='';
            end
        end % end
        
        function res = dispFuncResLink(obj)
            %dispFuncResLink get functional group and linkage specificity
            %  for the enzyme
            %
            % See also GTENZ
            if( isprop(obj,'resfuncgroup') && ~isempty(obj.resfuncgroup) &&...
                    isprop(obj,'linkFG') && ~isempty(obj.linkFG))
                res = obj.resfuncgroup.name;
                res = strcat(res,'{');
                res = strcat(res,obj.linkFG.anomer);
                res = strcat(res,'}');
                res = strcat(res,obj.linkFG.bond.disp);
            else
                res ='';
            end
        end % end
    end
    
    methods (Static)
        function gtenzobj = loadmat(matfilename)
            gtenzstruct = load(matfilename);
            p = fieldnames(gtenzstruct);
            if(length(p)~=1)
                error('MATLAB:GNAT:WRONGINPUT','wrong variable stored');
            end
            gtenzobj = gtenzstruct.(p{1});
            if(isa(gtenzobj,'GTEnz'))
                % Copy all non-hidden properties.
                enzprop = properties(gtenzobj);
                for i = 1:length(enzprop)
                    if(isa(gtenzobj.(enzprop{i}),'CellArrayList'))
                        for j = 1 : gtenzobj.(enzprop{i}).length
                            if(isa(gtenzobj.(enzprop{i}).get(j),'GlycanStruct'))
                                gtenzobj.(enzprop{i}).get(j).resetjava;
                            end
                        end
                    elseif(isa(gtenzobj.(enzprop{i}),'GlycanStruct'))
                        gtenzobj.(enzprop{i}).resetjava;
                    end
                end
            else
                error('MATLAB:GNAT:WRONGINPUT','wrong variable stored');
            end
            
        end
    end
    
    
    methods
        function new = clone(obj)
            %CLONE copy an GTEnz object
            %  clone(ENZobj) creates a new ENZ object
            %
            %  See also GTENZ
            
            % Instantiate new object of the same class.
            new = feval(class(obj));
            
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                if(isa(obj.(p{i}),'handle'))
                    if(isa(obj.(p{i}),'CellArrayList'))
                        new.(p{i})=CellArrayList;
                        for j = 1 : obj.(p{i}).length
                            new.(p{i}).add(obj.(p{i}).get(j))
                        end
                    else
                        new.(p{i}) = obj.(p{i}).clone;
                    end
                else
                    new.(p{i}) = obj.(p{i});
                end
            end
        end
    end
    
    
end
