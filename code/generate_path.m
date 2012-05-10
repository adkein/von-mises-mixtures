n_walkers = 1; % Number of walkers to track
kappa = 1;

% Define base distribution by its modes' mean vectors.
n_modes = 6;
h = zeros(3,n_modes);
h(:,1) = [1 0 0]';
h(:,2) = [-1 0 0]';
h(:,3) = [0 1 0]';
h(:,4) = [0 -1 0]';
h(:,5) = [0 0 1]';
h(:,6) = [0 0 -1]';

% Sample initial positions from base distribution
positions = zeros(3,n_walkers);
mode_cdf = cumsum(ones(n_modes,1) / n_modes);
r = rand(n_walkers,1);
for i = 1:n_walkers
    j = 1+sum(r(i)>mode_cdf);
    positions(:,i) = randvonMisesFisherm(3,1,kappa,h(:,j));
end

% Watch them walk
n_steps = 10;
histories = cell(n_walkers,1);
for i = 1:n_walkers
    histories{i} = zeros(3,n_steps);
    histories{i}(:,1) = positions(:,i);
    for t = 1:n_steps
        mode_pdf = zeros(n_modes,1);
        for j = 1:n_modes
            mode_pdf(j) = exp(logVmfPdf(positions(:,i),h(:,j),kappa));
        end
        mode_cdf = cumsum(mode_pdf/sqrt(mode_pdf'*mode_pdf));
        j = 1+sum(rand>mode_cdf);
        positions(:,i) = randvonMisesFisherm(3,1,kappa,h(:,j));
        histories{i}(:,t) = positions(:,i);
    end
end

% Plot the samples
h1 = figure(1);
plot3(positions(1,:),positions(2,:),positions(3,:),'linestyle','none',...
    'marker','.')
view(pi/2,10)
set(gcf, 'Units', 'inches');
set(gcf, 'outerposition', [0 0 6 5]);
set(gcf, 'paperpositionmode', 'auto');
x = get(gcf, 'position');
set(gca, 'fontsize', 20);
set(gcf, 'PaperSize', [x(3) x(4)]);
print -dpdf temp1.pdf

% Plot the paths
h2 = figure(2);
[X,Y,Z]=sphere(12);
mesh(X,Y,Z)
colormap([0 0 0])
alpha(0)
hold on
for i = 1:n_walkers
    plot3(histories{i}(1,:),histories{i}(2,:),histories{i}(3,:),...
        'marker','.','linewidth',1.5)
end
view(pi/2,10)
set(gcf, 'Units', 'inches');
set(gcf, 'outerposition', [0 0 6 5]);
set(gcf, 'paperpositionmode', 'auto');
x = get(gcf, 'position');
set(gca, 'fontsize', 20);
set(gcf, 'PaperSize', [x(3) x(4)]);
print -dpdf temp2.pdf