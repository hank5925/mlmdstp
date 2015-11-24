function [M, label_idx] = mfcc_extract(rootdir)
%% mfcc_extract
%  extract mfcc features from audio files given the root directory.
%  mfcc algorithm is implemented in mirtoolbox
%  
%  INPUT:
%    rootdir = strings, the root directory of all audio files, each subdirectory are
%              treated as a group of audio files with same label.
%
%  OUTPUT:
%    M       = feature matrix, size of n x d, where n = #files, d = #mfcc_features
%    label_idx   = label_idx of each audio files, ordinal from 1 to #labels, size of n x 1, where n = #files


%% Labels
label_idx = [];
labels = dir(rootdir);
tmp = [];
cnt = 1;
for i=1:length(labels)
	if strncmp(labels(i).name, '.', 1) == 0
		tmp(cnt) = i;
		cnt = cnt + 1;
	end
end
labels = labels(tmp);

%% Audio files
for i=1:length(labels)
	files = dir(fullfile(rootdir, labels(i).name));
	cnt = 1;
	for j=1:length(files)
		if strncmp(files(j).name, '.', 1) == 0
			filename = fullfile(rootdir, labels(i).name, files(j).name);
			% Get mfcc features
			data_ = get(mirmfcc(filename, 'Frame', 1024, 'sp', 50, '%'), 'Data');
			data = data_{1};
			M(length(label_idx)+cnt, :) = mean(data{1}, 2)';
			cnt = cnt + 1;
		end
	end
	cnt = cnt - 1;
	% Set label
	label_idx(length(label_idx)+1:length(label_idx)+cnt) = i;
end

end
