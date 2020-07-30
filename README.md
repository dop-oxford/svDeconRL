# svDeconRL
Free Spatially-Variant Deconvolution based on the Richardson-Lucy algorithm with total variation regularisation

A publication accompanying the code has been published in [BOEx](https://www.osapublishing.org/DirectPDFAccess/DB8FF5B0-388C-4989-974FCCEEF50858D8_433935/boe-11-8-4759.pdf?da=1&id=433935&seq=0&mobile=no) (open access)\[1\]:

```
Raphaël Turcotte, Eusebiu Sutu, Carla C. Schmidt, Nigel J. Emptage, Martin J. Booth.
"Deconvolution for multimode fiber imaging: modeling of spatially variant PSF",
Biomedical Optics Express 2020:11(8);4759-4771. DOI: 10.1364/BOE.399983
```
The repository contains the MATLAB codes requires to deconvolve a 2D image acquired with a system having a spatially variant point response. The deconvolution is based on a modified Richardson-Lucy algorithm with total variation regularisation to account for the spatially variant point response. Sample datasets are also provided.

* Code:
	- RLTV_SVdeconv.m: Function performing Richardson-Lucy deconvolution with total variation (TV) regularisation using a spatially-variant PSF model based on eigen-PSF decomposition.
	- TVL1reg.m: Function calculating the total variation regularisation factor for the RL algorithm using the L1 norm over the divergence of the array M 
	- ScriptLRTV.m:  Sample script iteratively calling the RLTV_SVdeconv() function for the given inputs over several number of modes, number of iterations, and TV coefficient values.
	- makeEdgeAtt.m: This function create a square array of amplitude 1 with the edges attenuated to zero using a cos function for a given number of pixels.

* Datasets:
	- Illumination focal spot image from From Fig. 4 in ref \[1\].
	- Bead image from From Fig. 5. in ref \[1\].
