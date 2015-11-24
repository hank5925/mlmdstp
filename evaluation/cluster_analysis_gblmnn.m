function score = cluster_analysis_gblmnn(output, label) 
%gblm
%for i=[1:4]
    %for j=[1:2]
        %for k=[1:2]
            %for l=[1:2]
                %for m=[1:1]
%for i=[1:1]
    %for j=[1:1]
        %for k=[1:1]
            %for l=[1:1]
                %for m=[1:1]
                    %score(i,j,k,l,m) = cluster_eval(output{i,j,k,l,m}, label);
                %end
            %end
        %end
    %end
%end

if iscell(output)
    % recursive
    score = cell(size(output));
    for i = 1:numel(output)
        i
        score{i} = cluster_analysis_gblmnn(output{i}, label);
    end
else
    % leaf
    score = cluster_eval(output, label);
end

%score = cluster_eval(output{1}, label);
