function score = cluster_eval(X, label)

% Using Davies-Bouldin Index
% score = 1/nc sum_i^nc max_j((sig_i + sig_j)/d(c_i, c_j))
%   where nc = nclusters
%         sig_i = average distance from element to centroid
%         c_i = centroid of cluster i

% init
[nx, nf] = size(X);
nc = length(unique(label));
c = zeros(nc, nf);
sig = zeros(nc, 1);

% find centroid for each clusters and sig_i
i = 1;
for l = unique(label)'
    idxs = (label - l == 0);
    X_sub = X(idxs, :);
    [nxsub, ~] = size(X_sub);
    c(i, :) = mean(X_sub);
    d = X_sub - repmat(c(i, :), [nxsub, 1]);
    sig(i) = mean(sqrt(sum(d.^2, 2)));

    i = i + 1;
end

% score
score = 0;
for i = [1:nc]
    mx = 0;
    for j = [1:nc]
        if j == i
            continue;
        end
        v = (sig(i) + sig(j)) / sqrt(sum((c(i,:) - c(j,:)).^2));
        if mx < v
            mx = v;
        end
    end
    score = score + mx;
end

score = score / nc;

