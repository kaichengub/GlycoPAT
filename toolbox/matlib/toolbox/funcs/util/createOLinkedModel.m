linearmodelfilename = 'GlycoSBML216_Rev.xml';
linearmodelfilename = which(linearmodelfilename);
Olinkedmodel = TranslateSBML(linearmodelfilename);

numSpecies = 20;
for i=1:numSpecies
    glycanFileName = ['S' num2str(i) '.glycoct_xml'];
    oGlycanArray(i)=    glycanMLread(glycanFileName);
end


% create a container map for glycan annotation string
glycansMap = containers.Map;
for i=1:numSpecies
    glycanSpeicesName = ['S' num2str(i)];
    glycansMap(glycanSpeicesName) = glycanStrwrite(oGlycanArray(i));
end

% adds Glycan Annotation to a SBML_model structure 
Olinkedmodel=addGlycanAnnotation(Olinkedmodel,glycansMap);

%export glycan annoataed SBML model
outputfileName = 'OlinkedModel_wtannot.xml';
OlinkedNetModel = GlycanNetModel(Olinkedmodel);
glycanNetSBMLwrite(OlinkedNetModel,outputfileName);
