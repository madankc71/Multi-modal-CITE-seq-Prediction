# Multi-modal-CITE-seq-Prediction

I have applied parallel multivariate regression and gradient descent to iteratively improving the prediction that have the accuracy of 81%.

Protein expression is measured using Antibody-Derived Tags (ADT), while single-cell RNA-sequencing is used to quantify the abundance of RNA transcripts in each cell. The goal of this project is to predict the protein expression profile of 25 proteins in 1000 test cells given the gene expression of 639 genes in those cells. In order to predict this information, there are 4000 cells from the same experiment with information on all 25 proteins and 639 genes. Using the training data, I have predicted the protein expression.

Parametric methods such as K-means and KNN will not perform very well because you cannot fully appreciate signal substructure across both samples and features. Therefore, I have applied Multivariate regression and gradient descent from scratch which learns a model on the training set that predicts each ADT feature in terms of all RNA features, then plugging in for the ADT features given the learned coefficients on the test set.
