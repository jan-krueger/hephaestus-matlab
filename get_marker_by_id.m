function p = get_marker_by_id(data, id)
    p = nan;
    for i = 1:length(data(:,1))
        if data(i,1) == id
            p = data(i, 2:4);
            break;
        end
    end
end