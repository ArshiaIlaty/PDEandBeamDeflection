% Parameters
L = pi/2;  % length of the interval
N = 100;   % number of grid points
x = linspace(0, L, N); % discretized domain
dx = L / (N - 1);

% Initialize the matrix and right-hand side
K = zeros(N, N); % stiffness matrix
F = ones(N, 1);  % right-hand side (since -∆u + u = 1)

% Fill the stiffness matrix using finite differences for -∆u + u
for i = 2:N-1
    K(i,i-1) = -1 / dx^2;  % contribution from second derivative
    K(i,i) = 2 / dx^2 + 1; % contribution from the u term
    K(i,i+1) = -1 / dx^2;
end

% Apply Neumann boundary conditions
K(1,1) = 1;   % for ∂u/∂n(0) = 1
K(N,N) = 1;   % for ∂u/∂n(π/2) = 1
F(1) = 1;     % corresponding to Neumann condition at x = 0
F(N) = 1;     % corresponding to Neumann condition at x = π/2

% Solve the system
U = K \ F;

% Plot the solution
figure;
plot(x, U);
title('Solution to the elliptic equation');
xlabel('x');
ylabel('u(x)');