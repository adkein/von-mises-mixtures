von-mises-mixtures
====

A sampler for a low-rank series of positions, neighboring pairs coupled by a mixture-of-von-Mises-distributions on a 2D spherical surface. This draws on ideas in [Smith et al. (2012)](http://jmlr.org/proceedings/papers/v22/smith12/smith12.pdf).


The code
----

* generate\_path.m: A script that draws a sample from 

    `p(X) = p(x_0) \prod_{t=1}^T p(x_t|x_{t-1})` 

    where 

    `p(x_t|x_{t-1})` 

    is a mixture of products of von Mises distributions, one for `x_t` and one for `x_{t-1}`.

* logVmfPdf.m: Code provided along with [PRML](http://research.microsoft.com/en-us/um/people/cmbishop/prml/) for drawing samples from the von Mises distrbution in arbitrary dimension.

* [sphere3d.m](http://www.mathworks.com/matlabcentral/fileexchange/23385-nf2ff/content/sphere3d.m): Code written by J. M. DeFreitas for drawing a wire mesh of a sphere, used here for plotting sample paths.
