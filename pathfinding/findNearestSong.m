function nearest_song = findNearestSong(song_set, centroid)

N = size(song_set, 1);
song_distance = song_set - repmat(centroid, [N, 1]);
song_distance = sum(song_distance .^ 2, 2);

[~, idx] = min(song_distance);
nearest_song = song_set(idx, :);

