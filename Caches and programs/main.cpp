#include <iostream>
#include <vector>
#include <chrono>
#include <random>
#include <cmath>
#include <vector>

#define MAX 5000
using namespace std;
unsigned t0, t1;

// Definicion de Matrices
vector<vector<double>> A(MAX, vector<double>(MAX,0)); /// MAX cantidad de elementos de tipo vector<MAX> y rellenado con 0's
vector<double> B(MAX);
vector<double> C(MAX);


// LLenar las matrices
void llenado(){
    for (int i = 0; i < MAX; i++){
        for (int j = 0; j < MAX; j++){
             A[i][j] = rand() % 1000;
            }
        }
    for (int i = 0; i < MAX; i++){
        B[i] = rand() % 1000;
        C[i] = 0;
    }
}


void multiIJ(){
    for (int i = 0 ; i < MAX; i++){
        for(int j = 0; j < MAX; j++){
            C[i] += A[i][j] * B[j];
        }
        
    }
    
}

void mutiJI(){
    for (int j = 0 ; j < MAX; j++){
        for(int i = 0; i < MAX; i++){
            C[i] += A[i][j] * B[j];
        }
        
    }
}


int main(){
    
  llenado();

  t0=clock();
 
  multiIJ();
  //mutiJI();
    
  t1=clock();
    
  double time = (double(t1-t0)/CLOCKS_PER_SEC);
  cout << "Tiempo de ejecucion -> " << time << endl;
    
    
}
