% Parameters
L = 1;    % spatial domain length
T = 1;    % time duration
Nx = 50;  % number of spatial points
Nt = 100; % number of time steps
dx = L / (Nx - 1);
dt = T / (Nt - 1);

x = linspace(0, L, Nx);
t = linspace(0, T, Nt);

% Initialize solution matrix
U = zeros(Nx, Nt); % U(x, t), initial condition already 0

% Finite difference matrix for space
alpha = dt / dx^2;
A = diag(ones(Nx-1,1), -1) - 2 * eye(Nx) + diag(ones(Nx-1,1), 1);
A = alpha * A; % time-stepping matrix for diffusion term

% Time-stepping loop (backward Euler)
for n = 1:Nt-1
    % Right-hand side is 1 (due to the non-homogeneous term)
    F = ones(Nx, 1);
    % Apply boundary conditions: u(0, t) = u(1, t) = 0
    F(1) = 0; F(end) = 0;
    % Solve the system at time step n+1
    U(:,n+1) = (eye(Nx) - A) \ (U(:,n) + F*dt);
end

% Plot the solution
figure;
surf(x, t, U');
title('Solution to the diffusion equation');
xlabel('x'); ylabel('t'); zlabel('u(x,t)');