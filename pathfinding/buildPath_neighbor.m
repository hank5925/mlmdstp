function output = buildPath_neighbor(X, label)


%%%%%%%%%%%%%%%%%%%%%%%%
%%     INITIALIZE     %%
%%%%%%%%%%%%%%%%%%%%%%%%

output = 0;
N = size(X, 1);
% 2 labels only, unlabeled
unlabel_set = X(find(label == 0), :);
start_set = X(find(label == 1), :);
end_set = X(find(label == 2), :);




%%%%%%%%%%%%%%%%%%%%%%%%
%% STARTING & ENDING  %%
%%%%%%%%%%%%%%%%%%%%%%%%

centroid_start = mean(start_set);
centroid_end = mean(end_set);

start_song = findNearestSong(start_set, centroid_start);
end_song = findNearestSong(end_set, centroid_end);





%%%%%%%%%%%%%%%%%%%%%%%%
%%    SEARCH RANGE    %%
%%%%%%%%%%%%%%%%%%%%%%%%

mid_point = (start_song + end_song) / 2;
path_length = dist(start_song, end_song);
% perpendicular, normalize, left 90 degree
unit_norm = end_song - start_song;
tmp = unit_norm(1);
unit_norm(1) = -unit_norm(2);
unit_norm(2) = tmp;
unit_norm = unit_norm ./ sqrt(sum(unit_norm .^ 2));

% left always circle1, right always circle2
% i.e. arc1 > arc2 at all time

% arc  2   1  .5   0 -.5  -1  -2
% dist 1   0  -1-inf   1   0  -1
% pow2 2^1 2^0 ...     (no use here)
% -pow-2             -2^- -2^0 -2^1

% if arc == 0 => straight line TODO
% if arc  > 0 => dist = log2(arc)
% if arc  < 0 => dist = -log2(-arc)
arc1 = exp(-10);
arc2 = -exp(-10);
opposite1 = 0;
opposite2 = 0;

if (arc1 == 0)
    error('can not be zero for now');
elseif (arc1 > 0)
    mid_circle_dist1 = log2(arc1);
else
    mid_circle_dist1 = -log2(-arc1);
    opposite1 = 1;
end

if (arc2 == 0)
    error('can not be zero for now');
elseif (arc2 > 0)
    mid_circle_dist2 = log2(arc2);
else
    mid_circle_dist2 = -log2(-arc2);
    opposite2 = 1;
end


circle1 = mid_point + unit_norm * mid_circle_dist1;
circle2 = mid_point + unit_norm * mid_circle_dist2;

radius1 = sqrt(mid_circle_dist1.^2 + (path_length/2).^2);
radius2 = sqrt(mid_circle_dist2.^2 + (path_length/2).^2);

isSearchSet = zeros(N,1);
for idx = 1:N
    if (opposite1 == 0 & opposite2 == 0)
        % 1e-5 is for quick fix on "start_song not appearing in search_set" issue.
        isSearchSet(idx) = dist(X(idx,:), circle1) <= radius1 + 1e-5 & ...
                           dist(X(idx,:), circle2) >= radius2 - 1e-5;
    elseif (opposite1 == 0 & opposite2 == 1)
        if (mid_circle_dist1 > mid_circle_dist2)
            isSearchSet(idx) = dist(X(idx,:), circle1) <= radius1 + 1e-5 | ...
                               dist(X(idx,:), circle2) <= radius2 + 1e-5;
        else
            isSearchSet(idx) = dist(X(idx,:), circle1) <= radius1 + 1e-5 & ...
                               dist(X(idx,:), circle2) <= radius2 + 1e-5;
        end
    elseif (opposite1 == 1 & opposite2 == 1)
        isSearchSet(idx) = dist(X(idx,:), circle1) >= radius1 - 1e-5 & ...
                           dist(X(idx,:), circle2) <= radius2 + 1e-5;
    else
        error('arc1 < arc2 is WRONG');
    end
end
search_set = X(find(isSearchSet == 1),:);

tmp = 1:N;
idx_search_set = tmp(find(isSearchSet == 1));





%%%%%%%%%%%%%%%%%%%%%%%%
%%   GRAPH  GROWING   %%
%%%%%%%%%%%%%%%%%%%%%%%%
threshold = 5;
[edges, isAdjacent] = growGraph(search_set, threshold);




%%%%%%%%%%%%%%%%%%%%%%%%
%%    PATH FINDING    %%
%%%%%%%%%%%%%%%%%%%%%%%%
shortest_path = dijkstra(search_set, isAdjacent, start_song, end_song);




%%%%%%%%%%%%%%%%%%%%%%%%
%%      Plotting      %%
%%%%%%%%%%%%%%%%%%%%%%%%

figure; hold on; axis equal;

%dots
scatter(start_set(:,1), start_set(:,2), 100, 'r', 'x');
scatter(start_song(1), start_song(2), 100, 'r', 'o');
scatter(end_set(:,1), end_set(:,2), 100, 'b', 'o');
scatter(end_song(1), end_song(2), 100, 'b', 'x');
scatter(unlabel_set(:, 1), unlabel_set(:, 2), 10, 'k', 's');
scatter(search_set(:, 1), search_set(:, 2), 10, 'g', 's');
%scatter(circle1(1), circle1(2), 50, 'g', 's');
%scatter(circle2(1), circle2(2), 50, 'g', 's');

%lines
plot([start_song(1), end_song(1)], [start_song(2), end_song(2)], 'k');
%plot([mid_point(1) + 10 * unit_norm(1), mid_point(1) - 10 * unit_norm(1)], ...
     %[mid_point(2) + 10 * unit_norm(2), mid_point(2) - 10 * unit_norm(2)]);
for i=1:length(shortest_path)-1
    plot([search_set(shortest_path(i),1), search_set(shortest_path(i+1),1)], ...
         [search_set(shortest_path(i),2), search_set(shortest_path(i+1),2)], 'm', 'LineWidth', 2);
end
%for i=1:size(edges,1)
    %plot([search_set(edges(i,1),1), search_set(edges(i,2),1)], ...
         %[search_set(edges(i,1),2), search_set(edges(i,2),2)]);
%end

%circles
theta11 = atan((start_song(2) - circle1(2)) / (start_song(1) - circle1(1)));
theta12 = atan((end_song(2) - circle1(2)) / (end_song(1) - circle1(1)));
% tan ranges from -pi/2 to pi/2, which is -90 degree to 90 degree
if start_song(1) - circle1(1) < 0
    if start_song(2) - circle1(2) > 0
        theta11 = theta11 + pi;
    else
        theta11 = theta11 - pi;
    end
end
if end_song(1) - circle1(1) < 0
    if end_song(2) - circle1(2) > 0
        theta12 = theta12 + pi;
    else
        theta12 = theta12 - pi;
    end
end
% clockwise or counterclockwise arc
if (opposite1 == 0)
    tmp = theta12;
    theta12 = theta11;
    theta11 = tmp;
end
% modify the range of theta, so that theta11 increases to theta12 normally
if (theta12 < theta11)
    theta12 = theta12 + 2 * pi;
end
ang1 = theta11:0.01:theta12; 
xp = radius1 * cos(ang1);
yp = radius1 * sin(ang1);
plot(circle1(1) + xp, circle1(2) + yp, 'c');

theta21 = atan((start_song(2) - circle2(2)) / (start_song(1) - circle2(1)));
theta22 = atan((end_song(2) - circle2(2)) / (end_song(1) - circle2(1)));
if start_song(1) - circle2(1) < 0
    if start_song(2) - circle2(2) > 0
        theta21 = theta21 + pi;
    else
        theta21 = theta21 - pi;
    end
end
if end_song(1) - circle2(1) < 0
    if end_song(2) - circle2(2) > 0
        theta22 = theta22 + pi;
    else
        theta22 = theta22 - pi;
    end
end
if (opposite2 == 0)
    tmp = theta22;
    theta22 = theta21;
    theta21 = tmp;
end
if (theta22 < theta21)
    theta22 = theta22 + 2 * pi;
end

ang2 = theta21:0.01:theta22; 
xp = radius2 * cos(ang2);
yp = radius2 * sin(ang2);
plot(circle2(1) + xp, circle2(2) + yp, 'c');


output = idx_search_set(shortest_path);

