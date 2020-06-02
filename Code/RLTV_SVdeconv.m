function result = RLTV_SVdeconv(image, PSF, fCoeffMaps, iterations, modes, lambda, saveoption, name)

% Usage: Perform Richardson-Lucy deconvolution with total variation regularisation
% using a spatially-variantPSF model based on eigen-PSF decomposition.
%
% Inputs:
%   image: 2D array to be deconvolved (double)
%   PSF: name of the eigen-PSFs image stack (string)
%   fCoeffMaps: name of the eigen-coefficients image stack (string)
%   iterations: number of iterations to use for deconvolution (int)
%   modes: number of eigen-PSFs to use for deconvolution (int)
%   lambda: total variation coefficient
%   saveoption: option for saving image at each iteration when = 1
%   name:filename for saving in saveoption
%
% Output:
%   result: deconvolved image
%
% By Raphael Turcotte (2020)
% University of Oxford
% raphael.turcotte@pharm.ox.ac.uk / rturcotte861@gmail.com


%% Initialisation
OTF = zeros(size(image,1),size(image,2),modes);
PSF1 = double(imread(PSF, 'index', 1));
PSFi = zeros(size(PSF1,1),size(PSF1,2),modes);
OTF_hat = zeros(size(image,1),size(image,2),modes);
PSFi_hat = zeros(size(PSF1,1),size(PSF1,2),modes);
emin = 1e-6; % Define variable to avoid division by zero

% Load all needed eigen-PSFs and convert them to OTFs
fn = image; % at the first iteration
ratio = image;
for j = 1:modes
    PSFi(:,:,j) = double(imread(PSF, 'index', j));
    OTF(:,:,j) = psf2otf(PSFi(:,:,j),size(image));
end

for j = 1:modes
    PSFi_hat(:,:,j) = PSFi(end:-1:1,end:-1:1,j);
    OTF_hat(:,:,j) = psf2otf(PSFi_hat(:,:,j),size(image));
end


%% Iteration of the sv Lucy-Richardson algorithm
for i=1:iterations
    
    % Calcualte the total variation regularisation factor
    tv = TVL1reg(fn, lambda);
    
    % Frequency object estimate
    ffn = coeffcorr(image, fCoeffMaps, fn, modes);
    
    % Frequency image estimate
    Hfn = sumOTF(OTF,ffn,modes);
    
    % Image estimate
    iHfn = ifft2(Hfn); % inverse Fourier transform of the frequency image estimate
    
    % Relative blurring
    ratio(iHfn >= emin) = image(iHfn >= emin) ./ iHfn(iHfn >= emin);
    ratio(iHfn < emin) = emin;
    
    % Frequency relative blurring
    iratio = coeffcorr(image, fCoeffMaps, ratio, modes);
    
    % Frequency error
    res = sumOTF(OTF_hat, iratio, modes);
    
    % Error
    ires = ifft2(res); % inverse Fourier transform of the frequency error
    
    % Correction of frequency error estimate
    fn = tv.*ires.*fn;
    
    if saveoption == 1
        % Save deconvolved image
        RL = uint8(255*fn/max(max(fn)));
        fSave = strcat(name, int2str(modes),'_Iter', int2str(i),'.tif');
        imwrite(RL, fSave,'tif');
    end
    
end

result = abs(fn);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: Apply the coefficient map (X) correction to the spatial
% variable Y and output the FFT of the corrected Y over all modes.
%
function Out = coeffcorr(image, X, Y, modes)

%Pre-allocation
Out = zeros(size(image,1), size(image,2),modes);
for j = 1:modes
    if j > 1
        Coeff = double(imread(X, 'index',j-1));
    else
        Coeff = 1;
    end
    Out(:,:,j) = fft2((Coeff) .* Y); % Fourier transform of the relative blurring
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: Sum the multiplication of OTFs with their corrected
% spatial frequency images, contained in X, over all modes (convolution).
%
function Out = sumOTF(OTF, X, modes)
Out = 0;
for j = 1:modes
    Out = Out + OTF(:,:,j).*X(:,:,j);
end
end