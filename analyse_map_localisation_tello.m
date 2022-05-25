%% Ground Truth (z=0)

image_suffix = '_z0';
rosbag_path = '/media/jan/T7/bsc/2022-04-13/map_localisation/tello_localisation_2022-05-25-11-25-40.bag';
bag = rosbag(rosbag_path);

odom_z0 = timeseries(select(bag,'Topic','/tellos/alpha/odometry'), ...
    'Pose.Pose.Position.X', 'Pose.Pose.Position.Y', 'Pose.Pose.Position.Z');
odom_z0.Time = odom_z0.Time - odom_z0.Time(1);

%% 1. Tello
% id, start_time, end_time, gt_x, gt_y, gt_z
time_table = [
    1 , 0,     5, 0.126, -0.5, 1.864;
    2 , 12,   17, 0.476, -0.5, 1.864;
    3 , 27,   32, 0.826, -0.5, 1.864;
    4 , 43,   48, 1.176, -0.5, 1.864;
    5 , 60,   65, 1.526, -0.5, 1.864;
    
    10, 150, 155, 0.126, -1.0, 1.864;
    9 , 135, 140, 0.476, -1.0, 1.864;
    8 , 120, 125, 0.826, -1.0, 1.864;
    7 , 108, 113, 1.176, -1.0, 1.864;
    6 , 90,  95, 1.526, -1.0, 1.864;
    
    11, 194, 199, 0.126, -2.0, 1.864;
    12, 212, 217, 0.476, -2.0, 1.864;
    13, 227, 232, 0.826, -2.0, 1.864;
    14, 246, 251, 1.176, -2.0, 1.864;
    15, 266, 271, 1.526, -2.0, 1.864;

    20, 366, 371, 0.126, -2.5, 1.864;
    19, 344, 349, 0.476, -2.5, 1.864;
    18, 330, 335, 0.826, -2.5, 1.864;
    17, 313, 318, 1.176, -2.5, 1.864;
    16, 291, 296, 1.526, -2.5, 1.864;
    
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
xlim([0, 390]);
title("Localisation Experiment Sampled Data (Tello)");
export_fig(sprintf('graphs/localisation_tello_localisation_raw%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');

%% Plot 1.1
figure;
scatter(1:length(errors), errors, 'b');
hold on;
line([0,20], [mean_error,mean_error], 'Color', 'g');

title("Localisation Sample Errors (Tello)");
legend(["Sample"; "Mean Error"]);
xlabel("Sample");
ylabel("Error [m]");
export_fig(sprintf('graphs/localisation_tello_error%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');

%% Plot 1.2
figure;
heatmap(flip(reshape(errors, [5,4])), 'YData', ["1.526", "1.176", "0.826","0.476","0.126"],...
    'XData', ["-0.5", "-1.0", "-1.5", "-2.0"]);
xlabel("y [m]");
ylabel("x [m]");
title("Localisation Sample Errors (Tello)");
annotation('textarrow',[1,1],[0.5,0.2],'string','Error [m]', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90);
export_fig(sprintf('graphs/localisation_tello_error_heatmap%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');

%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

%% Ground Truth (z=+0.8)

image_suffix = '_z80';
rosbag_path = '/media/jan/T7/bsc/2022-04-13/map_localisation/tello_localisation_z_plus_80_2022-05-25-12-25-17.bag';
bag = rosbag(rosbag_path);

odom_z1 = timeseries(select(bag,'Topic','/tellos/alpha/odometry'), ...
    'Pose.Pose.Position.X', 'Pose.Pose.Position.Y', 'Pose.Pose.Position.Z');
odom_z1.Time = odom_z1.Time - odom_z1.Time(1);

%% 2. Realsense
% id, start_time, end_time, gt_x, gt_y, gt_z
time_table_z1 = [
    1 , 0,     5, 0.126, -0.5, 1.064;
    2 , 12,   17, 0.476, -0.5, 1.064;
    3 , 34,   39, 0.826, -0.5, 1.064;
    4 , 51,   56, 1.176, -0.5, 1.064;
    5 , 70,   75, 1.526, -0.5, 1.064;
    
    10, 182, 187, 0.126, -1.0, 1.064;
    9 , 163, 168, 0.476, -1.0, 1.064;
    8 , 144, 149, 0.826, -1.0, 1.064;
    7 , 121, 126, 1.176, -1.0, 1.064;
    6 ,  94,  99, 1.526, -1.0, 1.064;
    
    11, 229, 234, 0.126, -2.0, 1.064;
    12, 246, 251, 0.476, -2.0, 1.064;
    13, 269, 274, 0.826, -2.0, 1.064;
    14, 288, 293, 1.176, -2.0, 1.064;
    15, 305, 310, 1.526, -2.0, 1.064;

    20, 409, 414, 0.126, -2.5, 1.064;
    19, 390, 395, 0.476, -2.5, 1.064;
    18, 370, 375, 0.826, -2.5, 1.064;
    17, 352, 357, 1.176, -2.5, 1.064;
    16, 327, 332, 1.526, -2.5, 1.064;
    
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
xlim([0, 418]);
title("Localisation Experiment Sampled Data (Tello)");
export_fig(sprintf('graphs/localisation_tello_localisation_raw%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');

%% Plot 2.1
figure;
scatter(1:length(errors), errors, 'b');
hold on;
line([0,20], [mean_error,mean_error], 'Color', 'g');

title("Localisation Sample Errors (Tello)");
legend(["Sample"; "Mean Error"]);
xlabel("Sample");
ylabel("Error [m]");
export_fig(sprintf('graphs/localisation_tello_error%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');

%% Plot 2.2
figure;
heatmap(flip(reshape(errors, [5,4])), 'YData', ["1.526", "1.176", "0.826","0.476","0.126"],...
    'XData', ["-0.5", "-1.0", "-1.5", "-2.0"]);
xlabel("y [m]");
ylabel("x [m]");
title("Localisation Sample Errors (Tello)");
annotation('textarrow',[1,1],[0.5,0.2],'string','Error [m]', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90);
export_fig(sprintf('graphs/localisation_tello_error_heatmap%s.png', image_suffix),...
    '-nocrop', '-transparent', '-png', '-m5');