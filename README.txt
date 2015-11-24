README.txt
Metric Learning for Music Discovery with Source and Target Playlists
Ying-Shu Kuo 2015.11.19

0. Check the slides for detailed instruction.
http://www.slideshare.net/yingshukuo/user-preference-learning-and-playlist-generation

1. What is this?
   ELI5:

   This is part of the program that helps the music lover to explore music that
   they haven't experienced before.

   For example, if Shu really likes Jazz music, and he now wants to know what
   the heck is going on in Death Metal music. However he does not want to just
   go dive in to Death Metal, since it would make him hate Death Metal
   immediately (no offense lol just subjective taste). So our solution to this
   is to build up a playlist that starts from Shu's favorite Jazz music, and the
   playlist would gradually introduce Shu less Jazz but more Death Metal music,
   hoping that Shu wouldn't be scared away before the playlist finally reaches
   Death Metal songs.

   ELI engineer:

   This is a Matlab-based prototype program that applies metric learning techniques
   to reform the audio feature space so that the audio similarity would not only
   solely based on audio features itself, but also the input of user-provided
   knowledge set / familiar songs and exploring set / specific unfamiliar songs.

   Theoretically the audio feature can be chosen by user's choice, I however
   recommend Spotify's (or previous Echonest) provided 12-D audio features since
   they claim that the similarity of 2 points on the 12-D space can be measured
   by Euclidean distance of 2 points, which is suitable for both system requirement
   and metric learning use.

   I use GB-LMNN to reform the feature space.
   I use t-SNE to reduce the feature dimension.
   For more information on these algorithms please go check
   LMNN    http://www.cs.cornell.edu/~kilian/code/lmnn/lmnn.html
   GB-LMNN http://www.cse.wustl.edu/~xuzx/research/publications/gb-lmnn.pdf
   t-SNE   https://lvdmaaten.github.io/tsne/


2. How to use it?
   Open Matlab, include all the path under this folder, and run script.m by

   $ script

   You can modify the script for different input or different process.
   What it does is to load preexising data (MSD 1000 songs 10 genres)
   and apply predefined label (a set of familiar songs and a set of songs to explore),
   and feed these parameters to a series of functions.

   generateMusic() function is not working here because the song files are just too big.
   I didn't upload them. Also it's hard-coded for the MSD 10 genres.

   There might be a catch when trying to run the script though. Make sure before
   running script.m, run mLMNN2.5/demo.m to make sure the library is working properly.
   If not, try run mLMNN2.5/install.m to recompile mex files in mLMNN2.5/mexfunctions/*.cpp

   In my case, I use Matlab R2014a, modify mexopts.sh to tell it to use gcc and g++
   instead of clang and clang++, and $ mex -setup to tell Matlab use my mexopts.sh
   instead.

   You can see my fixes in mexopts.sh in _unused/ folder.

3. What is this? For real.
   MAIN FUNCTIONS
   script.m
     The program that triggers everything, think of it as the end user.
     Starting from transforming the feature space, then build the playlist,
     then preview the generated playlist.
     include:
       main() from ./main.m
       buildPath() from pathfinding/buildPath.m
       generateMusic() from ./generateMusic.m
   main.m
     Controls feature space transform and feature dimension reduction.
     input: 
       X: #song x #feature (12-D feature)
       labels: #song x 1 (genre, only for evaluation and visualization)
       user_labels: #song x 1 (1 as starting 2 as ending)
     output:
       X_gblm: #song x #new_feature (12-D??????????)
       X_dim: #song x #reduced_feature (2-D)
     program:
       input   =(LMNN)=>    linear space transform L
       input+L =(GB-LMNN)=> non-linear space transform function F
       input   =(F)=>       X_gblm
       X_gblm  =(T-SNE)=>   X_dim
     include:
       lmnn2() from mLMNN2.5/lmnn2.m
       gb_lmnn() from mLMNN2.5/gb_lmnn.m
       tsne_ys() from t-SNE/tsne_ys.m
   pathfinding/buildPath.m
     Playlist generation given a feature space and starting and ending song sets.
     Apply shortest path algorithm with Dijkstra, to a restricted search range,
     and an edge linking-thresholded graph.
   generateMusic.m
     If the raw musics are given, we can use this with path index to generate
     paths to chosen musics and concatenate them together.
   
   PARAMETER TUNING
   paramtuning/grid_search.m
     Find the best parameters of LMNN and GB-LMNN to use for certain dataset.

   EVALUATION
   evaluation/
     Evaluate transformed feature space by DB-Index.
     DB-Index measures the clusterness of given 2 or more sets.
     In general if the cluster are tighter within set, and further between set,
     then the DB-Index has a smaller number, which means better.

   TOOLS
   mLMNN2.5/
   t-SNE/


