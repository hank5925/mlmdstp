function output = main(X, labels, user_labels)

%X: #n by #f
%labels: #n by 1
%user_labels: #n by 1

if size(labels, 1) == 1
    labels = labels';
end
if size(user_labels, 1) == 1
    user_labels = user_labels';
end


%% PARAMETER

%General
no_dims = 2;
initial_dims = size(X, 2);
no_data = size(X, 1);

%Algorithm-based
nn1 = length(find(user_labels == 1));
nn2 = length(find(user_labels == 2));
%no_neighbors = max(floor(log10(min(nn1, nn2)) * 5), 2);
no_neighbors = 8;
no_trees = 400;
tree_depth = 3;
learning_rate = 1e-3;
no_potential_impo = 50;

%---------------------------------------------------------------%

% mu = 0.5
[L_gblm, ~] = lmnn2(X', user_labels', no_neighbors, 'mu', 0.5);
embed_gblm = gb_lmnn(X', user_labels', no_neighbors, L_gblm',...
                    'ntrees', no_trees, 'depth', tree_depth,...
                    'lr', learning_rate, 'no_potential_impo', no_potential_impo);
X_gblm = embed_gblm(X')';
X_dim = tsne_ys(X_gblm, labels, no_dims, initial_dims, 30, 500);

output = X_dim;

