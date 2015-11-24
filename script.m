
load input.mat;

X = msd_data;
%user_label = user_label_10_10_1;
%user_label = user_label_25_25_1;
%user_label = user_label_25_25_2;
user_label = user_label_jazz_metal;
%user_label = user_label_classical_metal;

disp('Metric Learning + Dimension Reduction');
X_dim = main(X, label, user_label);
disp('Path Finding');
path_idx = buildPath(X_dim, user_label);
%disp('Preview Music');
%generateMusic(path_idx);

