This folder contains various files that can be used as a starting point to run GlycoPAT.

DigestGUI: "FASTA_basigen.txt" or "FASTA_fetuin.txt" contains a protein sequence. This file along with "fixed_ptm_std.txt" and "standard_N_glycans.txt" can be used to run digestGUI. The output from this operation is a .txt file containing GlyPepDB, for example "GlyPepDB_fibronectin_simple.txt".

ScoreGUI: Next, GlyPepDB .txt file along with .mzXML data file can be loaded into ScoreGUI. Running this program will generate the program output that resembles a .csv file.

BrowseGUI: You can then open the .csv file in BrowseGUI to view results. Click on individual rows to reveal the corresponding annotated spectrum.

Notes:

i. These files were generated on 'our' local drive and thus the path will be different from your computer. Thus, it is best to run the program sequentially on your computer to generate GlyPepDB.txt and output.csv locally before using BrowseGUI to view results.

ii. A standard file for O-glycan variable PTM modifications is also included.

iii. For more information please see our Youtube instructional video or refer to the program instructional manual.
