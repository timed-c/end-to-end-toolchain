#include<stdio.h>

unsigned int a[128][128];
unsigned int b[128][128];
unsigned int c[128][128];

unsigned int fact(unsigned int n){
  int r = 1;
  while(n > 1){
    r = r * n;
    n--;
  }
  return r;
}

unsigned int array_mul(unsigned int N, unsigned int K, unsigned int M){
  int i, j, k;
  for(i=0; i<N; i++)
	for(j=0; j<M; j++) {
		c[i][j] = 0;
		for(k=0; k<K; k++)
			c[i][j] += a[i][k] * b[k][j];
	}
  return 0;
}

unsigned int factcall(unsigned int n){
  return fact(n+1) * 2;
}

unsigned int nested_loop(unsigned int n1, unsigned int n2){
  int i, j, res;
  res = 1;
  for(i=1; i<n1; i++)
	for(j=1; j<n2; j++)
		res += i*j;
}


