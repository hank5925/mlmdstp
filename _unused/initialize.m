function initialize(X, labels)

%X: #n by #f
%labels: #n by 1


%% PARAMETER

%General
no_dims = 2;
initial_dims = size(X, 2);
no_data = size(X, 1);

X_dim = tsne_ys(X, labels, no_dims, initial_dims, 30, 500);
X_idx_dim = [[1:no_data]', X_dim];

csvwrite('../../realdata/init.csv', X_idx_dim);

