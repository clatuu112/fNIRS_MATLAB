% ** Guidance
% 
% This script creates a brain picture that reflects the significance and T
% Value of each channel using BrainNet for xlsx resultsof NirsitAnalysis for each channel. 
%
% ** Preliminaries
% 
% 1. File name: 2ndLevelGLM_48channel.xlsx
% 2. File name: NIRSITChannelMNI.mat, variable name: NIRISTChannelMNI
% 3. File name: BN_Option_Ttest.mat, variable name: EC
% 
% ** Execution
% 
% NABNCh(group, filename)
% 
% Example)
% NABNCh('1G_33_T1_ONE SAM','2ndLevelGLM_48channel.xlsx')
% 
% 
% Seung-Hyuk Kwon, Oct. 2023.



function NABNCh(contrast,filename)

xls = xlsread(filename);
load('NIRSITChannelMNI.mat','NIRSITChannelMNI');
load('BN_Option_Ttest.mat','EC');

for ss=1:size(xls, 1)
    ttestResult(ss).contrast = contrast;
    ttestResult(ss).channel = ss;
    ttestResult(ss).pvalue = xls(ss,4);
    ttestResult(ss).tvalue = xls(ss,2);

end


sigExistFlag = 0;

nodeArray = zeros(48,6);
nodeArray(:,1:3) = NIRSITChannelMNI;




for cc=1:size(ttestResult, 2)
    
    nodeArray(cc,6) = cc;
    
    if ttestResult(cc).pvalue < 0.05
        if sigExistFlag == 0
            sigExistFlag = 1;
        end
        nodeArray(cc,4) = ttestResult(cc).tvalue;
        nodeArray(cc,5) = 1;
    end
end
nodeFilename = convertCharsToStrings(['node_Ch_Contrast_',ttestResult(1).contrast,'.txt']);
writematrix(nodeArray,nodeFilename,'Delimiter','tab');

nodeFilenameBN = ['node_Ch_Contrast_',ttestResult(1).contrast,'.node'];
movefile(nodeFilename,nodeFilenameBN);

disp(['Node file of Conrast ',ttestResult(1).contrast,' for BrainNet is generated.']); 


% Generating BrainNet option file. 
tvalueArray = nodeArray(:,4);
minTv = min(tvalueArray(tvalueArray~=0));
maxTv = max(tvalueArray);

% if minTv ~= maxTv
    if abs(minTv) <= abs(maxTv)
        cmHigh = maxTv*1.1;
        cmLow = -cmHigh;
    else
        cmLow = minTv*1.1;
        cmHigh = -cmLow;
    end
        
    % for hot colormap
    % cmHigh = maxTv+(maxTv - minTv)*0.3;
    % cmLow = minTv-(maxTv - minTv)*0.3
    
%
% if minTv < 0
%     cm = 1;
%     EC.nod.color_map = cm;
%end
EC.nod.color_map_high = cmHigh;
EC.nod.color_map_low = cmLow;

BNOptionFilename = ['BN_Option_Ttest_Ch_Contrast_',ttestResult(1).contrast,'.mat'];
save(BNOptionFilename, 'EC');

disp(['Option file of Conrast ',ttestResult(1).contrast,' for BrainNet is generated.']); 


% Generating BrainNet Fig. file.

if sigExistFlag == 0
    warning('No significant channel in this contrast!');
    return;
end

figFilename = ['BrainNet_Ch_Contrast_',ttestResult(1).contrast,'.png'];

BrainNet_MapCfg('BrainMesh_ICBM152.nv',nodeFilenameBN,BNOptionFilename,figFilename);

disp(['Figure of Conrast ',ttestResult(1).contrast,' for BrainNet is generated.']); 

disp('==============================================================================');
disp(['BNFileProcess of Conrast ',ttestResult(1).contrast,' for BrainNet is completed!']);

clear;
end




