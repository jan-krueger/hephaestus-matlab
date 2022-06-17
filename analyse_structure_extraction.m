data_first = [
    [ 25 0 0 ]
    [ 24 0 1 ]
    [ 15 0 10]
    [ 25 0 0 ]
    [ 25 0 0 ]
    [ 23 2 0 ]
    [ 25 0 0 ]
    [ 24 0 1 ]
    [ 25 0 0 ]
    [ 25 0 0 ]
];

data_second = [
    [ [22,0,3]  [4,0,0] ]
    [ [23,0,2]  [4,0,0] ]
    [ [18,0,7]  [3,0,1] ]
    [ [14,0,11] [4,0,0] ]
    [ [23,1,1]  [4,0,0] ]
    [ [23,0,2]  [4,0,0] ]
    [ [22,1,2]  [4,0,0] ]
    [ [21,1,3]  [4,0,0] ]
    [ [23,0,2]  [4,0,0] ]
    [ [21,0,4]  [4,0,0] ]
];

data_third = [ 
    [ [23,0,2] [4,0,0] [1,0,0] ]
    [ [21,0,4] [2,0,2] [1,0,0] ]
    [ [21,0,4] [4,0,0] [1,0,0] ]
    [ [22,0,3] [2,0,2] [1,0,0] ]
    [ [22,0,3] [3,0,1] [1,0,0]]
    [ [21,0,4] [3,0,1] [0,1,0] ]
    [ [20,0,5] [2,2,0] [1,0,0] ]
    [ [22,0,3] [4,0,0] [1,0,0] ]
    [ [22,0,3] [3,0,1] [1,0,0] ]
    [ [20,0,5] [2,0,2] [1,0,0] ]
];

% TP / (TP+FN)
recall_first = mean(data_first(:y,1) ./ (data_first(:,1) + data_first(:,3)) );
recall_second = mean((data_second(:,1) + data_second(:,4)) ./ ...
    (data_second(:,1) + data_second(:,4) + data_second(:,3) + data_second(:,6)));
recall_third = mean((data_third(:,1) + data_third(:,4) + data_third(:,7)) ./ ...
    (data_third(:,1) + data_third(:,4) + data_third(:,7) + ...
    data_third(:,3) + data_third(:,6) + data_third(:,9)));

% TP / (TP+FP)
prec_first = mean(data_first(:,1) ./  (data_first(:,1) + data_first(:,2)));
prec_second = mean((data_second(:,1) + data_second(:,4)) ./  ...
    (data_second(:,1) + data_second(:,2) + data_second(:,4) + data_second(:,5)));
prec_third = mean((data_third(:,1) + data_third(:,4) + data_third(:,7)) ./  ...
    (data_third(:,1) + data_third(:,2) + data_third(:,4) + data_third(:,5) + ...
    data_third(:,7) + data_third(:,8)));