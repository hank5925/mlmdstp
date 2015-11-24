function ocells = recursive_cell(cells, funchand)

ocells = cell(size(cells));
if iscell(cells)
    % recursive
    for i = 1:numel(cells)
        ocells{i} = recursive_cell(cells{i}, funchand);   
    end
else
    % apply function if reaches leaf
    ocells = funchand(cells);
end



