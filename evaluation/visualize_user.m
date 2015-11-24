function visualize_user(Y, label)

x = Y(:,1);
y = Y(:,2);
cl = [
166,206,227;
31,120,180;
178,223,138;
51,160,44;
251,154,153;
227,26,28;
253,191,111;
255,127,0;
202,178,214;
106,61,154];
cl = cl / 256;
sbl = 'oooooooooo';
sz = [25,25,25,25,25,25,25,25,25,25];

fig = figure(1);
%fig = figure;
set(fig, 'Position', [0,0,800,800]);
hold on;
%gscatter(x, y, label, cl, sbl, sz, 'filled');
scatter(x(find(label == 0)), y(find(label == 0)), sz(3), cl(3,:), sbl(3), 'filled');
scatter(x(find(label == 1)), y(find(label == 1)), sz(2), cl(2,:), sbl(2), 'filled');
scatter(x(find(label == 2)), y(find(label == 2)), sz(6), cl(6,:), sbl(6), 'filled');
%legend('others', 'user-defined');


end
