function sbml_structure_singlecompt = convertToSingleCompt(sbml_structure_multicompt)
% create a global compartment
[level, version] = GetLevelVersion(sbml_structure_multicompt);
newComptName ='Global';
nCompts =  length(sbml_structure_multicompt.compartment)       ;
for i=1:nCompts
     newComptName =[newComptName '_' Compartment_getName(sbml_structure_multicompt.compartment(1,i))];    
end
comptGlobal = Compartment_create(level,version);
comptGlobal = Compartment_setName(comptGlobal,newComptName);
comptGlobal = Compartment_setId(comptGlobal,[newComptName '_' num2str(nCompts) 'compts']);

comptGlobal.constant=1;
comptGlobal.size=1;

sbml_structure_multicompt.compartment = comptGlobal;
sbml_structure_multicompt.id = sbml_structure_multicompt.name;

for i=1:length(sbml_structure_multicompt.species)
    sbml_structure_multicompt.species(1,i)= Species_setCompartment(sbml_structure_multicompt.species(1,i),...
        Compartment_getId(comptGlobal));
end

sbml_structure_singlecompt=sbml_structure_multicompt;
end
