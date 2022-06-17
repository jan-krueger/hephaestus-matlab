%% Tello on Realsense Map

rosbag_path = '/media/jan/T7/bsc/2022-04-13/map_localisation/tello_localisation_realsense_map_2022-05-25-13-42-01.bag';
bag = rosbag(rosbag_path);

odom_z0 = timeseries(select(bag,'Topic','/tello/odometry'), ...
    'Pose.Pose.Position.X', 'Pose.Pose.Position.Y', 'Pose.Pose.Position.Z');
odom_z0.Time = odom_z0.Time - odom_z0.Time(1);

%% 1. Tello
% id, start_time, end_time, gt_x, gt_y, gt_z
time_table = [
    1 ,   0,   5, 0.126, -0.5, 1.864;
    2 ,   9,  14, 0.476, -0.5, 1.864;
    3 ,  20,  25, 0.826, -0.5, 1.864;
    4 ,  30,  35, 1.176, -0.5, 1.864;
    5 ,  42,  47, 1.526, -0.5, 1.864;
    
    10, 119, 124, 0.126, -1.0, 1.864;
    9 , 104, 109, 0.476, -1.0, 1.864;
    8 ,  93,  98, 0.826, -1.0, 1.864;
    7 ,  79,  84, 1.176, -1.0, 1.864;
    6 ,  66,  71, 1.526, -1.0, 1.864;
    
    11, 155, 160, 0.126, -2.0, 1.864;
    12, 169, 174, 0.476, -2.0, 1.864;
    13, 182, 187, 0.826, -2.0, 1.864;
    14, 195, 200, 1.176, -2.0, 1.864;
    15, 209, 214, 1.526, -2.0, 1.864;

    20, 288, 293, 0.126, -2.5, 1.864;
    19, 273, 278, 0.476, -2.5, 1.864;
    18, 258, 263, 0.826, -2.5, 1.864;
    17, 245, 250, 1.176, -2.5, 1.864;
    16, 232, 237, 1.526, -2.5, 1.864;
    
];

errors = zeros([20, 1]);

for i = 1:length(time_table)
    measurement = mean(getsampleusingtime(odom_z0, time_table(i,2), time_table(i,3))) + [0.031,-0.14, -0.01];
    errors(i,:) = norm(measurement-time_table(i,4:6));  
end

mean_error_tello = mean(errors);
std_error_tello = std(errors);

%% Tello Plot 1.0
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
title("Localisation Experiment Sampled Data (Tello, Realsense Map)");
export_fig('graphs/localisation_tello_localisation_realsense_map_raw.png',...
    '-nocrop', '-transparent', '-png', '-m5');

%%
%%
%%
%% Realsense on Tello Map

realsense_rosbag_path = '/media/jan/T7/bsc/2022-04-13/map_localisation/realsense_localisation_tello_map_2022-05-25-13-31-08.bag';
realsense_bag = rosbag(realsense_rosbag_path);

odom_z0_realsense = timeseries(select(realsense_bag,'Topic','/tello/odometry'), ...
    'Pose.Pose.Position.X', 'Pose.Pose.Position.Y', 'Pose.Pose.Position.Z');
odom_z0_realsense.Time = odom_z0_realsense.Time - odom_z0_realsense.Time(1);

%% 1. Realsense
% id, start_time, end_time, gt_x, gt_y, gt_z
time_table_realsense = [
    1 ,   0,   5, 0.126, -0.5, 1.864;
    2 ,  13,  18, 0.476, -0.5, 1.864;
    3 ,  23,  28, 0.826, -0.5, 1.864;
    4 ,  37,  42, 1.176, -0.5, 1.864;
    5 ,  48,  53, 1.526, -0.5, 1.864;
    
    10, 150, 155, 0.126, -1.0, 1.864;
    9 , 131, 136, 0.476, -1.0, 1.864;
    8 , 115, 120, 0.826, -1.0, 1.864;
    7 ,  99, 104, 1.176, -1.0, 1.864;
    6 ,  83,  88, 1.526, -1.0, 1.864;
    
    11, 187, 192, 0.126, -2.0, 1.864;
    12, 203, 208, 0.476, -2.0, 1.864;
    13, 217, 222, 0.826, -2.0, 1.864;
    14, 231, 236, 1.176, -2.0, 1.864;
    15, 245, 250, 1.526, -2.0, 1.864;

    20, 330, 335, 0.126, -2.5, 1.864;
    19, 315, 320, 0.476, -2.5, 1.864;
    18, 301, 306, 0.826, -2.5, 1.864;
    17, 287, 292, 1.176, -2.5, 1.864;
    16, 275, 280, 1.526, -2.5, 1.864;
    
];

errors = zeros([20, 1]);

for i = 1:length(time_table_realsense)
    measurement = mean(getsampleusingtime(odom_z0_realsense, time_table_realsense(i,2), time_table_realsense(i,3))) + [0.031,-0.14, -0.01];
    errors(i,:) = norm(measurement-time_table_realsense(i,4:6));  
end

mean_error_realsense = mean(errors);
std_error_realsense = std(errors);

%% Realsense Plot 1.0
figure;
plot(odom_z0_realsense);
hold on;

ha_x = zeros([4, length(time_table_realsense)]);
ha_y = zeros([4, length(time_table_realsense)]);

for i = 1:length(time_table_realsense)
    ha_x(:,i) = [time_table_realsense(i,2), time_table_realsense(i,2), time_table_realsense(i,3), time_table_realsense(i,3)];
    ha_y(:,i) = [-3, 3, 3, -3];
end
patch(ha_x, ha_y,'y','FaceAlpha',.3);
xlabel("Time [s]");
ylabel("Measurement [m]");
legend(["x", "y", "z", "Sample"]);
xlim([0, 339]);
title("Localisation Experiment Sampled Data (Realsense, Tello Map)");
export_fig('graphs/localisation_realsense_localisation_tello_map_raw.png',...
    '-nocrop', '-transparent', '-png', '-m5');

%% Result
mean_error_tello - mean_error_realsense