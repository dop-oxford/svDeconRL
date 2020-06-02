# svDeconRL
Free Spatially-Variant Deconvolution based on the Richardson-Lucy algorithm with total variation regularisation

A publication accompanying the code has been published in [x](link) (open access)\[1\]:

```
Raphaël Turcotte, Eusebiu Sutu, Carla C. Schmidt, Nigel J. Emptage, Martin J. Booth (2020).
"Title",
Journal, doi: X
```
The repository contains the MATLAB codes requires to deconvolve a 2D image acquired with a system having a spatially variant point response. The deconvolution is based on a modified Richardson-Lucy algorithm with total variation regularisation to account for the spatially variant point response. Sample datasets are also provided.

Code: TEST
	\t1) RLTV_SVdeconv.m: Function performing Richardson-Lucy deconvolution with total variation (TV) regularisation using a spatially-variant PSF model based on eigen-PSF decomposition.
	\t2) TVL1reg.m: Function calculating the total variation regularisation factor for the RL algorithm using the L1 norm over the divergence of the array M 
	\t3) ScriptLRTV.m:  Sample script iteratively calling the RLTV_SVdeconv() function for the given inputs over several number of modes, number of iterations, and TV coefficient values.
	\t4) makeEdgeAtt.m: This function create a square array of amplitude 1 with the edges attenuated to zero using a cos function for a given number of pixels.

Datasets:
	- Illumination focal spot image from From Fig. 3 in ref \[1\].
	- Bead image from From Fig. 4. in ref \[1\].