function linkJava = linkMat2Java(linkMat,varargin)
% LINKMAT2JAVA convert a MATLAB GlycanLinkage object to a Java Linkage object
%
%  LINKJAVA = LINKMAT2JAVA(GLYCANLINKMAT) reads a GlycanLinkage
%   object and returns a Java LINKAGE object.
%
%  LINKJAVA = GLYCANLINKMAT.LINKMAT2JAVA is equivalent to LINKJAVA
%   = LINKMAT2JAVA(GLYCANLINKMAT).
%
% See also GLYCANLINKAGE/GLYCANLINKAGE
import org.eurocarbdb.application.glycanbuilder.Linkage;
import org.eurocarbdb.application.glycanbuilder.Residue;
import org.eurocarbdb.application.glycanbuilder.Bond;

parentJava  = linkMat.getParent.residueMat2Java;
childJava     = linkMat.getChild.residueMat2Java;

bondsJava    = java.util.Vector;
bondsMat = linkMat.getBonds;
for i = 1: size(bondsMat,1);
    bondMatElem = bondsMat(i,1);
    bondJavaElem = Bond(bondMatElem.getPosParent,bondMatElem.getPosChild);
    bondsJava.add(bondJavaElem);
end

linkJava    =  Linkage(parentJava,childJava,bondsJava);
end

