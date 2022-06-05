%% Load custom messages
pyenv('Version','/usr/bin/python3.9');
rosgenmsg('/home/jan/Workspaces/Maastricht/bsc_thesis/src');

addpath('/home/jan/Workspaces/Maastricht/bsc_thesis/src/matlab_msg_gen_ros1/glnxa64/install/m');
savepath;

clear classes;
rehash toolboxcache;
%% Load Bag

bag = rosbag('/media/jan/T7/bsc/2022-05-31/2_landing_pad_rotated_experiment_45/2022-05-31-08-57-56.bag');

t = bag.MessageList(bag.MessageList.Topic == '/tellos/alpha/feedback/landing_pad', :);

bag.MessageList(bag.MessageList.Topic == '/tellos/alpha/land', :).Time - t(1,:).Time


%% Extract data (Landing Data)
odom = timeseries(select(bag,'Topic','/tellos/alpha/odometry'), ...
    'Pose.Pose.Position.X', 'Pose.Pose.Position.Y', 'Pose.Pose.Position.Z');
landing_feedback = timeseries(select(bag,'Topic','/tellos/alpha/feedback/landing_pad'), ...
    'Pose.Position.X', 'Pose.Position.Y', 'Pose.Position.Z');
cmd_vel = timeseries(select(bag,'Topic','/tellos/alpha/cmd_vel', "Time", [landing_feedback.Time(1), landing_feedback.Time(end)]), ...
    'Twist.Linear.X', 'Twist.Linear.Y', 'Twist.Linear.Z');
landing_feedback.Time = landing_feedback.Time - landing_feedback.Time(1);
cmd_vel.Time = cmd_vel.Time - cmd_vel.Time(1);

t = tiledlayout(2,1);

nexttile;
stairs(landing_feedback.Time, landing_feedback.Data);
legend(["x", "y", "z"])
nexttile;
stairs(cmd_vel.Time, cmd_vel.Data);

%% Extract data (Full Approach + Landing)
landing_feedback = timeseries(select(bag,'Topic','/tellos/alpha/feedback/landing_pad'), ...
    'Pose.Position.X', 'Pose.Position.Y', 'Pose.Position.Z');
landing_cmd = timeseries(select(bag,'Topic','/tellos/alpha/land'));
cmd_vel = timeseries(select(bag,'Topic','/tellos/alpha/cmd_vel'), ...
    'Twist.Linear.X', 'Twist.Linear.Y', 'Twist.Linear.Z');
odom = timeseries(select(bag,'Topic','/tellos/alpha/odometry', ... 
    "Time", [cmd_vel.Time(1), landing_feedback.Time(1)]), ...
    'Pose.Pose.Position.X', 'Pose.Pose.Position.Y', 'Pose.Pose.Position.Z');

lf_time = bag.MessageList(bag.MessageList.Topic == '/tellos/alpha/feedback/landing_pad', :);

landing_cmd_issued = landing_cmd.TimeInfo.Start - cmd_vel.Time(1);
odom.Time = odom.Time - cmd_vel.Time(1);
lf_time.Time = lf_time.Time - cmd_vel.Time(1);
landing_feedback.Time = landing_feedback.Time - cmd_vel.Time(1);
cmd_vel.Time = cmd_vel.Time - cmd_vel.Time(1);

f = figure('Position',[0 0 1280 720]);
t = tiledlayout(f,2,1);

nexttile;
stairs([odom.Time; landing_feedback.Time], [odom.Data; landing_feedback.Data]);
hold on;

patch([cmd_vel.Time(1) cmd_vel.Time(1) lf_time.Time(1) lf_time.Time(1)],...
    [-2 2 2 -2], 'r', 'FaceAlpha',0.3, 'EdgeColor','none');
patch([lf_time.Time(1) lf_time.Time(1) lf_time.Time(end) lf_time.Time(end)],...
    [-2 2 2 -2], [0.6 0.4 0.9], 'FaceAlpha',0.3, 'EdgeColor','none');
xlim([0 lf_time.Time(end)]);
xline(landing_cmd_issued, '-', 'Landing Cmd Issued');
ylabel("Position [m]");
xlabel("Time [s]");

title("Landing Pad - Approach and Landing");
legend(["x", "y", "z", "Approach", 'Landing Pad Alignment'], 'Location','southwest');

nexttile;
stairs(cmd_vel.Time, cmd_vel.Data);
patch([cmd_vel.Time(1) cmd_vel.Time(1) lf_time.Time(1) lf_time.Time(1)],...
    [-2 2 2 -2], 'r', 'FaceAlpha',0.3, 'EdgeColor','none');
patch([lf_time.Time(1) lf_time.Time(1) lf_time.Time(end) lf_time.Time(end)],...
    [-2 2 2 -2], [0.6 0.4 0.9], 'FaceAlpha',0.3, 'EdgeColor','none');
xlim([0 lf_time.Time(end)]);
ylim([-0.5 0.5]);
xline(landing_cmd_issued, '-', 'Landing Cmd Issued');
ylabel("Commanded Velocity [m/s]");
xlabel("Time [s]");

export_fig('graphs/landing_pad_example_trajectory.png',...
    '-nocrop', '-transparent', '-png', '-m5');

% TODO:
% - Generate sample trajectory
% - Calculate time to landing

%% Calculate time to landing (0deg)

exp_0 = {
    '2022-05-31-08-34-49.bag'; '2022-05-31-08-40-54.bag'; '2022-05-31-08-29-32.bag';
    '2022-05-31-08-37-57.bag'; '2022-05-31-08-42-19.bag'; '2022-05-31-08-33-31.bag';
    '2022-05-31-08-39-02.bag'; '2022-05-31-08-43-32.bag'};

times_0 = zeros(length(exp_0), 1);
for f = 1:length(exp_0)
    bag = rosbag(sprintf('/media/jan/T7/bsc/2022-05-31/1_landing_pad_experiment/%s', string(exp_0(f))));
    t = bag.MessageList(bag.MessageList.Topic == '/tellos/alpha/feedback/landing_pad', :);

    times_0(f) = t(end,:).Time - t(1,:).Time;
end

%% Calculate time to landing (22.5deg)

exp_225 = {
    '2022-05-31-09-48-43.bag'; '2022-05-31-10-05-09.bag'; '2022-05-31-09-32-32.bag'; 
    '2022-05-31-09-50-17.bag'; '2022-05-31-10-06-44.bag'; '2022-05-31-09-36-42.bag'; 
    '2022-05-31-09-56-15.bag'; '2022-05-31-10-08-48.bag'; '2022-05-31-09-40-04.bag'; 
    '2022-05-31-09-57-59.bag'; '2022-05-31-10-10-41.bag'; '2022-05-31-09-42-44.bag'; 
    '2022-05-31-09-59-50.bag'; '2022-05-31-10-12-21.bag'; '2022-05-31-09-44-36.bag'; 
    '2022-05-31-10-01-34.bag'; '2022-05-31-10-13-57.bag'; '2022-05-31-09-46-30.bag'; 
    '2022-05-31-10-03-01.bag'; '2022-05-31-10-15-45.bag'};

times_225 = zeros(length(exp_225), 1);
for f = 1:length(exp_225)
    bag = rosbag(sprintf('/media/jan/T7/bsc/2022-05-31/3_landing_pad_rotated_experiment_225/%s', string(exp_225(f))));
    t = bag.MessageList(bag.MessageList.Topic == '/tellos/alpha/feedback/landing_pad', :);

    times_225(f) = t(end,:).Time - t(1,:).Time;
end

%% Calculate time to landing (45deg)

exp_45 = {
    '2022-05-31-09-04-50.bag'; '2022-05-31-09-18-51.bag'; '2022-05-31-08-52-00.bag';
    '2022-05-31-09-07-17.bag'; '2022-05-31-09-20-53.bag'; '2022-05-31-08-54-06.bag';
    '2022-05-31-09-08-46.bag'; '2022-05-31-09-23-11.bag'; '2022-05-31-08-56-43.bag';
    '2022-05-31-09-09-58.bag'; '2022-05-31-09-24-45.bag'; '2022-05-31-08-57-56.bag';
    '2022-05-31-09-12-04.bag'; '2022-05-31-09-26-26.bag'; '2022-05-31-09-00-28.bag';
    '2022-05-31-09-14-21.bag'; '2022-05-31-09-28-55.bag'; '2022-05-31-09-03-06.bag';
    '2022-05-31-09-16-41.bag'};

times_45 = zeros(length(exp_45), 1);
for f = 1:length(exp_45)
    bag = rosbag(sprintf('/media/jan/T7/bsc/2022-05-31/2_landing_pad_rotated_experiment_45/%s', string(exp_45(f))));
    t = bag.MessageList(bag.MessageList.Topic == '/tellos/alpha/feedback/landing_pad', :);

    times_45(f) = t(end,:).Time - t(1,:).Time;
end

%%

boxplot([times_0; times_225; times_45; times_0; times_225; times_45],...
    [zeros(1, length(times_0) + length(times_225) + length(times_45)), ones(1,length(times_0)), ...
    ones(1,length(times_225))*2, ones(1,length(times_45))*3],...
    'Labels', {'Combined', '0 [deg]', '22.5 [deg]', '45 [deg]'});
hold on;
%plot([ mean([times_0; times_225; times_45]), mean(times_0), mean(times_225), mean(times_45) ], 'dg')
ylabel("Time [s]")
title("Time to Land with Rotated Landing Platform");

export_fig('graphs/landing_pad_time_to_land_boxplot.png',...
    '-nocrop', '-transparent', '-png', '-m5');