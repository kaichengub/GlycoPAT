function glycanPathViewer(path)
%glycanPathViewer read a Pathway object and return a graphical representation  
% of the glycosylation network.
%
% glycanPathViewer(pathwayObj) visualizes the glycosylation pathway.
%
% Example 1:
%  oglypath=Pathway.loadmat('glypathexample.mat');
%  glycanPathViewer(oglypath);  
%
%
% See also glycanViewer,glycanFileViewer,glycanNetFileViewer,displayset,displayget.
golgi  = Compt('golgi');
name = 'Glycosylation network';
gtestModel = GlycanNetModel(golgi,path,name);
glycanNetViewer(gtestModel);

end

