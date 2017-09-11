function glycanRxnViewer(rxnObj)
%glycanRxnViewer read a Rxn object and return a graphical representation  
% of the reaction.
%
% glycanRxnViewer(rxnobj) visualizes a single glycosylation reaction.
%
% Example 1:
%  oglyrxn=Rxn.loadmat('glyrxnexample.mat');
%  glycanRxnViewer(oglyrxn);  
%
%
% See also glycanViewer,glycanFileViewer,glycanNetFileViewer,displayset,displayget.
golgi  = Compt('golgi');
name = 'Glycosylation network';
pathObj = Pathway;
reactObj = rxnObj.reac;
prodObj = rxnObj.prod;
pathObj.addGlycan(reactObj);
pathObj.addGlycan(prodObj);
pathObj.addRxn(rxnObj);
gtestModel = GlycanNetModel(golgi,pathObj,name);
glycanNetViewer(gtestModel);

end

