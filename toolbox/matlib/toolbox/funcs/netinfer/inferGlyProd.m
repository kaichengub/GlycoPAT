function varargout=inferGlyProd(substrObj,enzObj)
% inferGlyProd infer the product based on the substrate and enzyme.
%
%  [numProds,productSpecies] = inferGlyProd(substrObj,enz) infers
%    the product if the enzyme acts on the substrate. If no product is
%    formed, numProds is equal to zero and productSpecies is empty.
%    If more  than one product are formed, they are stored in the 
%    CellArayList  productSpecies. substrObj is a GlycanSpecies object.
%
%  [numProds,productSpecies,rxns] = inferGlyProd(substrObj,enz)
%   returns a list of reactions CellArrayList object rxns if the enzyme acts
%   on the substrate. If no product is  formed, rxns returns as an empty 
%   CellArrayList.
%
%  [numProds,productSpecies,rxns,pathway] = inferGlyProd(substrObj,enz)
%   returns the pathway  if the enzyme acts on the substrate. If no product
%   is formed, pathway is return as empty.
%   
%    Example 1:
%          mgat2=GTEnz.loadmat('mgat2.mat');
%          m3gn = GlycanSpecies(glycanMLread('m3gn.glycoct_xml'));
%          [numprod, m3gngn] = inferGlyProd(m3gn,mgat2);
%          options          = displayset('showmass',true,'showLinkage',true,...
 %                           'showRedEnd',true);
%          for i = 1: numprod
%              glycanViewer(m3gngn.get(i).glycanStruct,options);
%          end
% 
%    Example 2:
%         mgat2=GTEnz.loadmat('mgat2.mat');
%         m3gn = GlycanSpecies(glycanMLread('m3gn.glycoct_xml'));
%         [numprod, m3gngn,m3gngnrxn] = inferGlyProd(m3gn,mgat2);
%         for i = 1: numprod
%              glycanRxnViewer(m3gngnrxn.get(i));
%         end
%   
%    Example 3:
%         mgat2=GTEnz.loadmat('mgat2.mat');
%         m3gn = GlycanSpecies(glycanMLread('m3gn.glycoct_xml'));
%         [numprod, m3gngn,m3gngnrxn,m3gngnpathway] = inferGlyProd(m3gn,mgat2);
%         glycanPathViewer(m3gngnpathway);         
%
%See also inferGlySubstr,inferGlyForwPath.

% Author: Gang Liu
% Date Last Updated: 8/02/13
narginchk(2,4);
nargoutchk(1,4);

if(isa(substrObj,'GlycanSpecies'))
    glycanObj =  substrObj.glycanStruct;
else
    error('MATLAB:GNAT:WrongInput','Input Wrong Type');
end

if(isa(enzObj,'GTEnz'));
    enzFuncToAdd=1;
    numRes =  length(glycanObj.getAllResidues);
elseif(isa(enzObj,'GHEnz'))
    enzFuncToAdd=0;
    numNRERes =  length(glycanObj.getNonRedEndResidue);
else
    enzFuncToAdd=-1;
end

numProds          = 0;
productSpecies = CellArrayList;
rxns  =CellArrayList;
path =Pathway;

isSubstValid = true;
if(isprop(enzObj,'glycanTypeSpec')&&(~isempty(enzObj.glycanTypeSpec)))  % rule 1: N-, O-, glycolipids
    requirement0 = enzObj.glycanTypeSpec;
    acceptortype  = glycanObj.glycanTypeSpec;
    isSubstValid    = isequal(acceptortype,requirement0);
end

if(isprop(enzObj,'substNAResidue')&&(~isempty(enzObj.substNAResidue)))  %rule 2 It does not contain the specified residue
    NAResiduename = enzObj.substNAResidue.name;
    composition       = glycanObj.getComposition;
    isSubstValid        =  ~(isfield(composition,NAResiduename) &&...
                                     composition.(NAResiduename)>=1);
end

if(isSubstValid)
    if(enzFuncToAdd==1)
        for i = 1 :numRes
            
            glycanProdObj    = glycanObj;
            allResidues           = glycanProdObj.getAllResidues;
            residue                 = allResidues{1,i};
            
            if(strcmp(residue.residueType.name,'freeEnd'))
                continue;
            end
            
            % rule 3: if the the substrate should target the terminal residue
            if( isprop(enzObj,'isTerminalTarget')&& ~isempty(enzObj.isTerminalTarget))
                if(enzObj.isTerminalTarget)
                    if( isprop(residue,'linkageChildren')&& isempty(residue.linkageChildren));
                        isValidRxnPos = true;
                    else
                        isValidRxnPos = false;
                    end
                else
                    if( isprop(residue,'linkageChildren')&& isempty(residue.linkageChildren));
                        isValidRxnPos = false;
                    else
                        isValidRxnPos = true;
                    end
                end
            else
                isValidRxnPos = true;
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 4: the enzyme should act on the specified residue terminal and
            % linkage
            requirement1 = enzObj.dispAttachResLink;
            acceptorTerminal=residue.dispResidueInfo;
            isexactmatch = isempty(strfind(requirement1,'?'));
            if(isexactmatch)
                isValidRxnPos = isequal(acceptorTerminal,requirement1);
            elseif(numel(acceptorTerminal)==numel(requirement1));
                quotaindex =  strfind(requirement1,'?');
                requirement1(quotaindex)='';
                acceptorTerminal(quotaindex)='';
                isValidRxnPos = isequal(acceptorTerminal,requirement1);
            else
                isValidRxnPos = false;
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 5: the enzyme should not work on the glycans containing specified structure
            if(isprop(enzObj,'substMaxStruct')&&(~isempty(enzObj.substMaxStruct)))  % if the rule exists
                isValidRxnPos = isValidRxnPos && enzObj.substMaxStruct.contains(glycanObj);
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 6: the enzyme should not work on the glycans  which are children of specified structure
            if(isprop(enzObj,'substMinStruct')&&(~isempty(enzObj.substMinStruct)))  % if the rule exists
                isValidRxnPos = isValidRxnPos && glycanObj.contains(enzObj.substMinStruct);
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 7: the enzyme should transfer residue to the target branch
            if(isprop(enzObj,'targetBranch')&&(~isempty(enzObj.targetBranch)))  % if the rule exists
                chartargetbranch =enzObj.targetBranch.name;
                charresidue           = glycanProdObj.getresiduetoroot(residue);
                isValidRxnPos       = isValidRxnPos && (strcmp(chartargetbranch,charresidue));
            end
            
            % rule 8: the enzyme should not transfer the residue to the target branch containing
            % specified structure
            if(isprop(enzObj,'targetbranchcontain')&&(~isempty(enzObj.targetbranchcontain)))  % if the rule exists
                chartargetbranch  = enzObj.targetbranchcontain.name;
                chartargetbranch = regexprep(chartargetbranch,'freeEnd--',' ');
                chartargetbranch = regexprep(chartargetbranch,'?',' ');
                
                charresidue= glycanProdObj.getresiduetoroot(residue);
                charresidue= regexprep(charresidue,'freeEnd--','');
                charresidue= regexprep(charresidue,'?','');
                
                isValidRxnPos = isValidRxnPos && (~isempty(strfind(strtrim(charresidue),strtrim(chartargetbranch))));
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 9: the substrate should not contain the specificed branch
            if( isprop(enzObj,'substNABranch')&& ~isempty(enzObj.substNABranch))  % if the rule exists
                if(isa(enzObj.substNABranch,'GlycanStruct'))
                    isValidRxnPos = isValidRxnPos && (~glycanObj.contains(enzObj.substNABranch));
                elseif(isa(enzObj.substNABranch,'CellArrayList'))
                    for ii = 1 : length(enzObj.substNABranch)
                        isValidRxnPos = isValidRxnPos && (~glycanObj.contains(enzObj.substNABranch.get(ii)));
                    end
                end
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % rule 10: the enzyme should not act on the specificed branch
            if( isprop(enzObj,'targetNABranch')&& ~isempty(enzObj.targetNABranch))  % if the rule exists
                if(isa(enzObj.targetNABranch,'GlycanStruct'))
                    chartargetbranch = enzObj.targetNABranch.name;
                    charresidue           = glycanProdObj.getresiduetoroot(residue);
                    isValidRxnPos       = isValidRxnPos && (~strcmp(chartargetbranch,charresidue));
                elseif(isa(enzObj.targetNABranch,'CellArrayList'))
                    for ii = 1 : length(enzObj.targetNABranch)
                        chartargetbranch = enzObj.targetNABranch.name;
                        charresidue           = glycanProdObj.getresiduetoroot(residue);
                        isValidRxnPos       =  isValidRxnPos && (~strcmp(chartargetbranch,charresidue));
                    end
                end
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            newbond          =  enzObj.linkFG.bond;
            anomerchar       =  enzObj.linkFG.anomer;
            
            glycanProdObj    = glycanObj.clone;
            allResidues           = glycanProdObj.getAllResidues;
            residue                  = allResidues{1,i};
            
            isResidueAdded = glycanProdObj.addResidue(...
                residue,enzObj.resfuncgroup,anomerchar,newbond);
            
            if(isResidueAdded)
                %  disp('has prod');
                
                % check requirement 11: the product should not be greater than the specified structure
                if( isprop(enzObj,'prodMinStruct')&& ~isempty(enzObj.prodMinStruct))  % if the rule exists
                    isValidRxnPos = isValidRxnPos &&glycanProdObj.contains(enzObj.prodMinStruct);
                end
                
                if(~isValidRxnPos)
                    continue;
                end
                
                % check requirement 12: the enzyme should not work on the children of specificed structure
                if( isprop(enzObj,'prodMaxStruct')&& ~isempty(enzObj.prodMaxStruct))  % if the rule exists
                    isValidRxnPos = isValidRxnPos &&enzObj.prodMaxStruct.contains(glycanProdObj);
                end
                
                if(~isValidRxnPos)
                    continue;
                end
                
                numProds=numProds+1;
                prod = GlycanSpecies(glycanProdObj);
                %            prod.compartment = enz.compartment;
                productSpecies.add(prod);
                rxns.add(Rxn(substrObj,prod,enzObj));
            end            
        end
        
    elseif(enzFuncToAdd==0)  % remove sugar residue from the glycan
        
        for i = 1 :numNRERes
            
            % i
            glycanProdObj        = glycanObj.clone;
            allResidues               = glycanProdObj.getNonRedEndResidue;
            residue                      = allResidues{1,i};
            % requirement for the enzymatic actions of glycosidase rxn
            %   1) terminal residue is Man{a}1,3 or Man{a}1,6
            %   2) substrmaximal: structure
            %   3) substrminimal: structure
            
            %check requirement 1
            requirement1         = enzObj.dispFuncResLink;
            acceptorTerminal  = residue.dispResidueInfo;
            
            isValidRxnPos = false;
            for ii=1:length(requirement1)
                isValidRxnPos = isValidRxnPos || isequal(acceptorTerminal,requirement1{1,ii});
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % check requirement 2: the enzyme should not work on the parent of specified structure
            if(isprop(enzObj,'substMaxStruct')&&(~isempty(enzObj.substMaxStruct)))  % if the rule exists
                isValidRxnPos = isValidRxnPos && enzObj.substMaxStruct.contains(glycanObj);
            end
            
            if(~isValidRxnPos)
                continue;
            end
            
            % check requirement 3: the enzyme should not work on the children of specificed structure
            if( isprop(enzObj,'substMinStruct')&& ~isempty(enzObj.substMinStruct))  % if the rule exists
                isValidRxnPos = isValidRxnPos &&glycanObj.contains(enzObj.substMinStruct);
            end
            
             if(~isValidRxnPos)
                continue;
            end
            
            % check requirement 4: the substrate should not contains the specificed branch
            if( isprop(enzObj,'substNABranch')&& ~isempty(enzObj.substNABranch))  % if the rule exists
                if(isa(enzObj.substNABranch,'GlycanStruct'))
                     isValidRxnPos = isValidRxnPos && (~glycanObj.contains(enzObj.substNABranch));
                elseif(isa(enzObj.substNABranch,'CellArrayList'))
                    for ii = 1 : length(enzObj.substNABranch)  
                       isValidRxnPos = isValidRxnPos && (~glycanObj.contains(enzObj.substNABranch.get(ii)));
                    end
                else
                    error('MATALAB:GNAT:WrongInput','Wrong Input Type');
                end
            end
            
            if(~isValidRxnPos)
                continue;
            end
            %disp('residue to be deleted');
            isResidueDeleted = glycanProdObj.removeNonRedEndResidue(residue);
            %disp('residue deleted');
            
            if(isResidueDeleted)
                
                % check requirement 4: the product should not be greater than the specified structure
                if( isprop(enzObj,'prodMinStruct')&& ~isempty(enzObj.prodMinStruct))  % if the rule exists
                    isValidRxnPos = isValidRxnPos &&glycanProdObj.contains(enzObj.prodMinStruct);
                end
                
                if(~isValidRxnPos)
                    continue;
                end
                
                % check requirement 5: the enzyme should not work on the children of specificed structure
                if( isprop(enzObj,'prodMaxStruct')&& ~isempty(enzObj.prodMaxStruct))  % if the rule exists
                    isValidRxnPos = isValidRxnPos &&enzObj.prodMaxStruct.contains(glycanProdObj);
                end
                
                if(~isValidRxnPos)
                    continue;
                end
                
                numProds=numProds+1;
                prodObj = GlycanSpecies(glycanProdObj);
                productSpecies.add(prodObj);
                rxns.add(Rxn(substrObj,prodObj,enzObj));
            end
        end
    else
        error('MATLAB:GNAT:ENZYMEERROR','enzyme definition is wrong');
    end
end

if((nargout==4)&&isSubstValid)
    path.addGlycans(productSpecies);
    path.addGlycan(substrObj);
    path.addRxns(rxns);
    path.addEnz(enzObj);
else
    path =Pathway;
end

if(nargout==1)
    varargout{1}=numProds;
elseif(nargout==2)
    varargout{1}=numProds;
    varargout{2}=productSpecies;
elseif(nargout==3)
    varargout{1}=numProds;
    varargout{2}=productSpecies;
    varargout{3}=rxns;
elseif(nargout==4)
    varargout{1}=numProds;
    varargout{2}=productSpecies;
    varargout{3}=rxns;
    varargout{4}=path;
end

end



