function CleanSpectra =PolishSpectraLocal(Spectra,spannum,CutOffMed)
%POLISHSPECTRALocal: Remove local small peaks in m/z intervals of spannum 
% These small noisy peaks have intensity < 'CutOffMed'*median
% This is a useful local noise removal algorithm
%
% Syntax: 
%     CleanSpectra=PolishSpectraLocal(Spectra,spannum,CutOffMed)
%
% Input: 'Spectra', 'spannum' and 'CutOffMed'
%
% Output: CleanSpectra, which contains the noise reduced Spectra
%
% Children function: None
%
%See also PolishSpectra, removePrecursorIon 

% Author: Gang Liu and Sriram Neelamegham
% Date Lastly Updated: 8/11/14 by Gang Liu

Minmz=min(Spectra(:,1));
Maxmz=max(Spectra(:,1));
removeoption = 'localarb';
%removeoption = 'localmedian';

if(strcmpi(removeoption,'localmedian'))
    enter=1;
    mzStart=Minmz;
    mzEnd=mzStart+spannum;
    CleanSpectra=[];
    while (enter==1)
        if (mzEnd>=Maxmz)
            mzEnd=Maxmz;
            enter=0;
        end
       tempSpectra = Spectra(Spectra(:,1)>=mzStart,:);
       if(enter==0)
          subSpectra = tempSpectra(tempSpectra(:,1)<=mzEnd,:);
       else
          subSpectra = tempSpectra(tempSpectra(:,1)<mzEnd,:);  
       end

       medintensity = median(subSpectra(:,2));
       subSpectra(subSpectra(:,2)<CutOffMed*medintensity,:)=[];   
       CleanSpectra=[CleanSpectra;subSpectra];
       mzStart = mzEnd;
       mzEnd   = mzEnd+spannum;
    end
elseif(strcmpi(removeoption,'localarb'))
    halfmz  = 1000;
    mzStart = Minmz;
    mzEnd   = mzStart + spannum;
    CleanSpectra=[];
    exit = 0;
    while(~exit)
       if(mzEnd >= Maxmz)
           mzEnd = Maxmz;
           exit  = 1;
       elseif(mzEnd <= halfmz)
           lowhalf = 1;           
       else
           lowhalf = 0;
       end
        
       tempSpectra = Spectra(Spectra(:,1)>=mzStart,:);
       if(exit==1)
          subSpectra = tempSpectra(tempSpectra(:,1)<=mzEnd,:);
       else
          subSpectra = tempSpectra(tempSpectra(:,1)<mzEnd,:);  
       end

       if(lowhalf)
           numpeakselect = 5;
           amplifyfactor = 5;
       else
           numpeakselect = 3;
           amplifyfactor = 1;
       end
       
       if(length(subSpectra)<=numpeakselect)
         CleanSpectra=[CleanSpectra;subSpectra];
       else
         [~,newindex] = sort(subSpectra(:,2),1,'descend');
         sortsubSpectra = subSpectra(newindex,:);
         subSpectra = sortsubSpectra(1:numpeakselect,:);  
         subSpectra(:,2)=subSpectra(:,2)*amplifyfactor;
         CleanSpectra=[CleanSpectra;subSpectra];
       end
       
       mzStart = mzEnd;
       mzEnd   = mzEnd+spannum;
    end
end

end