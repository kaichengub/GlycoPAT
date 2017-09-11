function out = varFor(VEC,T,N)
%  OUT = varFor(VEC,T,N)
% Calls ITERATE which uses recursion to emulate "length(VEC)" for loops of
% length T doing some meaningful operation. This results in T^N
% iterations.
%
% Currently ITERATE just multiplies vector elements by 2 in each
% iteration. So
% varFor([1 2 3],3,3);
% returns [1 2 3] * 2^(N^T) = [1 2 3] * 2^(3^3)
%global out
out=[];
a=0;
%just act as a wrapper for ITERATE
[VEC,out]=iterate(a,out,VEC,T,N,[]);
end


function [VEC,out] = iterate(a,out,VEC,T,N,INDEXVEC)
%global out
% VEC = iterate(VEC,T,N)
% VEC = iterate(VEC,T,N,[])
% iterate some operation on VEC T^N times using recursion and a single for LOOP
% set this to zero to supress INDEXVEC displays
%DISPINDEXVEC = 1;

%if the INDEXVECTOR wasn't specifies (first time called)
if isempty(INDEXVEC) % || nargin == 3 
    INDEXVEC = ones(1,N); %initialize index vector
end

% if N < 1
%     error(sprintf('ITERATE called with N < 0 (N = %d)',N));
% end

%for loop
for i = 1:T
    %index vector (INDEXVEC(1) is outermost FOR LOOP index)
    INDEXVEC(length(INDEXVEC)-N+1) = i;
    %we can do slightly different pre- and post-for loop calcs depending on
    %the FOR loop we are about to enter (determined by N)
    switch N
        case 1
    %meaningful code here:
       %VEC = VEC.*2; %this ends up multiplying each element of VEC by 2^(T^N)
      %show the index vectors to make sure things are working as they should
% fprintf(DISPINDEXVEC,['INDEXVEC: ',repmat('%d',1,length(INDEXVEC)),'\n'],INDEXVEC);
    a=a+1;
%     if out==[]
%     out(a,:)=[out, INDEXVEC]
%     else
        out=[out;INDEXVEC];
%     end
    otherwise %if no code between loops
      [VEC,out] = iterate(a,out,VEC,T,N-1,INDEXVEC);
%           out(a,:)=[out, INDEXVEC]
    end
end
end
