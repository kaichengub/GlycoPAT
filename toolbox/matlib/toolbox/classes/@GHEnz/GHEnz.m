classdef GHEnz < HLEnz
    %GHENZ class representing a glycosyl hydrolase enzyme
    % A GHENZ object is a generic representation of a glycosyl hydrolase.
    %  It consists of a list of glycosyl hydrolase properties including residue
    %   functional group  etc.
    %
    % GHENZ properties:
    %  name                - accepted name
    %  systname            - systematic name
    %  othernames          - alternative name(s)
    %  ecno                - enzyme commission number
    %  reaction            - the reaction that the enzyme catalyzes
    %  substrate           - substrate enzyme acts
    %  bond                - bond enzyme breaks
    %  hlprod1_h           - product 1 with hydrogen
    %  hlprod2_oh          - product 2 with hydroxy group
    %  resfuncgroup        - residue of functional group removed from the substrate
    %  resAtt2FG           - residue attaching to functional group
    %  linkFG              - linkage between functional group and attaching residue
    %  linkresAtt2FG       - linkage between attaching residue and its next neighbouring residue
    %  substMinStruct      - minimal structure of substrate that enzyme can act on
    %  substMaxStruct      - maximal structure of substrate that enzyme can act on
    %  prodMinStruct       - minimal structure of product that enzyme can transform substrate into
    %  prodMaxStruct       - maximal structure of product that enzyme can transform substrate into
    %  substNABranch       - branch not allowed in substrate
    %  substNAStruct       - structure of substrate not allowed 
    %  substNAResidue      - residue not allowed in substrate
    %  targetBranch        - targeting branch that enzyme acts on
    %  targetNABranch      - targeting branch that enzyme will not act on
    %  isTerminalTarget    - if the enzyme acts on terminal only
    %  glycanTypeSpec      - type of glycan structures that enzyme act on
    %  targetBranchContain - subset structure of target branch that enzyme acts on
    %
    % GHENZ methods:
    %  GHENZ              - create an GHENZ object
    %  dispAttachResLink   - display attaching residue and its linkage info.
    %  dispFuncResLink     - display functional group residue and its linkage info.
    %  clone               - copy an GHENZ object
    %
    %  Example: create a GHEnz object of
    %         manii              = GHEnz([3;2;1;114]);
    %         residueMap         = load('residueTypes.mat');
    %         manii.resfuncgroup = residueMap.allresidues('Man');
    %
    % See also GTEnz, Enz, PATHWAY, RXN, COMPT, GLYCANSPECIES.
    
    % Author: Gang Liu
    % Date Last Updated: 6/11/2013
    
    properties
        %resAtt2FG the residue in the acceptor that enzyme acts upon
        %  resAtt2FG property is a ResidueType object.
        %    
        % See also GHlEnz
        resAtt2FG
    end 

    properties
        %LINKFG enzyme linkage specificity
        %  linkFG property is a structure containing two fields:anomer and
        %     bond
        %
        %  See also GHlEnz
        linkFG
    end
    
    properties
        %linkResAtt2FG enzyme linkage specificity
        %  linkResAtt2FG property is a structure containing two fields:anomer and
        %     bond
        %
        %  See also GHlEnz
        linkresAtt2FG 
    end
    
    properties
        % prodMinStruct product minimal structure
        %     prodMinStruct property is a GlycanStruct object
        %
        %  See also GHlEnz
        prodMinStruct
    end
    
    properties
        % prodMaxStruct product maximal structure
        %     prodMaxStruct property is a GlycanStruct object
        %
        %  See also GHlEnz
        prodMaxStruct
    end
    
    
    properties
        % substMinStruct substrate minimal structure
        %     substMinStruct property is a GlycanStruct object
        %
        %  See also GHlEnz
        substMinStruct
    end
    
    properties
        % substMaxStruct substrate minimal structure
        %     substMaxStruct property is a GlycanStruct object
        %
        %  See also GHlEnz
        substMaxStruct
    end
    
    properties
        % substNABranch the branch structure substate should not have
        %     substNABranch property is a GlycanStruct object
        %
        %  See also GHlEnz
        substNABranch
    end
    
    properties
        %substNAStruct not allowed structure for the substrate
        %  substNAStruct property is a GlycanStruct object
        %
        %  See also GHlEnz
        substNAStruct
    end
    
    properties
        %substNAResidue not allowed sugar residue for the substrate
        %     substNAResidue property is a ResidueType object
        %
        % See also GHlEnz
        substNAResidue
    end
    
    properties
        %targetNABranch not allowed target branch in the substrate
        % for enzyme to act on targetNABranch property is a ResidueType object
        %
        %  See also GHlEnz
        targetNABranch
    end  
    
    properties
        % glycanTypeSpec the substrate group enzyme can act on 
        %    glycanTypeSpec property is a string character describing the
        %    type of glycan structure (e.g.N-linked glycan, O-linked
        %    glycan)
        %    
        % See also GHlEnz
        glycanTypeSpec
    end    
    
    properties
         % targetBranch the branch enzyme can act on 
        %    targetBranch property is a GlycanStruct object describing the
        %     branching linking to the freeEnd residue
        %    
        %  See also GHlEnz
        targetBranch;
    end
    
    properties
        %isTerminalTarget returns true if the enzyme acts on terminal only 
        %    isTerminalTarget property is a logical value
        %    
        %  See also GHlEnz
        isTerminalTarget;
    end
    
    properties
        %targetbranchcontain the subset structure necessary in target branch
        % that enzyme acts on.
        %   targetbranchcontain property is a logical value
        %    
        % See also GHlEnz
        targetbranchcontain;
    end
    
     methods (Static)
        function ghenzobj = loadmat(matfilename)
            ghenzstruct = load(matfilename);
            p = fieldnames(ghenzstruct);
            if(length(p)~=1)
                error('MATLAB:GNAT:WRONGINPUT','wrong variable stored');
            end
            ghenzobj = ghenzstruct.(p{1});
            if(isa(ghenzobj,'GHEnz'))
                % Copy all non-hidden properties.
                enzprop = properties(ghenzobj);
                for i = 1:length(enzprop)
                    if(isa(ghenzobj.(enzprop{i}),'CellArrayList'))
                        for j = 1 : ghenzobj.(enzprop{i}).length
                            if(isa(ghenzobj.(enzprop{i}).get(j),'GlycanStruct'))
                                ghenzobj.(enzprop{i}).get(j).resetjava;
                            end
                        end
                    elseif(isa(ghenzobj.(enzprop{i}),'GlycanStruct'))
                        ghenzobj.(enzprop{i}).resetjava;
                    end
                end
            else
                error('MATLAB:GNAT:WRONGINPUT','wrong variable stored');
            end
            
        end
    end
    
    methods
        function obj = GHEnz(varargin)
            %GHEnz create a GHEnz object.
            %
            %  L = GHEnz(ecno) creates a GH Enzyme object
            %
            %  See also GHlEnz.
            obj.ecnopre_disp='ec3.2';
            obj.familyname = 'glycosyl hydrolase';
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
            
            if(nargin==2)
                obj.funcgroup =varargin{2};
            end
        end % end constructor
    end
    
    methods
        function resVec = dispFuncResLink(obj)
            % dispFuncResLink get substrate terminal specificity for the enzyme
            %
            %  See also GHlENZ
            if( isprop(obj,'resfuncgroup') && (~isempty(obj.resfuncgroup) )&&...
                isprop(obj,'linkFG') && (~isempty(obj.linkFG)) )
                sugarbond = obj.linkFG.bond;
                resVec=cell(1,length(sugarbond));
                for i=1:length(sugarbond);
                     res = obj.resfuncgroup.name;
                     res = strcat(res,'{');
                     res = strcat(res,obj.linkFG.anomer);
                     res = strcat(res,'}');
                     res = strcat(res,sugarbond(i,1).disp);
                     resVec{1,i}=res;
                end
            else
                resVec='';
            end
        end % end
        
        function res = dispAttachResLink(obj)
            % dispNextResidue get residue next to terminal residue target for the enzyme
            %
            %  See also GHlENZ
           if( isprop(obj,'resAtt2FG') && ~isempty(obj.resAtt2FG) &&...
                isprop(obj,'linkresAtt2FG') && ~isempty(obj.linkresAtt2FG))
                res = obj.resAtt2FG.name;
                res = strcat(res,'{');
                res = strcat(res,obj.linkresAtt2FG.anomer);
                res = strcat(res,'}');
                res = strcat(res,obj.linkresAtt2FG.bond.disp);
           else
                res='';
           end
        end
        
        
        function new = clone(obj)
            %CLONE copy an GHlENZ object
            %  clone(ENZobj) creates a new GHlENZ object
            %
            %  See also GHlENZ
            
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

