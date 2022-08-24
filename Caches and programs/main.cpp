#include <iostream>
#include <vector>
#include <chrono>
#include <random>
#include <cmath>
#include <vector>

#define MAX 50000
using namespace std;

// Definicion de Matrices
vector<vector<int>> A(MAX, vector<int>(MAX, 0));
vector<int> B(MAX);
vector<int> C(MAX);


// LLenar las matrices
void init(){
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
    
  init();

  srand(time(0));
  std::random_device rd;
  std::mt19937 gen(rd());
  std::chrono::time_point<std::chrono::high_resolution_clock> start, end;
  start = std::chrono::high_resolution_clock::now();
 
  multiIJ();
   // mutiJI();
    
    
 end = std::chrono::high_resolution_clock::now();
 int64_t duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end-start).count();
 cout<<"Time -> "<< duration <<" ns"<< endl;
    
 

    
}
