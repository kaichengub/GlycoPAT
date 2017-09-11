function glycanpath2 = removeLinkageIsomerStruct(glycanpath)
glycanpath2       = glycanpath.clone;
thespeciesArray = glycanpath2.theSpecies;
therxnsArray       = glycanpath2.theRxns;

% replace isomer structure with same
removeindex = [];
for  i = 1 : length(thespeciesArray)-1
    %     disp(num2str(i));
    thespecies  = thespeciesArray.get(i);
    for   j = (i+1):1:length(thespeciesArray)
        if(~isempty( find( (removeindex-j)==0,1)))
            continue
        end
        thenextspecies = thespeciesArray.get(j);
        iscompossame= iscompsame(thespecies,thenextspecies);
        if(iscompossame)
            removeindex=[removeindex;j];
            % thespeciesArray.remove(j);
            %             fprintf(1,'%f isomer \n ',j);
        end
    end
end

% remove index
if(~isempty(removeindex))
     thespeciesArray.remove(removeindex);
end

% for i =1: length(thespeciesArray)
%      glycanViewer(thespeciesArray.get(i).glycanStruct);
% end

% update species in the list
newtherxnsArray=updateRxn(therxnsArray,thespeciesArray);
glycanpath2.theRxns=newtherxnsArray;

% glycanPathViewer(glycanpath2);

% remove replicate rxn in the reaction array
if(~isempty(newtherxnsArray))
   %removeduplicateRxn(newtherxnsArray);
    glycanpath2.theRxns = removeduplicateRxn(newtherxnsArray);
end

% glycanPathViewer(glycanpath2);

end

function newtherxnsArray = updateRxn(therxnsArray,thespeciesArray)

newtherxnsArray=CellArrayList;
for i = 1 : length(therxnsArray);
%     disp('----------------------------');
   % disp(num2str(i));    
    thereact = therxnsArray.get(i).getReactant;
    theprod = therxnsArray.get(i).getProduct;

    for j = 1 : length(thespeciesArray)
        if(iscompsame(thereact,thespeciesArray.get(j)))
            thenewreact=thespeciesArray.get(j);
            break;
        end
    end
    
    for j = 1 : length(thespeciesArray)
        if(iscompsame(theprod,thespeciesArray.get(j)))
            thenewprod=thespeciesArray.get(j);
            break;
        end
    end
    
    newtherxns=Rxn(thenewreact,thenewprod);
    newtherxnsArray.add(newtherxns);
end

end

function newtherxnsArray = removeduplicateRxn(therxnsArray)

newtherxnsArray=CellArrayList;

for i = 1 : length(therxnsArray)
    if(~newtherxnsArray.contains(therxnsArray.get(i)))
        newtherxnsArray.add(therxnsArray.get(i));
    end
end

end

function speciesnames = getnewnames(thespeciesArray)

speciesnames = cell(length(thespeciesArray),1);
for i = 1:length(thespeciesArray)
    thespecies=thespeciesArray.get(i);
    speciesnames{i,1} = regexprep(thespecies.name,'--\w*+-','');
end

end

function isisomer = iscompsame(thespecies1,thespecies2)
% remove linkage informaiton
thespecies1name = thespecies1.glycanStruct.name;%glycanStruct.toString;
isomername1=regexprep(thespecies1name,'--\w*+-','');
thespecies2name = thespecies2.glycanStruct.name;%glycanStruct.toString;
isomername2=regexprep(thespecies2name,'--\w*+-','');
isisomer = strcmp(isomername1,isomername2);
end