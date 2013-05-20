von_mises_mixtures
==================

A sampler for a low-rank series of positions, neighboring pairs coupled by a mixture-of-von-Mises-distributions on a 2D spherical surface. This draws on the ideas in: 

Smith, C., Wood, F., and Paninski, L. (2012). Low rank continuous-space graphical models. In Proc. 15th Intl. Conf. on Artificial Intelligence and Statistics (AISTATS), pages 1064-1072.

### Code

* generate_path.m: A script that draws a sample from ``p(X) = p(x_0) \prod_{t=1}^T p(x_t|x_{t-1})`` where ``p(x_t|x_{t-1})`` is a mixture of products of von Mises distributions, one for ``x_t`` and one for ``x_{t-1}``.

* logVmfPdf.m: Code that comes with Bishop's book the draws from the von Mises distrbution in arbitrary dimension.

* sphere3d.m: Code by JM DeFreitas that draws a wire mesh of a sphere. Used here for plotting sample paths.
