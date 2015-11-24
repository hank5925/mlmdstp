function generateMusic(list, folder)

folder = '/Users/yskuo/Desktop/temp/7100_visual/visualization/songs';
genres = {'blues', 'classical', 'country', 'disco', 'hip hop',...
          'jazz', 'metal', 'pop', 'reggae', 'rock'};
outpath= 'music.mp4';

fs = 44100; %%%%%%%% already know stereo!!! already know it, hard coded!! TODO FIXME

y = [];
for idx = 1:length(list)
    subfolder = genres{floor((list(idx)-1)/100)+1};
    name = [num2str(mod(list(idx)-1, 100)+1) '.mp3'];
    path = [folder '/' subfolder '/' name];
    if length(fileread(path)) > 0
        [x, fs_tmp] = audioread(path);
        if (fs_tmp == 22050)
            x = x(floor(length(x)/2)-fs_tmp*2:floor(length(x)/2)+fs_tmp*2,:);
            t = 1:fs_tmp*4+1;
            tq = 1:0.5:fs_tmp*4+1;
            x = interp1(t, x, tq, 'spline');
            x = x(1:end-1,:);
        else
            x = x(floor(length(x)/2)-fs_tmp*2:floor(length(x)/2)+fs_tmp*2-1,:);
        end
    else
        x = rand(fs*4, 2);
    end
    if idx == 1
        x_gain = x .* repmat([ones(1,fs*3) linspace(1,0,fs)]', [1,2]);
        y = x_gain;
    else
        x_gain = x .* repmat([linspace(0,1,fs) ones(1,fs*2) linspace(1,0,fs)]', [1,2]);
        y(end-fs+1:end,:) = y(end-fs+1:end,:) + x_gain(1:fs,:);
        y = [y;x_gain(fs+1:end,:)];
    end
end

audiowrite(outpath, y, fs);

