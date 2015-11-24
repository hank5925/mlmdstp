function path = dijkstra(song_set, A, start, ends)

idx_start = find(song_set(:,1) - start(1) == 0);
idx_end = find(song_set(:,1) - ends(1) == 0);

N = size(song_set, 1);
distance_from_start = ones(N, 1) * inf;
previous_node = zeros(N, 1); % 0 as undefined
unvisited_set = [1:1:N]; % every node are unvisited

% d(start, start) = 0
distance_from_start(idx_start) = 0;


while length(unvisited_set) > 0
    dist_unvisit = distance_from_start(unvisited_set);
    [val, idx] = min(dist_unvisit);
    idx_u = unvisited_set(idx);
    unvisited_set = unvisited_set(find(unvisited_set ~= idx_u));

    neighbor_u = find(A(idx_u,:) == 1);
    neighbor_u = intersect(neighbor_u, unvisited_set);
    for i = 1:length(neighbor_u)
        alt = val + 1;
        if (alt < distance_from_start(neighbor_u(i)))
            distance_from_start(neighbor_u(i)) = alt;
            previous_node(neighbor_u(i)) = idx_u;
        end
    end

    if (idx_u == idx_end)
        break;
    end
end

path = [idx_end];
idx = idx_end;
while previous_node(idx) ~= 0
    path = [previous_node(idx) path];
    idx = previous_node(idx);
end

