C = regs.map.f

maxIndex = 110;
result = NaN(1, maxIndex);

% Loop through each cell and update the result array
for i = 1:numel(C)
    indices = C{i};
    result(indices) = i;
end