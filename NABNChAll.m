% ** Guidance
% 
% This script creates a brain picture that reflects the significance and T
% Value of each channel using BrainNet for xlsx resultsof NirsitAnalysis for each channel. 
%
% ** Preliminaries
% 
% 1. Results Folder : folder name is contrast name, and result file name is
% start with '2', file extention is 'xlsx'.
% 2. File name: NIRSITChannelMNI.mat, variable name: NIRISTChannelMNI
% 3. File name: BN_Option_Ttest.mat, variable name: EC
% 
% ** Execution
% 
% NABNChAll()
% 
% 
% Seung-Hyuk Kwon, Oct. 2023.



function NABNChAll()

list = dir('**/2*.xlsx');

for gg=1:size(list,1)
    foldername = strsplit(list(gg).folder,"/");
    group = char(foldername(end));
    fileName = [list(gg).folder,'/',list(gg).name];
    NABNCh(group,fileName);



end







