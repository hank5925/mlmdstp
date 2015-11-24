function [output, time] = grid_search(X, labels, user_labels)

%X: #n by #f
%labels: #n by 1
%user_labels: #n by 1


%% PARAMETER

%General
no_dims = 2;
initial_dims = size(X, 2);
no_data = size(X, 1);

%Algorithm-based
%lmnn
mus = [0.1, 0.2, 0.5, 0.8, 0.9];
%mus = [0.5];
%no_targets = [2, 3, 5, 8, 10, 15];
no_targets = [3];

%gblm
%no_neighbors = no_targets;
%no_trees = [100, 200, 400];
%tree_depth = [3, 4, 5];
%learning_rate = [1e-2, 1e-3, 1e-4];
%no_potential_impo = [20, 30, 50, 75];

no_neighbors = [ceil(min(length(find(user_labels == 1)), length(find(user_labels == 2)))/2)];
%no_neighbors = [min(length(find(user_labels == 1)), length(find(user_labels == 2))) - 1];
no_trees = [400];
tree_depth = [3];
learning_rate = [1e-3];
no_potential_impo = [50];

%no_neighbors = [5, 8, 10, 15];
%no_trees = [200, 400];
%tree_depth = [3, 4];
%learning_rate = [1e-3, 1e-4];
%no_potential_impo = [50];

%% OUTPUT
output = {};
time = {};


%---------------------------------------------------------------%

fprintf('GB-LMNN\n');
cnt_nei = 1;
for nei = no_neighbors
    cnt_tre = 1;
    tic;
    % mu = 0.5
    [L_gblm, ~] = lmnn2(X', user_labels', nei, pca(X')', 'mu', 0.5);
    tmp = toc;
    for tre = no_trees 
        cnt_dep = 1;
        for dep = tree_depth
            cnt_lnr = 1;
            for lnr = learning_rate
                cnt_pot = 1;
                for pot = no_potential_impo
                    fprintf(['number of neighbors: %d, number of trees: %d, depth of trees: %d,\n' ...
                    'learning rate: %f, number of potential impo: %d\n'], nei, tre, dep, lnr, pot);
                    %TODO: Maybe L_gblm without ' ?
                    tic;
                    embed_gblm = gb_lmnn(X', user_labels', nei, L_gblm', 'ntrees', tre, 'depth', dep, 'lr', lnr, 'no_potential_impo', pot);
                    time{cnt_nei, cnt_tre, cnt_dep, cnt_lnr, cnt_pot} = toc + tmp;
                    output{cnt_nei, cnt_tre, cnt_dep, cnt_lnr, cnt_pot} = embed_gblm(X')';
                    %output_gblm{cnt_nei, cnt_tre, cnt_dep, cnt_lnr, cnt_pot} = 0;
                    cnt_pot = cnt_pot + 1;
                end
                cnt_lnr = cnt_lnr + 1;
            end
            cnt_dep = cnt_dep + 1;
        end
        cnt_tre = cnt_tre + 1;
    end
    cnt_nei = cnt_nei + 1;
end




