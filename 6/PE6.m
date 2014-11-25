%% CMPUT 466/551 (2014)
%% PE#6 script

%% HMM State transition matrix
A = [0.80, 0.20; 0.1 0.9];

%% HMM Emission Matrix
B = [1/6 4/5; 1/6 1/25; 1/6 1/25; 1/6 1/25; 1/6 1/25; 1/6 1/25];

%% Observations from HMM
O = [4, 1, 2, 3, 1, 3, 1, 1, 5, 6];

%% initial state distribution
%This is P(D0)
phi_0 = [0.5 0.5];

%Using the initial state distribution, predict the state distribution
%before evidence i.e. P(D1)
%You code here for (a)

fprintf('(a) P(D_1)')

phi = phi_0 * A;

%% Uncomment this portion to use appropriate variables  

[alpha, P_O] = forward(O, phi, A, B);

beta = backward(O, A, B);

dstar = viterbi(O, phi, A, B);

%% Now answer the Questions:

% (b): P(D_t = r | S_1:t)
fprintf('(b): P(D_t = r | S_1:t)')
% alpha is needed here
b = sum(alpha(:,2))

% (c): P(D_t = r | S_1:10)
fprintf('(c): P(D_t = r | S_1:10)')
% gamma is needed here (See Eqn 27 in Rabiner 1989 for details)
c = sum(beta(:,2))

% (d): argmax_d P(D=d | S_1:10)
fprintf('(d): argmax_d P(D=d | S_1:10)\n')
% use viterbi algorithm
d = dstar

% (e): P_+L(S_1:10) and P_-L(S_1:10)
fprintf('(e): P_+L(S_1:10) and P_-L(S_1:10)\n')
A_L = [0.75 0.25; 0.05 0.95];

[alpha, P_O] = forward(O, phi, A_L, B);
beta = backward(O, A_L, B);
dstar = viterbi(O, phi, A_L, B);
b = sum(alpha(:,2))
c = sum(beta(:,2))
d = dstar


