%% Ground Truth (z=0)

image_suffix = '_z0';
rosbag_path = '/media/jan/T7/bsc/2022-04-13/map_localisation/realsense_localisation_2022-04-13-12-07-13.bag';
bag = rosbag(rosbag_path);

odom_z0 = timeseries(select(bag,'Topic','/tello/odometry'), ...
    'Pose.Pose.Position.X', 'Pose.Pose.Position.Y', 'Pose.Pose.Position.Z');
odom_z0.Time = odom_z0.Time - odom_z0.Time(1);

%% 1. Realsense
% id, start_time, end_time, gt_x, gt_y, gt_z
time_table = [
    1 , 0,     5, 0.126, -0.5, 1.864;
    2 , 41,   46, 0.476, -0.5, 1.864;
    3 , 108, 113, 0.826, -0.5, 1.864;
    4 , 152, 157, 1.176, -0.5, 1.864;
    5 , 172, 177, 1.526, -0.5, 1.864;
    
    10, 312, 317, 0.126, -1.0, 1.864;
    9 , 292, 297, 0.476, -1.0, 1.864;
    8 , 267, 272, 0.826, -1.0, 1.864;
    7 , 242, 247, 1.176, -1.0, 1.864;
    6 , 211, 216, 1.526, -1.0, 1.864;
    
    11, 408, 413, 0.126, -2.0, 1.864;
    12, 438, 443, 0.476, -2.0, 1.864;
    13, 461, 466, 0.826, -2.0, 1.864;
    14, 480, 485, 1.176, -2.0, 1.864;
    15, 500, 505, 1.526, -2.0, 1.864;

    20, 635, 640, 0.126, -2.5, 1.864;
    19, 611, 616, 0.476, -2.5, 1.864;
    18, 594, 599, 0.826, -2.5, 1.864;
    17, 570, 575, 1.176, -2.5, 1.864;
    16, 533, 538, 1.526, -2.5, 1.864;
    
];

errors = zeros([20, 1]);

for i = 1:length(time_table)
    measurement = mean(getsampleusingtime(odom_z0, time_table(i,2), time_table(i,3))) + [0.031,-0.14, -0.01];
    errors(i,:) = norm(measurement-time_table(i,4:6));  
end

mean_error = mean(errors);

%% Plot 1.0
figure;
plot(odom_z0);
hold on;

ha_x = zeros([4, length(time_table)]);
ha_y = zeros([4, length(time_table)]);

for i = 1:length(time_table)
    ha_x(:,i) = [time_table(i,2), time_table(i,2), time_table(i,3), time_table(i,3)];
    ha_y(:,i) = [-3, 3, 3, -3];
end
patch(ha_x, ha_y,'y','FaceAlpha',.3);
xlabel("Time [s]");
ylabel("Measurement [m]");
legend(["x", "y", "z", "Sample"]);
xlim([0, 650]);
title("Localisation Experiment Sampled Data (Realsense)");
export_fig(sprintf('graphs/localisation_realsense_localisation_raw%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');

%% Plot 1.1
figure;
scatter(1:length(errors), errors, 'b');
hold on;
line([0,20], [mean_error,mean_error], 'Color', 'g');

title("Localisation Sample Errors (Realsense)");
legend(["Sample"; "Mean Error"]);
xlabel("Sample");
ylabel("Error [m]");
export_fig(sprintf('graphs/localisation_realsense_error%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');

%% Plot 1.2
figure;
heatmap(flip(reshape(errors, [5,4])), 'YData', ["1.526", "1.176", "0.826","0.476","0.126"],...
    'XData', ["-0.5", "-1.0", "-1.5", "-2.0"]);
xlabel("y [m]");
ylabel("x [m]");
title("Localisation Sample Errors (Realsense)");
annotation('textarrow',[1,1],[0.5,0.2],'string','Error [m]', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90);
export_fig(sprintf('graphs/localisation_realsense_error_heatmap%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');

%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

%% Ground Truth (z=+0.8)

image_suffix = '_z80';
rosbag_path = '/media/jan/T7/bsc/2022-04-13/map_localisation/realsense_localisation_z_plus_80_2022-04-13-18-08-53.bag';
bag = rosbag(rosbag_path);

odom_z1 = timeseries(select(bag,'Topic','/tello/odometry'), ...
    'Pose.Pose.Position.X', 'Pose.Pose.Position.Y', 'Pose.Pose.Position.Z');
odom_z1.Time = odom_z1.Time - odom_z1.Time(1);

%% 2. Realsense
% id, start_time, end_time, gt_x, gt_y, gt_z
time_table_z1 = [
    1 , 0,     5, 0.126, -0.5, 1.064;
    2 , 27,   32, 0.476, -0.5, 1.064;
    3 , 46,   51, 0.826, -0.5, 1.064;
    4 , 65,   70, 1.176, -0.5, 1.064;
    5 , 89,   94, 1.526, -0.5, 1.064;
    
    10, 256, 261, 0.126, -1.0, 1.064;
    9 , 206, 211, 0.476, -1.0, 1.064;
    8 , 182, 187, 0.826, -1.0, 1.064;
    7 , 156, 161, 1.176, -1.0, 1.064;
    6 , 136, 141, 1.526, -1.0, 1.064;
    
    11, 333, 338, 0.126, -2.0, 1.064;
    12, 360, 365, 0.476, -2.0, 1.064;
    13, 393, 398, 0.826, -2.0, 1.064;
    14, 413, 418, 1.176, -2.0, 1.064;
    15, 445, 450, 1.526, -2.0, 1.064;

    20, 613, 618, 0.126, -2.5, 1.064;
    19, 583, 588, 0.476, -2.5, 1.064;
    18, 557, 562, 0.826, -2.5, 1.064;
    17, 529, 534, 1.176, -2.5, 1.064;
    16, 494, 499, 1.526, -2.5, 1.064;
    
];

errors = zeros([20, 1]);

for i = 1:length(time_table_z1)
    measurement = mean(getsampleusingtime(odom_z1, time_table_z1(i,2), time_table_z1(i,3))) + [0.031,-0.14, -0.01];
    errors(i,:) = norm(measurement-time_table_z1(i,4:6));  
end

mean_error = mean(errors);

%% Plot 2.0
figure;
plot(odom_z1);
hold on;

ha_x = zeros([4, length(time_table_z1)]);
ha_y = zeros([4, length(time_table_z1)]);

for i = 1:length(time_table_z1)
    ha_x(:,i) = [time_table_z1(i,2), time_table_z1(i,2), time_table_z1(i,3), time_table_z1(i,3)];
    ha_y(:,i) = [-3, 3, 3, -3];
end
patch(ha_x, ha_y,'y','FaceAlpha',.3);
xlabel("Time [s]");
ylabel("Measurement [m]");
legend(["x", "y", "z", "Sample"]);
xlim([0, 650]);
title("Localisation Experiment Sampled Data (Realsense)");
export_fig(sprintf('graphs/localisation_realsense_localisation_raw%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');

%% Plot 2.1
figure;
scatter(1:length(errors), errors, 'b');
hold on;
line([0,20], [mean_error,mean_error], 'Color', 'g');

title("Localisation Sample Errors (Realsense)");
legend(["Sample"; "Mean Error"]);
xlabel("Sample");
ylabel("Error [m]");
export_fig(sprintf('graphs/localisation_realsense_error%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');

%% Plot 2.2
figure;
heatmap(flip(reshape(errors, [5,4])), 'YData', ["1.526", "1.176", "0.826","0.476","0.126"],...
    'XData', ["-0.5", "-1.0", "-1.5", "-2.0"]);
xlabel("y [m]");
ylabel("x [m]");
title("Localisation Sample Errors (Realsense)");
annotation('textarrow',[1,1],[0.5,0.2],'string','Error [m]', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90);
export_fig(sprintf('graphs/localisation_realsense_error_heatmap%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');