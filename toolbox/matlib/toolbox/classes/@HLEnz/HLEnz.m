classdef HLEnz < Enz
%HLENZ  class representing a hydrolase enzyme
% An HLENZ object is a generic representation of a  hydrolase.
%  It consists of a list of hydrolase properties including substrate,
%   functional group removed from substrate, bond hydrolyzed, 
%   product 1 and product 2.
%
% HLENZ properties:
%  substrate       -  substrate enzyme acts
%  bond            -  bond enzyme breaks
%  hlprod1_h       -  product 1 with hydrogen
%  hlprod2_oh      -  product 2 with hydroxy group
%  resfuncgroup    -  residue functional group removed
% 
% HlEnz method
%  HlEnz           -  constructor
%
% See also PATHWAY, RXN, COMPT, GLYCANSPECIES.

% Author: Gang Liu
% Date Last Updated: 6/11/2013
    properties
        substrate
        hlprod1_h
        hlprod2_oh
        bond
    end
    
   properties
        %resfuncgroup the functional glycosyl group for the enzyme-catalyzed reaction
        %     resfuncgroup property is a ResidueType object.
        %
        %  See also GTENZ
        resfuncgroup
   end
    
    % final value
    properties
        ecnopre_disp='ec3';
        familyname='hydrolase';
    end
    
    methods
        function obj=HLEnz(varargin)
            narginchk(0,1);
            
            if(nargin==0)
                obj.ecno=[3;0;0;0];
                return;
            end
            
            if(nargin==1)
                obj.ecno = varargin{1};
            end
            
            if(isprop(obj,'ecno')&&(~isempty(obj.ecno)))
                try
                    queryEnzRes    = queryIUBMBDB(obj.ecno);
                    obj.name       = queryEnzRes.name ;
                    obj.systname   = queryEnzRes.systname;
                    obj.othernames = queryEnzRes.othernames;
                    obj.reaction   = queryEnzRes.rxn;
                catch err
                    % do nothing
                    % keep the field empty
                    
                end
            end
            
        end
    end
 
end

