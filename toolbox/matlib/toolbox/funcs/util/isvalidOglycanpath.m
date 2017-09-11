function  isvalid = isvalidOglycanpath(opath,subgroupArray,iniSubsArray,inputGlycanArray)
isolatedspecies = detectIsolatedSpecies(opath);

isaglycanSpecies = isa(isolatedspecies,'GlycanSpecies') ;
isaglycanarray = isa(isolatedspecies,'CellArrayList') ;
if(isaglycanSpecies)
    isvalid = false;
    return;
end
if(isaglycanarray && isolatedspecies.length>0)
    isvalid = false;
    return;
end

for  i = 1 : subgroupArray.length
    groupi =  subgroupArray.get(i);
    numgroupi=0;
    
    % check at least one substrate from each group in the pathway
    for j = 1 : groupi.length
        speciesj = groupi.get(j);
        locs=opath.findsameStructGlycan(speciesj);
        if(locs>0)
            numgroupi=numgroupi+1;
            break;
        end
    end
    
    if(numgroupi==0)
        isvalid = false;
        return
    end
end

% check initial substrate is S1 only
for i = 1 : opath.theSpecies.length
    ithspecies                  = opath.theSpecies.get(i);
    numProdInvolved   = ithspecies.listOfProdRxns.length;
    numSubstInvolved  = ithspecies.listOfReacRxns.length;
    if((numProdInvolved==0) ...
            && (numSubstInvolved>0) )
        for j = 1 : length(iniSubsArray)
            iniSubst = iniSubsArray.get(j);
            if(~iniSubst.glycanStruct.equalStruct(ithspecies.glycanStruct))
                isvalid = false;
                return;
            end
        end
    elseif((numProdInvolved==0) ...
            && (numSubstInvolved==0))
        isvalid = false;
        return;
    end
end

% check the synthetic glycan should be intermediate product 
for i = 1 : opath.theSpecies.length
    ithspecies = opath.theSpecies.get(i);
    speciesfoundininput=false;
    for  ii = 1 : inputGlycanArray.length
         speciesj  = inputGlycanArray.get(ii);
         if(speciesj.glycanStruct.equalStruct(ithspecies.glycanStruct))
                  speciesfoundininput = true;
                  break;
         end
    end
       
     if(speciesfoundininput)
           break;
     end     
    
   numProdInvolved    = ithspecies.listOfProdRxns.length;
    numSubstInvolved  = ithspecies.listOfReacRxns.length;
    if((numProdInvolved>0) ...
            && (numSubstInvolved>0) )
    else
        isvalid = false;
        return;
    end
end

isvalid = true;
end