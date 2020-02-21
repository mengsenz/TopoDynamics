# TopoDynamics

This package contains example codes and data accompanying the paper "Topological
portraits of multiscale coordination dynamics" by Mengsen Zhang, William D.
Kalies, J. A. Scott Kelso, and Emmanuelle Tognoli (https://arxiv.org/abs/1909.08809). 

It produces *topological recurrence plots* shown in Fig 8 of the paper. The scripts were developed by Mengsen Zhang (mengsenzhang@gmail.com). Note that the package was designed to demonstrate how the method proposed in the paper can be implemented. Please cite the above paper for reusing all or part of the package (except for pre-existing software listed below: SPLINTFIT, Perseus, and Persistence Landscape Toolbox).

## run the example
The example analyses are implemented in `example_analysis.m`. To compute the topological recurrence of the three-agent example, load `data/data_3agents.mat`; likewise for the eight-agent example, load `data/data_8agents.mat`.

## environment
The scripts were developed and tested in MATLAB R2017 and R2019 (os: Windows 10).

## dependencies
This package includes pre-existing software: 

**SPLINEFIT** (`tools\SPLINFIT`), MATLAB toolbox by Jonas Lundgren https://www.mathworks.com/matlabcentral/fileexchange/71225-splinefit
It is used for frequency-phase decomposition.

**Perseus** (`tools\topology\perseusWin.exe`), persistent homology software developed by Vidit Nanda, which can be found here: 
http://people.maths.ox.ac.uk/nanda/perseus/
See paper: Konstantin Mischaikow and Vidit Nanda. Morse Theory for Filtrations and Efficient Computation of Persistent Homology. Discrete & Computational Geometry, Volume 50, Issue 2, pp 330-353, September 2013.

**Persistence Landscape Toolbox** (`tools\PLandscape`) developed by Paweł Dłotko, which is available here: 
 https://www.math.upenn.edu/~dlotko/persistenceLandscape.html
See paper: Bubenik, P., & Dłotko, P. (2017). A persistence landscapes toolbox for topological statistics. Journal of Symbolic Computation, 78, 91-114.

## suggestion
For more efficient computation of persistent homology, [Ripser](https://github.com/Ripser/ripser) maybe used instead of Perseus. 