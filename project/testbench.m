clear;clc;
syms th1 d2 th3

c1 = cos(th1);
s1 = sin(th1);
c3 = cos(th3);
s3 = sin(th3);

A1 = [c1 0 -s1 3*c1; s1 0 c1 3*s1; 0 -1 0 0; 0 0 0 1]

A2 = [1 0 0 0; 0 0 -1 0; 0 1 0 d2; 0 0 0 1]

A3 = [c3 -s3 0 2*c3; s3 c3 0 2*s3; 0 0 1 0; 0 0 0 1]

T = A1*A2*A3