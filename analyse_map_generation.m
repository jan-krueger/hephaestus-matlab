% Ground Truth

ground_truth = [
    [9 , 0   , 0    , 0];
    [8 , 0   , -0.5 , 0];
    [6 , 0   , -1.0 , 0];
    [5 , 0   , -1.5 , 0];
    [4 , 0   , -2.0 , 0];
    [3 , 0   , -2.5 , 0];
    
    [1 , 0.6 ,  0   , 0];
    [0 , 0.6 , -0.5 , 0]; 
    [27, 0.6 , -1.0 , 0];
    [26, 0.6 , -1.5 , 0];
    [25, 0.6 , -2.0 , 0];
    [24, 0.6 , -2.5 , 0];
    
    [23 , 1.2,  0  , 0];
    [22,  1.2, -0.5, 0];
    [21,  1.2, -1.0,  0];
    [20,  1.2, -1.5, 0];
    [19,  1.2, -2.0, 0];
    [18,  1.2, -2.5, 0];
    
    [17, 1.8 ,  0  , 0];
    [16, 1.8 , -0.5, 0];
    [15, 1.8 , -1.0, 0];
    [14, 1.8 , -1.5, 0];
    [13, 1.8 , -2.0, 0];
    [12, 1.8 , -2.5, 0];
];

%% REALSENSE %%
%% REALSENSE %%
%% REALSENSE %%

realsense_path = '/media/jan/T7/bsc/2022-04-12/map_generation/realsense/map_csvs/';

data_path = realsense_path;

%% 1. Calculate Error Map vs. Ground Truth

data_slack = [
    [5, 0.8333, maps_calculate_error(readmatrix(strcat(data_path, 'grid_slack_5.csv')), ground_truth)];
    [4, 3/4, maps_calculate_error(readmatrix(strcat(data_path, 'grid_slack_4.csv')), ground_truth)];
    [3, 2/3, maps_calculate_error(readmatrix(strcat(data_path, 'grid_slack_3.csv')), ground_truth)];
    [2, 1/2, maps_calculate_error(readmatrix(strcat(data_path, 'grid_slack_2.csv')), ground_truth)];
    [0, 1, maps_calculate_error(readmatrix(strcat(data_path, 'grid_slack_0.csv')), ground_truth)];
];

data_noslack = [
    [5, 0.8333, maps_calculate_error(readmatrix(strcat(data_path, 'grid_noslack_5.csv')), ground_truth)];
    [4, 3/4, maps_calculate_error(readmatrix(strcat(data_path, 'grid_noslack_4.csv')), ground_truth)];
    [3, 2/3, maps_calculate_error(readmatrix(strcat(data_path, 'grid_noslack_3.csv')), ground_truth)];
    [2, 1/2, maps_calculate_error(readmatrix(strcat(data_path, 'grid_noslack_2.csv')), ground_truth)];
    [0, 1, maps_calculate_error(readmatrix(strcat(data_path, 'grid_noslack_0.csv')), ground_truth)];
];

figure;
bar(data_slack(:,1), [data_slack(:,3)'; data_noslack(:,3)']);
ylim([0 .07]);
xlabel("Every nth marker skipped [-]");
ylabel("Error [m]");
legend(["Slack Filter"; "No Slack Filter"]);
title("Map Generation - Slack vs. No Slack Filter (Realsense)");
export_fig('graphs/map_generation_realsense_map_generation_filter_vs_no_filter.png', '-nocrop', '-transparent', '-png', '-m5');

%% 2. Heatmap Error Distribution
m = readmatrix(strcat(data_path, 'grid_slack_0.csv'));
heatmap_data = zeros([length(m), 2]);
for i = 1:length(ground_truth)
    heatmap_data(i,1) = ground_truth(i,1);
    marker = get_marker_by_id(m, ground_truth(i,1));
    if ~isnan(marker)
        heatmap_data(i,2) = norm(ground_truth(i,2:4) - marker);
    else
        heatmap_data(i,2) = NaN;
    end
        
end

figure;
heatmap_data = reshape(heatmap_data, [6,4,2]);

heatmap(rot90(heatmap_data(:,:,2)), 'YData',["1.8", "1.2", "0.6", "0"],...
    'XData',["0", "0.5", "1.0", "1.5", "2.0", "2.5"]);
title("Errors (Realsense)")
ylabel("x [m]")
xlabel("y [m]")
annotation('textarrow',[1,1],[0.5,0.4],'string','Error [m]', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90);
export_fig('graphs/map_generation_realsense_error_heatmap.png', '-nocrop', '-transparent', '-png', '-m5');

%% 3. Ground Truth vs. Generated Map (xy)

m = readmatrix(strcat(data_path, 'grid_slack_0.csv'));
grid;
plot(m(:,2), m(:,3), 'r.');
hold on;
scatter(ground_truth(:,2), ground_truth(:,3), 'b.');
grid on;
text(m(:,2), m(:,3), string(m(:,1)),'VerticalAlignment','bottom','HorizontalAlignment','right');
xlabel('x [m]');
ylabel('y [m]');
title("Ground Truth vs. Generated Map XY-Plane (Realsense)");
set(gcf,'position',[0,0, 1024, 1024]);
xlim([-0.1, 3]);
ylim([-3, 0.1]);
l = legend(["Generated Map"; "Ground Truth"]);
set(l, 'Position', [0.75, 0.85, .1, .05])
export_fig('graphs/map_generation_realsense_error_scatter_xy.png', '-nocrop', '-transparent', '-png', '-m5');


%% 3. Ground Truth vs. Generated Map (xz)
m = readmatrix(strcat(data_path, 'grid_slack_0.csv'));

plot(m(:,2), m(:,4), 'r.');
hold on;
scatter(ground_truth(:,2), ground_truth(:,4), 'b.');
grid on;
text(m(:,2), m(:,4), string(ground_truth(:,1)),'VerticalAlignment','bottom','HorizontalAlignment','right');
h=legend('Nmax=8','Nmax=10','Nmax=12','Nmax=14');
xlabel('x [m]');
ylabel('z [m]');
title("Ground Truth vs. Generated Map XZ-Plane (Realsense)");
set(gcf,'position',[0,0, 1024, 1024]);
xlim([-0.1, 3]);
ylim([-0.15, 0.15]);
l = legend(["Generated Map"; "Ground Truth"]);
set(l, 'Position', [0.75, 0.85, .1, .05])
export_fig('graphs/map_generation_realsense_error_scatter_xz.png', '-nocrop', '-transparent', '-png', '-m5');

%% TELLO %%
%% TELLO %%
%% TELLO %%

realsense_path = '/media/jan/T7/bsc/2022-04-12/map_generation/tello/map_csvs/';

%% 1. Calculate Error Map vs. Ground Truth


data_noslack = [
    [5, 0.8333, maps_calculate_error(readmatrix(strcat(data_path, 'grid_noslack_5.csv')), ground_truth)];
    [4, 3/4, maps_calculate_error(readmatrix(strcat(data_path, 'grid_noslack_4.csv')), ground_truth)];
    [3, 2/3, maps_calculate_error(readmatrix(strcat(data_path, 'grid_noslack_3.csv')), ground_truth)];
    [2, 1/2, maps_calculate_error(readmatrix(strcat(data_path, 'grid_noslack_2.csv')), ground_truth)];
    [0, 1, maps_calculate_error(readmatrix(strcat(realsense_path, 'grid_noslack_0.csv')), ground_truth)];
];

figure;
bar(data_noslack(:,1), data_noslack(:,3)');
ylim([0 .07]);
xlabel("Every nth marker skipped [-]");
ylabel("Error [m]");
legend(["Slack Filter"; "No Slack Filter"]);
title("Map Generation - Slack vs. No Slack Filter (Tello)");
export_fig('graphs/map_generation_realsense_map_generation_filter_vs_no_filter.png', '-nocrop', '-transparent', '-png', '-m5');

%% 2. Heatmap Error Distribution
m = readmatrix(strcat(data_path, 'grid_noslack_0.csv'));
heatmap_data = zeros([length(m), 2]);
for i = 1:length(ground_truth)
    heatmap_data(i,1) = ground_truth(i,1);
    marker = get_marker_by_id(m, ground_truth(i,1));
    
    if ~isnan(marker)
        heatmap_data(i,2) = norm(ground_truth(i,2:4) - marker);
    else
        heatmap_data(i,2) = NaN;
    end
        
end

figure;
heatmap_data = reshape(heatmap_data, [6,4,2]);

heatmap(rot90(heatmap_data(:,:,2)), 'YData',["1.8", "1.2", "0.6", "0"],...
    'XData',["0", "0.5", "1.0", "1.5", "2.0", "2.5"]);
title("Errors (Tello)")
ylabel("x [m]")
xlabel("y [m]")
annotation('textarrow',[1,1],[0.5,0.4],'string','Error [m]', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90);
export_fig('graphs/map_generation_tello_error_heatmap.png', '-nocrop', '-transparent', '-png', '-m5');

%% 3. Ground Truth vs. Generated Map (xy)

m = readmatrix(strcat(data_path, 'grid_noslack_0.csv'));
grid;
plot(m(:,2), m(:,3), 'r.');
hold on;
scatter(ground_truth(:,2), ground_truth(:,3), 'b.');
grid on;
text(m(:,2), m(:,3), string(m(:,1)),'VerticalAlignment','bottom','HorizontalAlignment','right');
xlabel('x [m]');
ylabel('y [m]');
title("Ground Truth vs. Generated Map XY-Plane (Tello)");
set(gcf,'position',[0,0, 1024, 1024]);
xlim([-0.1, 3]);
ylim([-3, 0.1]);
l = legend(["Generated Map"; "Ground Truth"]);
set(l, 'Position', [0.75, 0.85, .1, .05])
export_fig('graphs/map_generation_tello_error_scatter_xy.png', '-nocrop', '-transparent', '-png', '-m5');


%% 3. Ground Truth vs. Generated Map (xz)
m = readmatrix(strcat(data_path, 'grid_noslack_0.csv'));

plot(m(:,2), m(:,4), 'r.');
hold on;
scatter(ground_truth(:,2), ground_truth(:,4), 'b.');
grid on;
text(m(:,2), m(:,4), string(ground_truth(:,1)),'VerticalAlignment','bottom','HorizontalAlignment','right');
h=legend('Nmax=8','Nmax=10','Nmax=12','Nmax=14');
xlabel('x [m]');
ylabel('z [m]');
title("Ground Truth vs. Generated Map XZ-Plane (Tello)");
set(gcf,'position',[0,0, 1024, 1024]);
xlim([-0.1, 3]);
ylim([-0.15, 0.15]);
l = legend(["Generated Map"; "Ground Truth"]);
set(l, 'Position', [0.75, 0.85, .1, .05])
export_fig('graphs/map_generation_tello_error_scatter_xz.png', '-nocrop', '-transparent', '-png', '-m5');
