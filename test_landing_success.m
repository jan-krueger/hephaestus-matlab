% Experiment: Fly a path from a starting point to the landing pad without
% a block attached, and try to land in various orientation.
% Data: [full success, success but wrong orientation, failure, lost track of platform]
% 1. 0 [deg] offset, 45 [deg] offset, 22.5 [deg] offset
x = [0, 22.5, 45];
data = [ 14, 0, 3, 3; 11, 4, 3, 2; 5, 5, 9, 1];

bar(x, data);
legend('Full Success', 'Partial Success', 'Missed', 'Lost Track');
xticks([0, 22.5, 45]);
xlabel("Platform Rotation (Z-Axis) [deg]");
ylabel("n [count]");
title("Landing Experiment With Varying Platform Orientation");
export_fig('graphs/landing_without_block_success.png',...
    '-nocrop', '-transparent', '-png', '-m5');

