function visualize(Y, label)

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
set(fig, 'Position', [0,0,800,800]);
hold on;
%gscatter(x, y, label, cl, sbl, sz, 'filled');
for i=1:10
	scatter(x(i*100-99:i*100), y(i*100-99:i*100), sz(i), cl(i,:), sbl(i), 'filled');
end
%legend('blues', 'classical', 'country', 'disco', 'hiphop', 'jazz', 'metal', 'pop', 'reggae', 'rock');
%for i=1:10
	%scatter(x(i*100-99), y(i*100-99), sz(i)*4, cl(i,:), 'o');
	%scatter(x(i*100-99), y(i*100-99), sz(i), cl(i,:), 'o');
%end

end
