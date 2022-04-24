function [error, x_err, y_err, z_err] = maps_calculate_error(map_a, map_b)
    
    n = length(map_a);
    error = 0;
    x_err = 0;
    y_err = 0;
    z_err = 0;
        
    for i = 1:n
        id = map_a(i,1);
        a = map_a(i, 2:4);
        b = get_marker_by_id(map_b, id);
        
        error = error + norm(a-b);
        x_err = x_err + abs(a(1) - b(1));
        y_err = y_err + abs(a(2) - b(2));
        z_err = z_err + abs(a(3) - b(3));
        
    end
    
    error = error / n;
    x_err = x_err / n;
    y_err = y_err / n;
    z_err = z_err / n;
    
end

