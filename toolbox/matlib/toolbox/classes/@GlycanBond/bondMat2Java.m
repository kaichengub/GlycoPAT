function glycanBondJava = bondMat2Java(glyBondobj)
%BONDMAT2JAVA convert a MATLAB GlycanBond object to a Java Bond object
%
%     bondJava =  BONDMAT2JAVA(bondMat) takes an input of Matlab
%     GlycanBond object and returns a Java Bond object. It can also be
%     written as  bondJava =  bondMat.BONDMAT2JAVA. 
%
%  See also GLYCANBOND/GLYCANBOND
glycanBondJava = org.eurocarbdb.application.glycanbuilder.Bond(...
    glyBondobj.getPosParent,glyBondobj.getPosChild);
end