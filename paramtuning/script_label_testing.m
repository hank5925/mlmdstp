% parameter setting:
%%LMNN
%mus = [0.5];
%%GB-LMNN
%no_neighbors = [1/2 min(label sets)];
%no_trees = [400];
%tree_depth = [3];
%learning_rate = [1e-3];
%no_potential_impo = [50];
%%t-SNE
%perplexities = [20, 30, 50];
%epsilons = [250, 500, 1000];

%disp('2 vs 2');
%[output_2, time_2] = grid_search(msd_data, label, user_label_2_2);
%score_2 = cluster_analysis_gblmnn(output_2, user_label_2_2);
%output_2_dim = dimension_reduction(output_2, user_label_2_2);
%score_2_dim = cluster_analysis_gblmnn(output_2_dim{1}, user_label_2_2);
%disp('5 vs 5');
%[output_5, time_5] = grid_search(msd_data, label, user_label_5_5);
%score_5 = cluster_analysis_gblmnn(output_5, user_label_5_5);
%output_5_dim = dimension_reduction(output_5, user_label_5_5);
%score_5_dim = cluster_analysis_gblmnn(output_5_dim{1}, user_label_5_5);
%disp('10 vs 10');
%[output_10, time_10] = grid_search(msd_data, label, user_label_10_10_1);
%score_10 = cluster_analysis_gblmnn(output_10, user_label_10_10_1);
%output_10_dim = dimension_reduction(output_10, user_label_10_10_1);
%score_10_dim = cluster_analysis_gblmnn(output_10_dim{1}, user_label_10_10_1);
%disp('25 vs 25');
%[output_25, time_25] = grid_search(msd_data, label, user_label_25_25_1);
%score_25 = cluster_analysis_gblmnn(output_25, user_label_25_25_1);
%output_25_dim = dimension_reduction(output_25, user_label_25_25_1);
%score_25_dim = cluster_analysis_gblmnn(output_25_dim{1}, user_label_25_25_1);
%disp('50 vs 50');
%[output_50, time_50] = grid_search(msd_data, label, user_label_50_50_1);
%score_50 = cluster_analysis_gblmnn(output_50, user_label_50_50_1);
%output_50_dim = dimension_reduction(output_50, user_label_50_50_1);
%score_50_dim = cluster_analysis_gblmnn(output_50_dim{1}, user_label_50_50_1);
%disp('250 vs 250');
%[output_250, time_250] = grid_search(msd_data, label, user_label_250_250);
%score_250 = cluster_analysis_gblmnn(output_250, user_label_250_250);
%output_250_dim = dimension_reduction(output_250, user_label_250_250);
%score_250_dim = cluster_analysis_gblmnn(output_250_dim{1}, user_label_250_250);
%disp('500 vs 500');
%[output_500, time_500] = grid_search(msd_data, label, user_label_500_500);
%score_500 = cluster_analysis_gblmnn(output_500, user_label_500_500);
%output_500_dim = dimension_reduction(output_500, user_label_500_500);
%score_500_dim = cluster_analysis_gblmnn(output_500_dim{1}, user_label_500_500);
disp('10 vs 25');
[output_10_25, time_10_25] = grid_search(msd_data, label, user_label_10_25);
score_10_25 = cluster_analysis_gblmnn(output_10_25, user_label_10_25);
output_10_25_dim = dimension_reduction(output_10_25, user_label_10_25);
score_10_25_dim = cluster_analysis_gblmnn(output_10_25_dim{1}, user_label_10_25);
disp('10 vs 50');
[output_10_50, time_10_50] = grid_search(msd_data, label, user_label_10_50);
score_10_50 = cluster_analysis_gblmnn(output_10_50, user_label_10_50);
output_10_50_dim = dimension_reduction(output_10_50, user_label_10_50);
score_10_50_dim = cluster_analysis_gblmnn(output_10_50_dim{1}, user_label_10_50);
disp('jazz vs metal');
[output_jm, time_jm] = grid_search(msd_data, label, user_label_jazz_metal);
score_jm = cluster_analysis_gblmnn(output_jm, user_label_jazz_metal);
output_jm_dim = dimension_reduction(output_jm, user_label_jazz_metal);
score_jm_dim = cluster_analysis_gblmnn(output_jm_dim{1}, user_label_jazz_metal);
disp('classical vs metal');
[output_cm, time_cm] = grid_search(msd_data, label, user_label_classical_metal);
score_cm = cluster_analysis_gblmnn(output_cm, user_label_classical_metal);
output_cm_dim = dimension_reduction(output_cm, user_label_classical_metal);
score_cm_dim = cluster_analysis_gblmnn(output_cm_dim{1}, user_label_classical_metal);

disp('DONE!!!');
