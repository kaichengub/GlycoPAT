%% GNAT Demo 5
% This demo shows how to construct an N-linked glycosylation pathway using glycans annoated from
%   mass spectra data.  The inputs are glycan structures annoated from 24 peaks and 11 enzymes.

%% Enzyme definition
% MAN II, MGAT 1,2,3,4,5,GalT, FucT, SiaT enzymes
% are loaded from a pre-defined local database.

enzdbmatfilename   = 'glyenzDB.mat';
enzdb = enzdbmatLoad(enzdbmatfilename);
mgat1 = enzdb('mgat1');
mgat2 = enzdb('mgat2');
mgat3 = enzdb('mgat3');
mgat4 = enzdb('mgat4');
mgat5 = enzdb('mgat5');
manii  = enzdb('manii');
galt     = enzdb('galt');
gnte    = enzdb('gnte');
siaT     = enzdb('siaT');
fucT8 = enzdb('fucT8');

%% Definition of Glycan Structures
% Initial glycans are defined based on 20 peaks and stored in substrateArray variable.

gDispOption1    = displayset('showmass',true,'showLinkage',true,...
    'showRedEnd',true);
s1species    = GlycanSpecies(glycanMLread('s1_1579.glycoct_xml')) ;
glycanViewer(s1species.glycanStruct,gDispOption1);
s2species    = GlycanSpecies(glycanMLread('s2_1590.glycoct_xml')) ;
glycanViewer(s2species.glycanStruct,gDispOption1);

s3v1species    = GlycanSpecies(glycanMLread('s3v1_1620.glycoct_xml')) ;
glycanViewer(s3v1species.glycanStruct,gDispOption1);
s3v2species    = GlycanSpecies(glycanMLread('s3v2_1620.glycoct_xml')) ;
glycanViewer(s3v2species.glycanStruct,gDispOption1);

s4species    = GlycanSpecies(glycanMLread('s4_1783.glycoct_xml')) ;
glycanViewer(s4species.glycanStruct,gDispOption1);

s5species    = GlycanSpecies(glycanMLread('s5_1835.glycoct_xml')) ;
glycanViewer(s5species.glycanStruct,gDispOption1);

s6v1species    = GlycanSpecies(glycanMLread('s6v1_1865.glycoct_xml')) ;
glycanViewer(s6v1species.glycanStruct,gDispOption1);
s6v2species    = GlycanSpecies(glycanMLread('s6v2_1865.glycoct_xml')) ;
glycanViewer(s6v2species.glycanStruct,gDispOption1);

s7species    = GlycanSpecies(glycanMLread('s7_1988.glycoct_xml')) ;
glycanViewer(s7species.glycanStruct,gDispOption1);

s8v1species    = GlycanSpecies(glycanMLread('s8v1_2040.glycoct_xml')) ;
glycanViewer(s8v1species.glycanStruct,gDispOption1);
s8v2species    = GlycanSpecies(glycanMLread('s8v2_2040.glycoct_xml')) ;
glycanViewer(s8v2species.glycanStruct,gDispOption1);

s9species    = GlycanSpecies(glycanMLread('s9_2070.glycoct_xml')) ;
glycanViewer(s9species.glycanStruct,gDispOption1);
s10species    = GlycanSpecies(glycanMLread('s10_2081.glycoct_xml'));
glycanViewer(s10species.glycanStruct,gDispOption1);
s11species   = GlycanSpecies(glycanMLread('s11_2192.glycoct_xml')) ;
glycanViewer(s11species.glycanStruct,gDispOption1);
s12species   = GlycanSpecies(glycanMLread('s12_2244.glycoct_xml')) ;
glycanViewer(s12species.glycanStruct,gDispOption1);
s13species    = GlycanSpecies(glycanMLread('s13_2396.glycoct_xml')) ;
glycanViewer(s13species.glycanStruct,gDispOption1);

s14v1species    = GlycanSpecies(glycanMLread('s14v1_2431.glycoct_xml')) ;
glycanViewer(s14v1species.glycanStruct,gDispOption1);
s14v2species    = GlycanSpecies(glycanMLread('s14v2_2431.glycoct_xml')) ;
glycanViewer(s14v2species.glycanStruct,gDispOption1);

s15species    = GlycanSpecies(glycanMLread('s15_2489.glycoct_xml')) ;
glycanViewer(s15species.glycanStruct,gDispOption1);
s16v1species    = GlycanSpecies(glycanMLread('s16v1_2519.glycoct_xml')) ;
glycanViewer(s16v1species.glycanStruct,gDispOption1);
s16v2species    = GlycanSpecies(glycanMLread('s16v2_2519.glycoct_xml')) ;
glycanViewer(s16v2species.glycanStruct,gDispOption1);

s17v1species    = GlycanSpecies(glycanMLread('s17v1_2605.glycoct_xml')) ;
glycanViewer(s17v1species.glycanStruct,gDispOption1);
s17v2species    = GlycanSpecies(glycanMLread('s17v2_2605.glycoct_xml')) ;
glycanViewer(s17v2species.glycanStruct,gDispOption1);

s18v1species        = GlycanSpecies(glycanMLread('s18v1_2693.glycoct_xml')) ;
glycanViewer(s18v1species.glycanStruct,gDispOption1);
s18v2species        = GlycanSpecies(glycanMLread('s18v2_2693.glycoct_xml')) ;
glycanViewer(s18v2species.glycanStruct,gDispOption1);

s19v1species    = GlycanSpecies(glycanMLread('s19v1_2880.glycoct_xml')) ;
glycanViewer(s19v1species.glycanStruct,gDispOption1);
s19v2species    = GlycanSpecies(glycanMLread('s19v2_2880.glycoct_xml')) ;
glycanViewer(s19v2species.glycanStruct,gDispOption1);
s19v3species    = GlycanSpecies(glycanMLread('s19v3_2880.glycoct_xml')) ;
glycanViewer(s19v3species.glycanStruct,gDispOption1);

s19v4species    = GlycanSpecies(glycanMLread('s19v4_2880.glycoct_xml')) ;
glycanViewer(s19v4species.glycanStruct,gDispOption1);
s19v5species    = GlycanSpecies(glycanMLread('s19v5_2880.glycoct_xml')) ;
glycanViewer(s19v5species.glycanStruct,gDispOption1);
s19v6species    = GlycanSpecies(glycanMLread('s19v6_2880.glycoct_xml')) ;
glycanViewer(s19v6species.glycanStruct,gDispOption1);

s20v1species        = GlycanSpecies(glycanMLread('s20v1_2938.glycoct_xml')) ;
glycanViewer(s20v1species.glycanStruct,gDispOption1);
s20v2species        = GlycanSpecies(glycanMLread('s20v2_2938.glycoct_xml')) ;
glycanViewer(s20v2species.glycanStruct,gDispOption1);

s21species        = GlycanSpecies(glycanMLread('s21v1_2968.glycoct_xml')) ;
glycanViewer(s21species.glycanStruct,gDispOption1);

s22v1species    = GlycanSpecies(glycanMLread('s22v1_3054.glycoct_xml')) ;
glycanViewer(s22v1species.glycanStruct,gDispOption1);
s22v2species    = GlycanSpecies(glycanMLread('s22v2_3054.glycoct_xml')) ;
glycanViewer(s22v2species.glycanStruct,gDispOption1);
s22v3species    = GlycanSpecies(glycanMLread('s22v3_3054.glycoct_xml')) ;
glycanViewer(s22v3species.glycanStruct,gDispOption1);

s22v4species    = GlycanSpecies(glycanMLread('s22v4_3054.glycoct_xml')) ;
glycanViewer(s22v4species.glycanStruct,gDispOption1);
s22v5species    = GlycanSpecies(glycanMLread('s22v5_3054.glycoct_xml')) ;
glycanViewer(s22v5species.glycanStruct,gDispOption1);
s22v6species    = GlycanSpecies(glycanMLread('s22v6_3054.glycoct_xml')) ;
glycanViewer(s22v6species.glycanStruct,gDispOption1);

s23species       = GlycanSpecies(glycanMLread('s23_3142.glycoct_xml')) ;
glycanViewer(s23species.glycanStruct,gDispOption1);

s24v1species   = GlycanSpecies(glycanMLread('s24v1_3241.glycoct_xml')) ;
glycanViewer(s24v1species.glycanStruct,gDispOption1);
s24v2species   = GlycanSpecies(glycanMLread('s24v2_3241.glycoct_xml')) ;
glycanViewer(s24v2species.glycanStruct,gDispOption1);
s24v3species   = GlycanSpecies(glycanMLread('s24v3_3241.glycoct_xml')) ;
glycanViewer(s24v3species.glycanStruct,gDispOption1);

s24v4species   = GlycanSpecies(glycanMLread('s24v4_3241.glycoct_xml')) ;
glycanViewer(s24v4species.glycanStruct,gDispOption1);
s24v5species   = GlycanSpecies(glycanMLread('s24v5_3241.glycoct_xml')) ;
glycanViewer(s24v5species.glycanStruct,gDispOption1);
s24v6species   = GlycanSpecies(glycanMLread('s24v6_3241.glycoct_xml')) ;
glycanViewer(s24v6species.glycanStruct,gDispOption1);

substrateArray = CellArrayList;
substrateArray.add(s1species);
substrateArray.add(s2species);
substrateArray.add(s3v1species);
substrateArray.add(s3v2species);
% substrateArray.add(s4species);
substrateArray.add(s5species);
substrateArray.add(s6v1species);
substrateArray.add(s6v2species);
% substrateArray.add(s7species);
substrateArray.add(s8v1species);
substrateArray.add(s8v2species);
substrateArray.add(s9species);
substrateArray.add(s10species);
% substrateArray.add(s11species);
substrateArray.add(s12species);
% substrateArray.add(s13species);
substrateArray.add(s14v1species);
substrateArray.add(s14v2species);

substrateArray.add(s15species);
substrateArray.add(s16v1species);
substrateArray.add(s16v2species);

substrateArray.add(s17v1species);
substrateArray.add(s17v2species);

substrateArray.add(s18v1species);
substrateArray.add(s18v2species);

substrateArray.add(s19v1species);
substrateArray.add(s19v2species);
substrateArray.add(s19v3species);
substrateArray.add(s19v4species);
substrateArray.add(s19v5species);
substrateArray.add(s19v6species);

substrateArray.add(s20v1species);
substrateArray.add(s20v2species);

substrateArray.add(s21species);
substrateArray.add(s22v1species);
substrateArray.add(s22v2species);
substrateArray.add(s22v3species);
substrateArray.add(s22v4species);
substrateArray.add(s22v5species);
substrateArray.add(s22v6species);

substrateArray.add(s23species);
substrateArray.add(s24v1species);
substrateArray.add(s24v2species);
substrateArray.add(s24v3species);
substrateArray.add(s24v4species);
substrateArray.add(s24v5species);
substrateArray.add(s24v6species);

%% Store enzymes and glycan in CellArrayList variables
% enzArray are created to store  enzymes which might act on substrates.
enzArray = CellArrayList;
enzArray.add(manii);
enzArray.add(mgat1);
enzArray.add(mgat2);
enzArray.add(mgat3);
enzArray.add(mgat4);
enzArray.add(mgat5);
enzArray.add(galt);
enzArray.add(fucT8);
enzArray.add(gnte);
enzArray.add(siaT);

%% Pathway reconstruction using connection inferrence
%  inferGlyConnPath command is used to construct a
%    pathway and the pathway can be visualized using glycanPathViewer
%    command.  The reconstructed network has 288 reactions and 151 species.
%    This construction takes about 5 mins to finish on Core 7 computer.
%
[isPath,nglycanpath]=inferGlyConnPath(substrateArray, enzArray);

if(isPath)
    glycanPathViewer(nglycanpath);
    fprintf(1,'the generated network has: \n');
    fprintf(1,'    %i  reactions\n',nglycanpath.getNReactions);
    fprintf(1,'    %i  species\n',   nglycanpath.getNSpecies);
else
    fprintf(1,'no path is found\n');
end

