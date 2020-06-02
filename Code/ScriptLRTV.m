% This script iteratively call the RLTV_SVdeconv() function for the given
% inputs over number of modes and iterations and save thevspatially variant 
% Richardson-Lucy deconvolved output with total variation regularisation.
%
% By Raphael Turcotte (2020)
% University of Oxford
% raphael.turcotte@pharm.ox.ac.uk / rturcotte861@gmail.com

clear

% Input parameters
fPSFs = 'svPSFmodel_EigenPSFs_Illumination.tif'; % name of the eigen-PSFs image stack
fCoeffMaps ='svPSFmodel_CoeffMaps_Illumination.tif'; % name of the eigen-coefficients image stack
%fPSFs = 'svPSFmodel_EigenPSFs_Beads.tif'; % name of the eigen-PSFs image stack
%fCoeffMaps ='svPSFmodel_CoeffMaps_Beads.tif'; % name of the eigen-coefficients image stack


modeNum = [1,50,225]; % array of the number of eigen-PSFs to use for deconvolution
iteration = [1,50,500]; % array of the number of iterations to use for deconvolution
lambda = [0.002];
edgeL = 15;
sigma = 2;
saveoption = 0;

%% Prompt user to select folder/files to process
[~, Pathname] = uigetfile('*.tif', 'Pick a mat-file');

% Get list of files to process
dirData = dir(Pathname);      %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(Pathname,x),fileList,'UniformOutput',false);
else
    msgbox('No file in selected folder.','Invalid input','error');
    return
end

%% Iteration over files, then parameters

for L = 1:1:length(fileList)
    
    % Get filename string
    Filename = char(fileList(L));
    
    if contains(Filename, 'tif')     
        
        % Load image to deconvolved and convert to double
        Image = double(imread(Filename));
        
        % Cosine edge attenuation
        Image = makeEdgeAtt(edgeL, size(Image,1)).*Image;
        
        % Iterative deconvolution over the number of modes and iterations
        for j = 1:length(modeNum)
            for k = 1:length(iteration)
                for i = 1:length(lambda)
                    
                    % Call the Lucy-Richardson deconvolution function
                    res_RL = RLTV_SVdeconv(Image, fPSFs, fCoeffMaps, iteration(k), modeNum(j), lambda(i), saveoption, Filename);
                    
                    if saveoption == 0
                        % Convert deconvolved image to 8-bit
                        res_RL = imgaussfilt(res_RL, sigma);
                        RL = uint8(255*res_RL/max(max(res_RL)));
                        
                        % Save deconvolved image
                        fSave = strcat(Filename(1:(end-4)),'_Mode', int2str(modeNum(j)),'_Iter', int2str(iteration(k)),'_Lambda', int2str(lambda(i)*1000),'.tif');
                        imwrite(RL, fSave,'tif');
                    end
                    
                end
            end
        end
        
    end
end

msgbox('Analysis Completed');


