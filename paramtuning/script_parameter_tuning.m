% parameter setting:
%%LMNN
%mus = [0.5];
%%GB-LMNN
%no_neighbors = [5, 8, 10, 15];
%no_trees = [200, 400];
%tree_depth = [3, 4];
%learning_rate = [1e-3, 1e-4];
%no_potential_impo = [50];
%%t-SNE
%perplexities = [20, 30, 50];
%epsilons = [250, 500, 1000];


disp('25 vs 25');
[output_25, time_25] = grid_search(msd_data, label, user_label_25_25_1);
score_25 = cluster_analysis_gblmnn(output_25, user_label_25_25_1);
output_25_dim = dimension_reduction(output_25, user_label_25_25_1);
score_25_dim = cluster_analysis_gblmnn(output_25_dim, user_label_25_25_1);

disp('classical vs metal');
[output_cm, time_cm] = grid_search(msd_data, label, user_label_classical_metal);
score_cm = cluster_analysis_gblmnn(output_cm, user_label_classical_metal);
output_cm_dim = dimension_reduction(output_cm, user_label_classical_metal);
score_cm_dim = cluster_analysis_gblmnn(output_cm_dim, user_label_classical_metal);

disp('DONE!!!');
