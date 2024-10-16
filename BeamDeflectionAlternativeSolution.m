% Parameters
L = 1;       % Length of the beam
N = 100;     % Number of grid points
dx = L / (N - 1); % Spatial step size
x = linspace(0, L, N); % Discretized spatial domain

% Initialize matrices
A = zeros(N, N);  % For solving M''
B = zeros(N, N);  % For solving u''

% Right-hand side for M'' = 1 (constant force)
F_M = ones(N, 1); 

% Apply boundary conditions for M: M(0) = 0, M(1) = 0
F_M(1) = 0;
F_M(end) = 0;

% Construct the finite difference matrix for M'' = 1
for i = 2:N-1
    A(i,i-1) = 1/dx^2;
    A(i,i) = -2/dx^2;
    A(i,i+1) = 1/dx^2;
end

% Apply boundary conditions to matrix A
A(1,:) = 0; A(1,1) = 1; % M(0) = 0
A(end,:) = 0; A(end,end) = 1; % M(1) = 0

% Solve for M
M = A \ F_M;

% Construct the finite difference matrix for u'' = M
for i = 2:N-1
    B(i,i-1) = 1/dx^2;
    B(i,i) = -2/dx^2;
    B(i,i+1) = 1/dx^2;
end

% Right-hand side for u'' = M
F_u = M;

% Apply boundary conditions for u: u(0) = 0, u(1) = 0
F_u(1) = 0;
F_u(end) = 0;

% Apply boundary conditions to matrix B
B(1,:) = 0; B(1,1) = 1; % u(0) = 0
B(end,:) = 0; B(end,end) = 1; % u(1) = 0

% Solve for u
u = B \ F_u;

% Plot the bending moment M and deflection u
figure;
subplot(2,1,1);
plot(x, M);
title('Bending Moment M');
xlabel('x'); ylabel('M(x)');

subplot(2,1,2);
plot(x, u);
title('Beam Deflection u');
xlabel('x'); ylabel('u(x)');