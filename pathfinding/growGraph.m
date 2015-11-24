function [edges, A] = growGraph(song_set, threshold)

N = size(song_set, 1);
A = zeros(N,N);
edges = [];

for i=1:N
    for j=i+1:N
        d = song_set(i,:) - song_set(j,:);
        if (sqrt(d * d') < threshold)
            edges = [edges; [i,j]];
            A(i,j) = 1;
            A(j,i) = 1;
        end
    end
end


