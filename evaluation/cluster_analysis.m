function score = cluster_analysis(output, label) 
%output = {output_tsne, output_lmnn, output_scgl, output_sclo, output_oasi, output_gblm};
%tsne
%for i=[1:5]
    %for j=[1:4]
        %score_tsne(i,j) = cluster_eval(output{1}{i,j}, label);
    %end
%end
score_tsne = cluster_eval(output{1}, label);
%lmnn
for i=[1:5]
    for j=[1:6]
        score_lmnn(i,j) = cluster_eval(output{2}{i,j}, label);
    end
end
%scgl
%for i=[1:5]
    %for j=[1:4]
        %score_scgl(i,j) = cluster_eval(output{3}{i,j}, label);
    %end
%end
score_scgl = cluster_eval(output{3}, label);
%sclo
%for i=[1:5]
    %for j=[1:4]
        %for k=[1:4]
            %score_sclo(i,j,k) = cluster_eval(output{4}{i,j,k}, label);
        %end
    %end
%end
score_sclo = cluster_eval(output{4}, label);
%oasi
for i=[1:2]
    for j=[1:2]
        score_oasi(i,j) = cluster_eval(output{5}{i,j}, label);
    end
end
%gblm
for i=[1:6]
    for j=[1:3]
        for k=[1:3]
            for l=[1:3]
                for m=[1:4]
                    score_gblm(i,j,k,l,m) = cluster_eval(output{6}{i,j,k,l,m}, label);
                end
            end
        end
    end
end

score = {score_tsne, score_lmnn, score_scgl, score_sclo, score_oasi, score_gblm};
