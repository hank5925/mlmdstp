function output_dim = dimension_reduction(output, labels)

%perplexities = [5, 10, 20, 30, 50];
%epsilons = [100, 250, 500, 1000];
%perplexities = [30];
%epsilons = [500];
perplexities = [20, 30, 50];
epsilons = [250, 500, 1000];

if iscell(output)
    % recursive
    output_dim = cell(size(output));
    for i = 1:numel(output)
        i
        output_dim{i} = dimension_reduction(output{i}, labels);
    end
else
    % leaf
    % MSD 12D
    output_dim = cell(length(perplexities), length(epsilons));
    for i = 1:length(perplexities)
        pplx = perplexities(i);
        for j = 1:length(epsilons)
            eps = epsilons(j);
            output_dim{i,j} = tsne_ys(output, labels, 2, 12, pplx, eps);
        end
    end
    % GTZAN 13D
    % output_dim = tsne_ys(output, labels, 2, 13, 30, 500);
end

