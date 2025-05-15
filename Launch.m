tic 
YourPath = 'YourPath' % YourPath
addpath(YourPath) 
%% get directory of interest (add directory to video files here)
selpath = uigetdir;
cd(selpath)
dirContents = dir('**/*.*') ;
strIdx = (strfind({dirContents.name},'.'));
strIdx = cellfun(@isempty,strIdx);
dirContents = dirContents(strIdx);

%% create parameters object 
Params.FirstDir = pwd; %first directory to return to 
fullPath = {}
for i = 1:length(dirContents)
    fullPath{i,1} = strcat(dirContents(i).folder,'\',dirContents(i).name)
end
    
Params.Folders = fullPath
% get videos in each folder
allFiles = {}
for kk = 1:size(Params.Folders,1)
    cd(Params.Folders{kk})
    fileList = dir('*.mp4')'
    fileList = {fileList.name}'
    allFiles{kk,1} = fileList
    cd(Params.FirstDir)
end
Params.vidNames = allFiles;

%Zones for each cage 
z1 = [0, 0; 600, 0; 600, 580; 0, 580]; % Custom Area 1
z2 = [600, 0; 1200, 0; 1200, 580; 600, 580]; % Custom Area 2
Params.Zones = {z1, z2};

%% Run tracking program in loop (this will loop over videos in directory of interest)
for foldNumber = 1:length(Params.Folders)
    cd(Params.Folders{foldNumber})
    for vidNumber = 1:length(Params.vidNames{foldNumber})
        vidName = Params.vidNames{foldNumber}{vidNumber}
        
        for start_time_min = 0:4 % The video duration is 5 minutes.
            end_time_min = start_time_min + 1; % Analyze one minute at a time.
            Trax(vidName, start_time_min, end_time_min,YourPath,z1,z2)
        end
        
        cd(Params.FirstDir);
        end
    cd(Params.FirstDir)
end
toc 