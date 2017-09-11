function out=FinalspectrumGraph(xfile)
format long;

FileDirectory='C:\Users\gangliu\Desktop\MSAnalysis\Fetuin\mzxml';
filename='B05_02_091007_Sriram_sample_B_Fetuin_6ul_CID-ETD_5e6_column15_P12_needel_trap_1_Tee_short_1DE4.mzXML';
xfile=fullfile(FileDirectory,filename);

ScanNumber=6200;
z=6;
%mzxml file
mzXMLobj = mzXML(xfile,0,'memsave');
SpectrA = mzXMLobj.retrieveMSSpectra('scannum',ScanNumber,'charge',z);

if(isempty(SpectrA))
  error('MATLAB:GPAT:SPECTRAUMOTFOUND','THE SPECTRUM IS NOT FOUND')
end

SpectraB = SpectrA;
Mz_exp = mzXMLobj.retrieveMz('scannum',ScanNumber);
CutOffMed=3;
FracMax=0.001;
SpectraB=PolishSpectra(SpectrA, CutOffMed, FracMax);
 maxIntensity=max(SpectraB(:,2));
 newIntensity=(SpectraB(:,2)/maxIntensity);
SpectraB(:,2)=newIntensity*100;

figure;
bar(SpectraB(:,1),SpectraB(:,2),1,'k'); 
hold on;
width=25;
height=7;
set(gcf,'Units','centimeters','Position',[0,0,width,height])
box off;
set(gca,'TickDir','out')
set(gca,'FontSize',14)
set(gca,'FontName','Helvetica')
hold off;
end