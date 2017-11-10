# fuzzyrose

This library includes functions for plotting fuzzy rose diagrams in Matlab. Fuzzy rose diagrams are a compact visual representation to show vectors of fuzzy numbers. Each component of the vector is represented as a petal on a circular diagram. The size of each petal is proportional to the size of the corresponding value and the shape of the petal indicates the range of uncertainty. For more details see the following paper.

[A. R. Buck and J. M. Keller, "Visualizing uncertainty with fuzzy rose diagrams," in 2014 IEEE Symposium on Computational Intelligence for Engineering Solutions (CIES), Orlando, FL, 2014, pp. 30-36.](https://doi.org/10.1109/CIES.2014.7011827)

Fuzzy numbers are represented in this library as the union of many alpha cuts. By default, 1000 linearly spaced values are used, representing the left and right endpoints of each alpha cut. This results in a 1000x2 matrix for each fuzzy number. Vectors of fuzzy numbers are created by concatenating in the second dimension. A vector of M fuzzy numbers with N alpha cuts is therefore represented as an Nx(2xM) matrix. Functions are provided for generating standard fuzzy numbers (crisp, interval, triangular, and trapezoidal).

Basic functionality is also provided for plotting fuzzy weighted graphs. Circular fuzzy rose plots are used for graph nodes with fuzzy weights and rectilinear plots are used to show fuzzy weights on graph edges. Examples are provided to generate random fuzzy weighted graphs.
