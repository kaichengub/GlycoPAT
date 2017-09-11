function varargout=inferGlySubstr(prodObj,enzObj)
% inferGlySubstr infer the substrate based on the enzyme and product.
%
%  [numSubstr,substrSpecies] = inferGlySubstr(prodObj,enz) infers
%   the substrate if the enzyme acts on the substrate to form the product
%   . If no substrate is  found, numSubstr is equal to zero and substrSpecies
%   is empty.  If more  than one substrates are found, they are stored in
%   a CellArrayList object substrSpecies.
%
%  [numSubstr,substrSpecies,rxns] = inferGlySubstr(prodObj,enz)
%   returns a list of reactions (a CellArrayList object rxns) if the enzyme acts
%   to form the product. If no substrate is found, rxns returns as an empty 
%   CellArrayList object.
%
%  [numSubstr,substrSpecies,rxns,pathway] = inferGlySubstr(prodObj,enz)
%   returns the pathway  if the enzyme acts to form the product prodObj. If
%   no substrate  is found, pathway is set empty.
%
%      Example 1:
%            mani  =GHEnz.loadmat('mani.mat');
%            m8species  = GlycanSpecies(glycanMLread('M8.glycoct_xml'));
%            [nsubstr, m9species] = inferGlySubstr(m8species,mani);
%            options  = displayset('showmass',true,'showLinkage',true,...
%                             'showRedEnd',true);
%            for i = 1: nsubstr
%                glycanViewer(m9species.get(i).glycanStruct,options);
%            end
%   
%      Example 2:
%             mani  =GHEnz.loadmat('mani.mat');
%            m8species  = GlycanSpecies(glycanMLread('M8.glycoct_xml'));
%            [nsubstr, m9species,m8rxns] = inferGlySubstr(m8species,mani);
%            for i = 1: nsubstr
%               glycanRxnViewer(m8rxns.get(i));
%            end 
%     
%      Example 3:
%            mani  =GHEnz.loadmat('mani.mat');
%            m8species  = GlycanSpecies(glycanMLread('M8.glycoct_xml'));
%            [nsubstr, m9species,m8rxns,m8pathway] = inferGlySubstr(m8species,mani);
%            glycanPathViewer(m8pathway);          
% 
% See also inferGlyProd,inferGlyRevrPath.

% Author: Gang Liu
% Date Last Updated: 8/2/13
narginchk(2,2);
nargoutchk(1,4);

if(isa(prodObj,'GlycanSpecies'))
    glycanObj =  prodObj.glycanStruct;
else
    error('MATLAB:GNAT:WrongInput','Input Wrong Type');
end

if(isa(enzObj,'GTEnz'));
    enzFuncToAdd=1;
    numTermRes  =  length(glycanObj.getNonRedEndResidue);
elseif(isa(enzObj,'GHEnz'))
    enzFuncToAdd=0;
    numAllRes  =  length(glycanObj.getAllResidues);
else
    enzFuncToAdd=1;
end

numSubstr=0;
substrSpecies=CellArrayList;
rxns=CellArrayList;
path=Pathway;

isSubstrValid = true;

% rule 1: N-, O-, glycolipids
if(isprop(enzObj,'glycanTypeSpec')&&(~isempty(enzObj.glycanTypeSpec)))
    requirement   = enzObj.glycanTypeSpec;
    acceptortype  = glycanObj.glycanTypeSpec;
    isSubstrValid   = isequal(acceptortype,requirement);
end

isPathUpdated = false;
if(isSubstrValid)
    if(enzFuncToAdd)      % remove the residue from terminal
        for i = 1 :numTermRes
            glycanSubstrObj = glycanObj;
            nreResidues         = glycanSubstrObj.getNonRedEndResidue;
            nreResidue          = nreResidues{1,i};
            
            % rule 3: terminal residue must be function group defined in the
            % enzyme obj
            requirement  = enzObj.dispFuncResLink;
            terminalInfo    = nreResidue.dispResidueInfo;
            isValidRxnPos  = isequal(terminalInfo,requirement);
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 4: if the the substrate should target the terminal residue
            if( isprop(enzObj,'isTerminalTarget')&& ~isempty(enzObj.isTerminalTarget))
                if(enzObj.isTerminalTarget)
                    if( isprop(nreResidue.getParent,'linkageChildren')&& ...
                            length(nreResidue.getParent.linkageChildren)==1);
                        isValidRxnPos = true;
                    else
                        isValidRxnPos = false;
                    end
                else
                    isValidRxnPos = true;
                    
                    %                 else
                    %                     if( isprop(residue,'linkageChildren')&& isempty(nreResidue.getParent.linkageChildren));
                    %                         isValidRxnPos = false;
                    %                     else
                    %                         isValidRxnPos = true;
                    %                     end
                end
            else
                isValidRxnPos = true;
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 5:resiude next to terminal residue is the same as
            % acceptorResidue
            requirement            = enzObj.dispAttachResLink;
            nexterminalResidue = nreResidue.getParent;
            if(~isempty(nexterminalResidue))
                acceptorTerminal     = nexterminalResidue.dispResidueInfo;
            else
                acceptorTerminal    = [];
            end
            
            isexactmatch = isempty(strfind(requirement,'?'));
            if(isexactmatch)
                isValidRxnPos = isequal(acceptorTerminal,requirement);
            elseif(numel(acceptorTerminal)==numel(requirement));
                quotaindex =  strfind(requirement,'?');
                requirement(quotaindex)='';
                acceptorTerminal(quotaindex)='';
                isValidRxnPos = isequal(acceptorTerminal,requirement);
            else
                isValidRxnPos = false;
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 6: the product should not be greater than the specified structure
            if( isprop(enzObj,'prodMinStruct')&& ~isempty(enzObj.prodMinStruct))
                isValidRxnPos = isValidRxnPos &&glycanSubstrObj.contains(enzObj.prodMinStruct);
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 7: the enzyme should not work on the children of specificed structure
            if( isprop(enzObj,'prodMaxStruct')&& ~isempty(enzObj.prodMaxStruct))
                isValidRxnPos = isValidRxnPos &&enzObj.prodMaxStruct.contains(glycanSubstrObj);
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 8: the enzyme should transfer the residue to the target branch
            if(isprop(enzObj,'targetBranch')&&(~isempty(enzObj.targetBranch)))  % if the rule exists
                chartargetbranch =enzObj.targetBranch.name;
                charresidue           = glycanSubstrObj.getresiduetoroot(nreResidue.getParent);
                isValidRxnPos        = isValidRxnPos && (strcmp(chartargetbranch,charresidue));
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 9: the enzyme should not transfer the residue to the target branch containing
            % specified structure
            if(isprop(enzObj,'targetbranchcontain')&&(~isempty(enzObj.targetbranchcontain)))  % if the rule exists
%                 chartargetbranch = enzObj.targetbranchcontain.name;
%                 chartargetbranch = regexprep(chartargetbranch,'freeEnd--',' ');
%                 chartargetbranch = regexprep(chartargetbranch,'?',' ');
%                 
%                 charresidue= glycanSubstrObj.getresiduetoroot(nreResidue.getParent);
%                 charresidue= regexprep(charresidue,'freeEnd--','');
%                 charresidue= regexprep(charresidue,'?','');
%                 
%                 isValidRxnPos = isValidRxnPos && (~isempty(strfind(strtrim(charresidue),strtrim(chartargetbranch))));
                chartargetbranch = enzObj.targetbranchcontain.name;
                chartargetbranch = regexprep(chartargetbranch,'freeEnd--',' ');
                chartargetbranch = regexprep(chartargetbranch,'?','');

                if(isempty(enzObj.isTerminalTarget))
                    isTerminalTarget = true;
                else
                    isTerminalTarget = enzObj.isTerminalTarget;
                end

                if(~isTerminalTarget)
                    parentresidue = nreResidue.getParent;
                    charresidue   = glycanObj.getresiduetoterminal(parentresidue,nreResidue);
                    charresidue   = regexprep(charresidue,'freeEnd--','');
                    charresidue   = regexprep(charresidue,'?','');

                    isValidRxnPos = isValidRxnPos && (~isempty(strfind(strtrim(charresidue),...
                        strtrim(chartargetbranch))));
                else
                    parentresidue = nreResidue.getParent;
                    charresidue   = glycanObj.getresiduetoroot(parentresidue);
                    charresidue   = regexprep(charresidue,'freeEnd--','');
                    charresidue   = regexprep(charresidue,'?','');

                    isValidRxnPos = isValidRxnPos && (~isempty(strfind(strtrim(charresidue),...
                        strtrim(chartargetbranch))));
                end
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 10: the enzyme should not act on the specificed branch
            if( isprop(enzObj,'targetNABranch')&& ~isempty(enzObj.targetNABranch))  % if the rule exists
                if(isa(enzObj.targetNABranch,'GlycanStruct'))
                    chartargetbranch = enzObj.targetNABranch.name;
                    charresidue           = glycanSubstrObj.getresiduetoroot(nreResidue.getParent);
                    isValidRxnPos       = isValidRxnPos && (~strcmp(chartargetbranch,charresidue));
                elseif(isa(enzObj.targetNABranch,'CellArrayList'))
                    for ii = 1 : length(enzObj.targetNABranch)
                        chartargetbranch = enzObj.targetNABranch.name;
                        charresidue           = glycanSubstrObj.getresiduetoroot(nreResidue.getParent);
                        isValidRxnPos       =  isValidRxnPos && (~strcmp(chartargetbranch,charresidue));
                    end
                end
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            glycanSubstrObj = glycanObj.clone;
            nreResidues           = glycanSubstrObj.getNonRedEndResidue;
            nreResidue          = nreResidues{1,i};
            
            isResidueDeleted = glycanSubstrObj.removeNonRedEndResidue(...
                nreResidue);
            
            %rule 2: It does not contain the specified residue
            if(isprop(enzObj,'substNAResidue')&&(~isempty(enzObj.substNAResidue)))
                NAResiduename = enzObj.substNAResidue.name;
                composition = glycanSubstrObj.getComposition;
                isValidRxnPos  =  ~(isfield(composition,NAResiduename) ...
                    && (composition.(NAResiduename)>=1));
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 11 the substrate should not contain the specificed branch
            if( isprop(enzObj,'substNABranch')&& ~isempty(enzObj.substNABranch))  % if the rule exists
                if(isa(enzObj.substNABranch,'GlycanStruct'))
                    isValidRxnPos = isValidRxnPos && (~glycanSubstrObj.contains(enzObj.substNABranch));
                elseif(isa(enzObj.substNABranch,'CellArrayList'))
                    for ii = 1 : length(enzObj.substNABranch)
                        isValidRxnPos = isValidRxnPos && (~glycanSubstrObj.contains(enzObj.substNABranch.get(ii)));
                    end
                end
            end
            
            % rule 12, the enzyme should not work on the parent of specified structure
            if(isprop(enzObj,'substMaxStruct')&&(~isempty(enzObj.substMaxStruct)))  % if the rule exists
                isValidRxnPos = isValidRxnPos && enzObj.substMaxStruct.contains(glycanSubstrObj);
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 13, the enzyme should not work on the children of specified structure
            if(isprop(enzObj,'substMinStruct')&&(~isempty(enzObj.substMinStruct)))  % if the rule exists
                isValidRxnPos = isValidRxnPos && glycanSubstrObj.contains(enzObj.substMinStruct);
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            if(isResidueDeleted)
                %  disp('has substrate');
                numSubstr=numSubstr+1;
                substr =GlycanSpecies(glycanSubstrObj);
                substrSpecies.add(substr);
                rxns.add(Rxn(substr,prodObj,enzObj));
                isPathUpdated = isPathUpdated || isResidueDeleted;
            end
        end
        
    else  % glycosidase
        
        for  i = 1  : numAllRes
            %i
            glycanSubstrObj   = glycanObj;
            nreResidues           = glycanSubstrObj.getAllResidues;
            nreResidue             =  nreResidues{1,i};
            
            isValidRxnPos = true;
            
            %             disp(nreResidue.residueType.name);
            if(strcmp(nreResidue.residueType.name,'freeEnd'))
                continue;
            end
            
            % check requirement 0
            if(isprop(enzObj,'resattach2FG')&&(~isempty(enzObj.resattach2FG)))  % if the rule exists
                requirement1                          = enzObj.dispAttachResLink;
                residueTypeNextTerm           = nreResidue.dispResidueInfo;
                
                isexactmatch = isempty(strfind(requirement1,'?'));
                if(isexactmatch)
                    isValidRxnPos = isequal(residueTypeNextTerm,requirement1);
                elseif(numel(residueTypeNextTerm)==numel(requirement1));
                    quotaindex =  strfind(requirement1,'?');
                    requirement1(quotaindex)='';
                    residueTypeNextTerm(quotaindex)='';
                    isValidRxnPos = isequal(residueTypeNextTerm,requirement1);
                else
                    isValidRxnPos = false;
                end
            end
            
            if(~isValidRxnPos)
                %disp('debug 0');
                continue;
            end
            
            % rule 6: the product should not be greater than the specified structure
            if( isprop(enzObj,'prodMinStruct')&& ~isempty(enzObj.prodMinStruct))
                isValidRxnPos = isValidRxnPos &&glycanSubstrObj.contains(enzObj.prodMinStruct);
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 7: the product should not work on the children of specificed structure
            if( isprop(enzObj,'prodMaxStruct')&& ~isempty(enzObj.prodMaxStruct))
                isValidRxnPos = isValidRxnPos &&enzObj.prodMaxStruct.contains(glycanSubstrObj);
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 9: the enzyme should not transfer the residue to the target branch containing
            % specified structure
            if(isprop(enzObj,'targetbranchcontain')&&(~isempty(enzObj.targetbranchcontain)))  % if the rule exists
                chartargetbranch=enzObj.targetbranchcontain.name;
                chartargetbranch = regexprep(chartargetbranch,'freeEnd','');
                
                charresidue= glycanSubstrObj.getresiduetoroot(nreResidue.getParent);
                charresidue= regexprep(charresidue,'freeEnd','');
                
                isValidRxnPos = isValidRxnPos && (~isempty(strfind(chartargetbranch,charresidue)));
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 10: the enzyme should not act on the specificed branch
            if( isprop(enzObj,'targetNABranch')&& ~isempty(enzObj.targetNABranch))  % if the rule exists
                if(isa(enzObj.targetNABranch,'GlycanStruct'))
                    chartargetbranch = enzObj.targetNABranch.name;
                    charresidue           = glycanSubstrObj.getresiduetoroot(nreResidue.getParent);
                    isValidRxnPos       = isValidRxnPos && (~strcmp(chartargetbranch,charresidue));
                elseif(isa(enzObj.targetNABranch,'CellArrayList'))
                    for ii = 1 : length(enzObj.targetNABranch)
                        chartargetbranch = enzObj.targetNABranch.name;
                        charresidue           = glycanSubstrObj.getresiduetoroot(nreResidue.getParent);
                        isValidRxnPos       =  isValidRxnPos && (~strcmp(chartargetbranch,charresidue));
                    end
                end
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            nBondChoice = length(enzObj.linkFG.bond);
            glycanSubstStructArray = CellArrayList;
            isOneResiduedeleted = false;
            
            if(nBondChoice>=1)
                for j = 1 : nBondChoice
                    bond=enzObj.linkFG.bond(j,1);
                    glycanSubstrObj  = glycanObj.clone;
                    nreResidues          = glycanSubstrObj.getAllResidues;
                    nreResidue            = nreResidues{1,i};
                    isResidueDeleted = glycanSubstrObj.addResidue(nreResidue,...
                        enzObj.resfuncgroup,enzObj.linkFG.anomer,...
                        bond);
                    if(isResidueDeleted)
                        isOneResiduedeleted = true;
                        %                         options=displayset('showmass',true,'showLinkage',true,...
                        %                'showRedEnd',true);
                        %                      glycanViewer(glycanSubstrObj,options);
                        glycanSubstStructArray.add(glycanSubstrObj);
                    end
                end
            end
            
            if(~isOneResiduedeleted)
                %                 disp('debug 1');
                continue;
            end
            
            for k = 1: glycanSubstStructArray.length
                
                glycanSubstrObj = glycanSubstStructArray.get(k);
                isValidRxnPos = true;
                % rule 11 the substrate should not contain the specificed branch
                if( isprop(enzObj,'substNABranch')&& ~isempty(enzObj.substNABranch))  % if the rule exists
                    if(isa(enzObj.substNABranch,'GlycanStruct'))
                        isValidRxnPos = isValidRxnPos && (~glycanSubstrObj.contains(enzObj.substNABranch));
                    elseif(isa(enzObj.substNABranch,'CellArrayList'))
                        for ii = 1 : length(enzObj.substNABranch)
                            isValidRxnPos = isValidRxnPos && (~glycanSubstrObj.contains(enzObj.substNABranch.get(ii)));
                        end
                    end
                end
                
                if(~isValidRxnPos)
                    continue;
                end
                
                % rule 12, the enzyme should not work on the parent of specified structure
                if(isprop(enzObj,'substMaxStruct')&&(~isempty(enzObj.substMaxStruct)))  % if the rule exists
                    isValidRxnPos = isValidRxnPos && enzObj.substMaxStruct.contains(glycanSubstrObj);
                end
                
                if(~isValidRxnPos)
                    continue;
                end
                
                % rule 13, the enzyme should not work on the children of specified structure
                if(isprop(enzObj,'substMinStruct')&&(~isempty(enzObj.substMinStruct)))  % if the rule exists
                    isValidRxnPos = isValidRxnPos && glycanSubstrObj.contains(enzObj.substMinStruct);
                end
                
                if(~isValidRxnPos)
                    continue;
                end
                
                numSubstr=numSubstr+1;
                substr =GlycanSpecies(glycanSubstrObj);
                substrSpecies.add(substr);
                rxns.add(Rxn(substr,...
                    prodObj,enzObj));
                isPathUpdated = true;
            end
        end
    end
    
    if(isPathUpdated)
        path.addGlycans(substrSpecies);
        path.addGlycan(prodObj);
        path.addRxns(rxns);
    end
end

if(nargout==1)
    varargout{1}=numSubstr;
elseif(nargout==2)
    varargout{1}=numSubstr;
    varargout{2}=substrSpecies;
elseif(nargout==3)
    varargout{1}=numSubstr;
    varargout{2}=substrSpecies;
    varargout{3}=rxns;
elseif(nargout==4)
    varargout{1}=numSubstr;
    varargout{2}=substrSpecies;
    varargout{3}=rxns;
    varargout{4}=path;
end

end

