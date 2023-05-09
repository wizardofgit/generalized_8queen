/*********************************************
 * OPL 22.1.1.0 Model
 * Author: Kacper
 * Creation Date: 18 kwi 2023 at 15:31:55
 *********************************************/


// problem dla jednej figury - królowej
/*
 int n = 8; //dimensions of the board - n x n
 int q = 8; //number of queens
 dvar boolean x[1..n][1..n];
 
 maximize sum(i in 1..n, j in 1..n) x[i][j] - q;
 
 subject to{
   //constraints for queens
   forall(i in 1..n) sum(j in 1..n) x[i][j] <= 1;
   forall(i in 1..n) sum(j in 1..n) x[j][i] <= 1;
   sum(i in 1..n) x[i][i] <= 1;
   sum(i in 1..n, j in 1..n) x[i][j] <= q;
 }
 
 int d = sum(i in 1..n, j in 1..n) x[i][j] - q;
 
 execute{
   d;
 }*/
 
 //problem dla więcej figur - królowa, król i wieża
 int n = 5; //dimensions of the board - n x n
 int q = 0; //number of queens
 int k = 0; //number of kings
 int t = 5; //number of towers
 dvar boolean queens[1..n][1..n];	//decision matrix/board for queens
 dvar boolean kings[1..n][1..n];	//decision matrix/board for kings
 dvar boolean towers[1..n][1..n];	//decision matrix/board for towers
 
 maximize sum(i in 1..n, j in 1..n) queens[i][j] - q + sum(i in 1..n, j in 1..n) kings[i][j] - k + sum(i in 1..n, j in 1..n) towers[i][j] - t;
 
 subject to{
   /* constraints for queens */
   forall(i in 1..n) sum(j in 1..n) queens[i][j] <= 1;	//there can bo no more than one queen in said row
   forall(i in 1..n) sum(j in 1..n) queens[j][i] <= 1;	//there can bo no more than one queen in said column
   sum(i in 1..n) queens[i][i] <= 1;	//up to one queen can be on the diagonal
   sum(i in 0..n-1) queens[n-i][n-1] <= 1;
   sum(i in 1..n, j in 1..n) queens[i][j] <= q; //no more queens placed than integer q
   forall(i in 1..n-1) sum(j in 0..i-1) queens[i-j][1+j] <= 1;	//diagonals "/" upper
   forall(i in 2..n) sum(j in n..n-i) queens[j][i-n-j] <= 1;	//diagonal "/" lower
   forall(i in 2..n-1) sum(j in 1..n-i) queens[j][i+j] <= 1; //diagonal "\" upper
   forall(i in 2..n-1) sum(j in 1..n-i) queens[i+j-1][j] <= 1; //diagonal "\" lower
   
   /* constrains for kings */
   forall(i in 2..n-1, j in 2..n-1) sum(a in -1..1, b in -1..1) (kings[i+a][i+b]) <= 1;	//in a 'square' area there can be no more than one king
   sum(i in 1..n, j in 1..n) kings[i][j] <= k;	//no more kings placed than k
   
   /* constraints for towers */
   sum(i in 1..n, j in 1..n) towers[i][j] <= t;	// no more than t towers
   forall(i in 1..n) sum(j in 1..n) towers[i][j] <= 1;	//no more than one tower per column
   forall(i in 1..n) sum(j in 1..n) towers[j][i] <= 1;	//no more than one tower per row
   
   /* constraints for interactions between figures 
   legacy 
   forall(i in 1..n) sum(j in 1..n) (queens[i][j] + kings[i][j] + towers[i][j]) <= 1;
   forall(i in 1..n) sum(j in 1..n) (queens[j][i] + kings[j][i] + towers[j][i]) <= 1;
   sum(i in 1..n) (queens[i][i] + kings[i][i] + towers[i][i]) <= 1;	//diagonal "/"
   sum(i in 1..n) (queens[i][n-i+1] + kings[i][n-i+1] + towers[i][n-i+1]) <= 1;	//diagonal "\"
   forall(i in 1..n-1) sum(j in 0..i-1) (queens[i-j][1+j] + kings[i-j][1+j] + towers[i-j][1+j]) <= 1;	//diagonals "/" upper
   forall(i in 2..n) sum(j in n..n-i) (queens[j][i-n-j] + kings[j][i-n-j] + towers[j][i-n-j]) <= 1;	//diagonal "/" lower
   forall(i in 2..n-1) sum(j in 1..n-i) (queens[j][i+j] + kings[j][i+j] + towers[j][i+j]) <= 1; //diagonal "\" upper
   forall(i in 2..n-1) sum(j in 1..n-i) (queens[i+j-1][j] + kings[i+j-1][j] + towers[i+j-1][j]) <= 1; //diagonal "\" lower
   */
   
   /* constraints for interactions between figures */
   forall(i in 1..n) sum(j in 1..n) (queens[i][j] + towers[i][j]) <= 1;	//one tower or queen per column
   forall(i in 1..n) sum(j in 1..n) (queens[j][i] + towers[j][i]) <= 1; //one tower or queen per row
   sum(i in 1..n) (queens[i][i]*n + kings[i][i] + towers[i][i]) <= n;	//diagonal "\"
   sum(i in 1..n) (queens[n-i+1][i]*n + towers[n-i+1][i]+kings[n-i+1][i]) <= n;	//diagonal "/"
   forall(i in 1..n-1) sum(j in 0..i-1) (queens[i-j][1+j]*i + towers[i-j][1+j]) <= i;	//diagonals "/" upper
   forall(i in 2..n) sum(j in n..n-i) (queens[j][i-n-j]*(n-i+1) + towers[j][i-n-j]) <= n-i+1;	//diagonal "/" lower
   forall(i in 2..n-1) sum(j in 1..n-i) (queens[j][i+j]*(n-i+1) + towers[j][i+j]) <= n-i+1; //diagonal "\" upper
   forall(i in 2..n-1) sum(j in 1..n-i) (queens[i+j-1][j]*(n-i+1) + towers[i+j-1][j]) <= n-i+1; //diagonal "\" lower
   forall(i in 2..n-1, j in 2..n-1) sum(a in -1..1, b in -1..1) (kings[i+a][j+b]*9+queens[i+a][j+b]+towers[i+a][j+b]) <= 9;	//no more than one king in a 3*3 area, but may be more queens/towers
   
   /* constraints for not occupying the same space */
   forall(i in 1..n, j in 1..n) queens[i][j] + kings[i][j] + towers[i][j]  <= 1;	//no figure can occupy the same space
 }
 
 int d_q = sum(i in 1..n, j in 1..n) queens[i][j] - q;
 int d_k = sum(i in 1..n, j in 1..n) kings[i][j] - k; 
 int d_t = sum(i in 1..n, j in 1..n) towers[i][j] - t; 
 int f = sum(i in 1..n, j in 1..n) queens[i][j] - q + sum(i in 1..n, j in 1..n) kings[i][j] - k + sum(i in 1..n, j in 1..n) towers[i][j] - t;
 int decision = 0;
 
  execute{
   d_q;
   d_k;
   d_t;
   if(f == 0) {decision = 1};	//binary decision if all of the figures can be placed
   decision;
    }