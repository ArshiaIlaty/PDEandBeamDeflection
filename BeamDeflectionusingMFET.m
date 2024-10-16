% Create a PDE model for solving M'' = 1
model = createpde(1);  % '1' indicates a scalar PDE problem

% Define a 1D geometry: A line from 0 to 1
geometryFromEdges(model,@circleg);  % Using a built-in simple geometry

% Apply boundary conditions for M: M(0) = 0, M(1) = 0
applyBoundaryCondition(model, 'dirichlet', 'Edge', 1, 'u', 0);
applyBoundaryCondition(model, 'dirichlet', 'Edge', 2, 'u', 0);

% Specify the PDE coefficients for M'' = 1
specifyCoefficients(model, 'm', 0, 'd', 0, 'c', 1, 'a', 0, 'f', 1);

% Generate a mesh for the model
generateMesh(model, 'Hmax', 0.05);

% Solve the PDE for M
result_M = solvepde(model);

% Extract the solution for M and the mesh nodes
M = result_M.NodalSolution;
meshNodes = result_M.Mesh.Nodes(1,:);  % Extract the 1D mesh nodes

% Now, create another PDE model to solve u'' = M
model_u = createpde(1);  % Again, '1' indicates a scalar PDE

% Define the same 1D geometry for u
geometryFromEdges(model_u,@circleg);

% Apply boundary conditions for u: u(0) = 0, u(1) = 0
applyBoundaryCondition(model_u, 'dirichlet', 'Edge', 1, 'u', 0);
applyBoundaryCondition(model_u, 'dirichlet', 'Edge', 2, 'u', 0);

% Sort the nodes and ensure they are unique
[sortedMeshNodes, uniqueIdx] = unique(meshNodes);  
sortedM = M(uniqueIdx);  % Sort M to match the sorted nodes

% Specify the PDE coefficients for u'' = M using the interpolated values of M
specifyCoefficients(model_u, 'm', 0, 'd', 0, 'c', 1, 'a', 0, ...
    'f', @(location,state) interp1(sortedMeshNodes, sortedM, location.x, 'linear', 'extrap'));

% Generate the mesh for the new PDE model
generateMesh(model_u, 'Hmax', 0.05);

% Solve the PDE for u
result_u = solvepde(model_u);

% Plot the solution for the deflection u
figure;
plot(result_u.Mesh.Nodes(1,:), result_u.NodalSolution);
title('Beam Deflection (u)');
xlabel('x');
ylabel('u(x)');