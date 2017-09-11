function isPossibleYisXProd = isProdOfX(Obj,X,enzObjArray)
%isProdOfX determine if the glycan is a product of another
%structure
%
%   isPossibleYisXProd = isProdOfX(Y,X,enzObjArray) check if it
%   is possible to form Y from X glycan based on the input of an array of
%   enzymes enzObjArray.
%
% See also GLYCANSTRUCT/isProdOfX

if(  isequal(Obj,X) || Obj.equalStruct(X))
    isPossibleYisXProd = false;
    return;
end

countGTEnz=0;
countGHLEnz = 0;
residueFromGHList=[];
residueFromGTList=[];
for i = 1 : length(enzObjArray)
    if(isa(enzObjArray.get(i),'GTEnz'))
        countGTEnz=countGTEnz+1;
        residueFromGTList{countGTEnz,1}  =enzObjArray.get(i).resfuncgroup.name;
    elseif(isa(enzObjArray.get(i),'GHEnz'))
        countGHLEnz=countGHLEnz+1;
        residueFromGHList{countGHLEnz,1} =enzObjArray.get(i).resfuncgroup.name;
    else
        error('MATLAB:GNAT:UNSUPPORTED', 'Unsupported Enzyme Type');
    end
end

isPossibleYisXProd = true;
compX=X.getComposition;
compY=Obj.getComposition;
yprodresiduenames=fieldnames(compY);
xprodresiduenames=fieldnames(compX);

for i = 1 : length(yprodresiduenames)
    residueY = yprodresiduenames{i,1};
    if(strcmp(residueY,'freeEnd'))
        continue;
    end
    if(isempty(strmatch(residueY,xprodresiduenames,'exact')))   % Y has residue while X does not
        if~isempty(residueFromGTList)
            if(sum(strncmp(residueY,residueFromGTList,length(residueY)))~=0)
                isPossibleYisXProd= true;
            else
                isPossibleYisXProd= false;
                return;
            end
        else
            isPossibleYisXProd= false;
            return;
        end
    else  % both X and Y has residue
        diffResidueNumber = compY.(residueY)-compX.(residueY);
        if(diffResidueNumber==0)
            isPossibleYisXProd= isPossibleYisXProd && true;
        elseif(diffResidueNumber>0)  % multiple residue
            if~isempty(residueFromGTList)
                if(sum(strncmp(residueY,residueFromGTList,length(residueY)))~=0)
                    isPossibleYisXProd= true;
                else
                    isPossibleYisXProd= false;
                    return;
                end
            else
                isPossibleYisXProd= false;
                return;
            end
        else  % if it is less, it is due to the enzymatic action of GHL
            if(~isempty(residueFromGHList))
                if(sum(strncmp(residueY,residueFromGHList,length(residueY)))~=0)
                    isPossibleYisXProd= true;
                else
                    isPossibleYisXProd= false;
                    return
                end
            else
                isPossibleYisXProd= false;
            end
        end
    end
end

for i = 1 : length(xprodresiduenames)
    residueX = xprodresiduenames{i,1};
    if(strcmp(residueX,'freeEnd'))
        continue;
    end
    if(isempty(strmatch(residueX,yprodresiduenames,'exact')))   % X has residue while Y does not
        if~isempty(residueFromGHList)
            if (sum(strncmp(residueX,residueFromGHList,length(residueX)))~=0)   % check this residue might be removed by the GHL enzyme
                isPossibleYisXProd= true;
            else
                isPossibleYisXProd= false;
                return
            end
        else    % the residue is not removed by the enzyme
            isPossibleYisXProd=  false;
            return;
        end
    end
end

end

