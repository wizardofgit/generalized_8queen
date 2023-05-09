# generalized_8queen
Generalizaed 8-queen problem with 3 figures and n x n board

# Description
The code written in IMB ILOG CPLEX aims to solve a NP-problem that is a generalization of the 8-queen problem.
As input it takes variables: n - size of the board, q - number of queens to place, k - number of kings to place and t - number of towers to place.
It outputs 3 decision boards n x n, in which '1' means placing of a certain figure (queens, kings or towers respectively) and '0' means not placing it there.

# Goal function
The goal is to maximize the number of placed figures on the board. The goal function is represented as f(queens, kings, towers) = sum(queens, kings, towers) - (q+t+k).
If the code manages to place all figures onto the board, it will display goal funtion equal 0 (all figures successfully placed). If for example 2 figures weren't placed, the goal function
will be assigned value -2 et cetera.

# Constraints
The constraints are written so that no figure can attack any another figure. In other words, no figure 'collides' with any other.
For example for each row, column and 'diagonal' there can be no more than one queen. But there can me multiple towers or more than one king.
