% GENERATE_PATH
%
% A script to plot random walks around the spherical mixture-of-von-Mises
% distributions. The transition kernel is p(x_t|x_{t-1}) = sum_k
% p(x_t|k) p(k|x_{t-1}), where k is the latent variable corresponding to
% the mixture modes.

n_walkers = 3; % Number of walkers to track
kappa = 10; % von Mises concentration parameter (like the precision)

% Define base distribution by its modes' mean vectors.
n_modes = 6;
h = zeros(3, n_modes);
h(:, 1) = [1 0 0]';
h(:, 2) = [-1 0 0]';
h(:, 3) = [0 1 0]';
h(:, 4) = [0 -1 0]';
h(:, 5) = [0 0 1]';
h(:, 6) = [0 0 -1]';

% Sample initial positions from base distribution
positions = zeros(3, n_walkers);
mode_cdf = (1:n_modes)' / n_modes;
r = rand(n_walkers, 1);
for i = 1:n_walkers
    j = 1 + sum(r(i) > mode_cdf);
    positions(:, i) = randvonMisesFisherm(3, 1, kappa,h(:, j));
end

% Watch the walkers walk
n_steps = 20;
histories = cell(n_walkers, 1); % A cell array of trajectories
for i = 1:n_walkers
    histories{i} = zeros(3, n_steps);
    histories{i}(:, 1) = positions(:, i);
    for t = 1:n_steps
        % Compute the pdf of each vM mixture mode, evaluated at the current
        % position of the walker. This becomes a new discrete distribution
        % over the modes: mode_pdf(n) = p(walker belongs to mode n).
        mode_pdf = zeros(n_modes, 1);
        for j = 1:n_modes
            mode_pdf(j) = exp(logVmfPdf(positions(:, i), h(:, j), kappa));
        end
        % Compute cdf of this discrete distribution over modes. The
        % ordering of the modes is arbitrary.
        mode_cdf = cumsum(mode_pdf / sum(mode_pdf));
        % Randomly assign the walker to a mode by inversion of the cdf.
        j = 1 + sum(rand > mode_cdf);
        % Draw the walkers exact next position from the corresponding vM
        % mode distribution.
        positions(:, i) = randvonMisesFisherm(3, 1, kappa, h(:, j));
        % Record this position in the cell array of trajectories.
        histories{i}(:, t) = positions(:, i);
    end
end

[X, Y, Z] = sphere(12);
colors = {'b', 'r', 'g'};

% Plot the samples
h1 = figure(1);
hold on
mesh(X, Y, Z)
colormap([0 0 0])
alpha(0)
for i = 1:n_walkers
    plot3(histories{i}(1, :), histories{i}(2, :), histories{i}(3, :), ...
        'linestyle', 'none', 'marker', '.')
end
view(pi/2, 10)
set(gcf, 'Units', 'inches');
set(gcf, 'outerposition', [0 0 6 5]);
set(gcf, 'paperpositionmode', 'auto');
x = get(gcf, 'position');
set(gca, 'fontsize', 20);
set(gcf, 'PaperSize', [x(3) x(4)]);
print -dpdf temp1.pdf

% Plot the paths of the walkers
h2 = figure(2);
hold on
mesh(X,Y,Z)
colormap([0 0 0])
alpha(0)
for i = 1:n_walkers
    plot3(histories{i}(1, :),histories{i}(2, :),histories{i}(3, :),...
        'marker', '.', 'linewidth', 1.5, 'color', colors{i*(i<4)+(i>3)})
end
view(pi/2,10)
set(gcf, 'Units', 'inches');
set(gcf, 'outerposition', [0 0 6 5]);
set(gcf, 'paperpositionmode', 'auto');
x = get(gcf, 'position');
set(gca, 'fontsize', 20);
set(gcf, 'PaperSize', [x(3) x(4)]);
print -dpdf temp2.pdf
