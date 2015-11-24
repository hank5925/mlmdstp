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
%tsne
perplexities = [5, 10, 20, 30, 50];
epsilons = [100, 250, 500, 1000];
%perplexities = [30];
%epsilons = [500];

%lmnn
mus = [0.1, 0.2, 0.5, 0.8, 0.9];
no_targets = [2, 3, 5, 8, 10, 15];
%etas = [0.01, 0.05, 0.1, 0.2, 0.5];
%mus = [0.5];
%no_targets = [3];

%scgl
no_basis = [50, 100, 200, 400, 800];
beta = [1e-3, 1e-4, 1e-5, 1e-6];

%sclo
%no_basis = [400];
%beta = [1e-5];
kpca_dims = [10, 20, 40, 80];

%oasi
do_sym = [0, 1];
do_psd = [0, 1];

%gblm
no_neighbors = no_targets;
no_trees = [100, 200, 400];
tree_depth = [3, 4, 5];
learning_rate = [1e-2, 1e-3, 1e-4];
no_potential_impo = [20, 30, 50, 75];
%no_trees = [200];
%tree_depth = [4];
%learning_rate = [1e-3];
%no_potential_impo = [50];

%% OUTPUT

output = {};
output_tsne = {};
output_lmnn = {};
output_scgl = {};
output_sclo = {};
output_oasi = {};
output_gblm = {};


%---------------------------------------------------------------%

%tsne
fprintf('t-SNE\n');
cnt_p = 1;
for p = perplexities
    cnt_eps = 1;
    for eps = epsilons
        fprintf('perplexity: %d, epsilon: %d\n', p, eps);
        tic;
        %output_tsne{cnt_p, cnt_eps} = tsne_ys(X, labels, no_dims, initial_dims, p, eps);
        output_tsne{cnt_p, cnt_eps} = 0;
        time.tsne(cnt_p, cnt_eps) = toc;
        cnt_eps = cnt_eps + 1;
    end
    cnt_p = cnt_p + 1;
end

%lmnn
fprintf('LMNN\n');
cnt_mu = 1;
for mu = mus
    cnt_ntg = 1;
    for ntg = no_targets
        fprintf('mu: %f, no_targets: %d\n', mu, ntg);
        tic;
        %[L_lmnn, ~] = lmnn2(X', user_labels', ntg, pca(X')', 'mu', mu);
        %time.lmnn(cnt_mu, cnt_ntg) = toc;
        %output_lmnn{cnt_mu, cnt_ntg} = X * L_lmnn;
        output_lmnn{cnt_mu, cnt_ntg} = 0;
        %TODO: Maybe without ' ?
        cnt_ntg = cnt_ntg + 1;
    end
    cnt_mu = cnt_mu + 1;
end

%scgl and sclo
fprintf('SCML-global / SCML-local\n');
cnt_bs = 1;
for bs = no_basis
    cnt_bt = 1;
    for bt = beta
        cnt_kp = 1;
        %scgl
        fprintf('number of basis: %d, beta: %f\n', bs, bt);
        tic;
        %[L_scgl, b_init] = SCML_global(X, user_labels, bs, bt);
        time.scgl(cnt_bs, cnt_bt) = toc;
        %output_scgl{cnt_bs, cnt_bt} = X * L_scgl';
        output_scgl{cnt_bs, cnt_bt} = 0;
        for kp = kpca_dims
            %sclo
            fprintf('KPCA dimension: %d\n', kp);
            % X on the 3rd and 4th variable are fillers, no meanings.
            tic;
            %[Xk_sclo, ~, ~] = get_kpca_embedding(X, user_labels, X, X, kp);
            %[A_sclo, b_sclo, Ls_sclo] = SCML_local(X, user_labels, Xk_sclo, bs, bt, b_init);
            time.sclo(cnt_bs, cnt_bt, cnt_kp) = toc;
            %W_sclo = Xk_sclo * A_sclo + repmat(b_sclo', [no_data, 1]);
            %Y_sclo = zeros(no_data, initial_dims);
            %for i = 1:bs
                %Y_sclo = Y_sclo + X * reshape(Ls_sclo(i,:), [initial_dims, initial_dims]) .* repmat(W_sclo(:,i), [1, initial_dims]);
            %end
            %output_sclo{cnt_bs, cnt_bt, cnt_kp} = Y_sclo;
            output_sclo{cnt_bs, cnt_bt, cnt_kp} = 0;
            cnt_kp = cnt_kp + 1;
        end
        cnt_bt = cnt_bt + 1;
    end
    cnt_bs = cnt_bs + 1;
end

%oasi
fprintf('OASIS\n');
cnt_sym = 1;
for sym = do_sym
    cnt_psd = 1;
    for psd = do_psd
        fprintf('do symmetrize: %d, do PSD: %d\n', sym, psd);
        parms_oasi.do_sym = sym;
        parms_oasi.do_psd = psd;
        tic;
        %model_oasi = oasis(X, user_labels, parms_oasi);
        output_oasi{cnt_sym, cnt_psd} = 0;
        time.oasi(cnt_sym, cnt_psd) = toc;
        %TODO: Maybe model_oasi.W? without ' ?
        %output_oasi{cnt_sym, cnt_psd} = X * model_oasi.W';
        cnt_psd = cnt_psd + 1;
    end
    cnt_sym = cnt_sym + 1;
end

%gblm
%lmnn (default: mu = 0.5)
fprintf('GB-LMNN\n');
cnt_nei = 1;
for nei = no_neighbors
    cnt_tre = 1;
    tic;
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
                    time.gblm(cnt_nei, cnt_tre, cnt_dep, cnt_lnr, cnt_pot) = toc + tmp;
                    output_gblm{cnt_nei, cnt_tre, cnt_dep, cnt_lnr, cnt_pot} = embed_gblm(X')';
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
time.gblmlmnn = toc;



%output = {output_tsne, output_lmnn, output_lmnn_tsne};
output = {output_tsne, output_lmnn, output_scgl, output_sclo, output_oasi, output_gblm};

