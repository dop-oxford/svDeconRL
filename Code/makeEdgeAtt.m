function edgeMask = makeEdgeAtt(L,ImDim)

% This function create a square array of dimension ImDim x ImDim
% of amplitude 1 with the edges attenuated to zero using a cos function
% to a length of L pixels.
%
% By Raphael Turcotte (2020)
% University of Oxford
% raphael.turcotte@pharm.ox.ac.uk / rturcotte861@gmail.com

edgeMask = ones(ImDim,ImDim);

for i = L:-1:1
    edgeMask(i,:) = cos((L+1-i)*pi/(L*2))*edgeMask(i,:);
    edgeMask(:,i) = cos((L+1-i)*pi/(L*2))*edgeMask(:,i);
    edgeMask(end+1-i,:) = cos((L+1-i)*pi/(L*2))*edgeMask(end+1-i,:);
    edgeMask(:,end+1-i) = cos((L+1-i)*pi/(L*2))*edgeMask(:,end+1-i);
end
