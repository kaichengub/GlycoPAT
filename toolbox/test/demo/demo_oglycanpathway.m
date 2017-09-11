residueMap=load('residueTypes.mat');

B3GALTI                     = GTEnz([2;4;1;122]);
B3GALTI.resfuncgroup        = residueMap.allresidues('Gal');
B3GALTI.resAtt2FG           = residueMap.allresidues('GalNAc');
galnacBond                  = GlycanBond('?','1');
B3GALTI. linkresAtt2FG      = struct('bond',galnacBond,'anomer','a');
galbond                     = GlycanBond('3','1');
B3GALTI.linkFG              = struct('anomer','b','bond',galbond);
B3GALTI.substMaxStruct      = glycanMLread('314.16.glycoct_xml');

B3GALTIV                     = GTEnz([2;4;1;86]);
B3GALTIV.resfuncgroup        = residueMap.allresidues('Gal');
B3GALTIV.resAtt2FG           = residueMap.allresidues('GlcNAc');
glcnacBond                 = GlycanBond('?','1');
B3GALTIV. linkresAtt2FG      = struct('bond',glcnacBond,'anomer','b');
galbond                    = GlycanBond('4','1');
B3GALTIV.linkFG              = struct('anomer','b','bond',galbond);

% FUT4,7,9.
FUTs                     = GTEnz([2;4;1;152]);
FUTs.resfuncgroup        = residueMap.allresidues('Fuc');
FUTs.resAtt2FG           = residueMap.allresidues('GlcNAc');
glcnacBond               = GlycanBond('?','1');
FUTs.linkresAtt2FG       = struct('bond',glcnacBond,'anomer','b');
futbond                  = GlycanBond('3','1');
FUTs.linkFG              = struct('anomer','a','bond',futbond);
FUTs.targetbranchcontain = glycanMLread('FutTargetbranchcontain.glycoct_xml');
FUTs.substMinStruct      = glycanMLread('FutMinSubstr.glycoct_xml');
FUTs.isTerminalTarget    = false;

GCNTI                    = GTEnz([2;4;1;102]);
GCNTI.resfuncgroup       = residueMap.allresidues('GlcNAc');
GCNTI.resAtt2FG          = residueMap.allresidues('GalNAc');
galnacBond               = GlycanBond('?','1');
GCNTI.linkresAtt2FG      = struct('bond',galnacBond,'anomer','a');
glcnacbond               = GlycanBond('6','1');
GCNTI.linkFG             = struct('anomer','b','bond',glcnacbond);
GCNTI.substMaxStruct     = glycanMLread('GCNTImaxSubstr.glycoct_xml');
GCNTI.substNABranch      = glycanMLread('GCNTINABranch.glycoct_xml');

ST3GalI_IV                     = GTEnz([2;4;99;4]);
ST3GalI_IV.resfuncgroup        = residueMap.allresidues('NeuAc');
ST3GalI_IV.resAtt2FG           = residueMap.allresidues('Gal');
galBond                     = GlycanBond('?','1');  
ST3GalI_IV. linkresAtt2FG      = struct('bond',galBond,'anomer','b');
siabond                     = GlycanBond('3','2');
ST3GalI_IV.linkFG              = struct('anomer','a','bond',siabond);
ST3GalI_IV.isTerminalTarget    = true;

ST6GalNAc                    = GTEnz([2;4;99;3]);
ST6GalNAc.resfuncgroup       = residueMap.allresidues('NeuAc');
ST6GalNAc.resAtt2FG          = residueMap.allresidues('GalNAc');
glcnacBond                   = GlycanBond('?','1');
ST6GalNAc.linkresAtt2FG      = struct('bond',glcnacBond,'anomer','a');
siabond                      = GlycanBond('6','2');
ST6GalNAc.linkFG             = struct('anomer','a','bond',siabond);
ST6GalNAc.substMinStruct     = glycanMLread('314.16.glycoct_xml');
ST6GalNAc.substMaxStruct     = glycanMLread('879.43.glycoct_xml');

enzArray=CellArrayList;
enzArray.add(B3GALTI);
enzArray.add(B3GALTIV);
enzArray.add(FUTs);
enzArray.add(GCNTI);
enzArray.add(ST3GalI_IV);
enzArray.add(ST6GalNAc);

%define the end prod
a1  = GlycanSpecies(glycanMLread('314.16.glycoct_xml'));
glycanViewer(a1.glycanStruct);
a2  = GlycanSpecies(glycanMLread('1863.92.glycoct_xml'));
glycanViewer(a2.glycanStruct);
a3  = GlycanSpecies(glycanMLread('1240.60.glycoct_xml'));
glycanViewer(a3.glycanStruct);

glycanArray = CellArrayList;
glycanArray.add(a1);
glycanArray.add(a2);
glycanArray.add(a3);

%Perform reaction
displayOptions = displayset('showMass',true,'showLinkage',true,'showRedEnd',true);
fprintf(1,'Input of glycan product structure is \n');
% glycanViewer(a1.glycanStruct,displayOptions);
% glycanViewer(a2.glycanStruct,displayOptions);
% glycanViewer(a3.glycanStruct,displayOptions);
[isPath,olinkedpath]=inferGlyConnPath(glycanArray,enzArray);
if(isPath)
    glycanPathViewer(olinkedpath);
    fprintf(1,'The final network has: \n');
    fprintf(1,'    %i  reactions\n',olinkedpath.getNReactions);
    fprintf(1,'    %i  species\n',olinkedpath.getNSpecies);    
end

numspecies = length(olinkedpath.theSpecies);
sgp = cell(numspecies,1);
for i = 1 :numspecies
    itheSpecieslinucs = olinkedpath.theSpecies.get(i).glycanStruct.toLinucs;
    sgp{i}=linucs2SmallGlyPep(itheSpecieslinucs,'linucs');
end