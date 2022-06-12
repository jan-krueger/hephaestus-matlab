full_success = 26;

first_station_lost_track = 2;
first_station_failed_landing_orientation = 6;
first_station_failed_landing_missed = 1;
first_station_failed_picking_block = 7;

second_station_lost_track = 2;
second_station_failed_landing = 0;
second_station_failed_block_delivery_not_detached = 6;

total = (full_success + first_station_lost_track + first_station_failed_landing_orientation ...
    + first_station_failed_picking_block + first_station_failed_landing_missed ...
    + second_station_lost_track + second_station_failed_block_delivery_not_detached ...
    + second_station_failed_landing);
    
success_rate = full_success / total;
partial_success_rate = (full_success + second_station_failed_block_delivery_not_detached) / total;

f = figure('Position',[0 0 1280 720]);
[patchhl, labelhl]=sunburstplot('misc/pickup_and_delivery_data.csv', {[1 0 0], [0 1 0]}, '', 3);
title('Block Pickup and Delivery (n=50)');
set(gcf, 'Color', 'none');

export_fig('graphs/pickup_and_delivery.png',...
    '-nocrop', '-transparent', '-png', '-m5');
