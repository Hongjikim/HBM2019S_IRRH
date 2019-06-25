%% NPS
% See brain activations in NPS masks

preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model4/sub-irrh006';
beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
a = fmri_data(beta_fnames(1,:), which('gray_matter_mask.img'));

model_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model4/ttest';

betamap_list = filenames(fullfile(model_dir, 'XX*'));

for i = 1:numel(betamap_list)
    
    load(betamap_list{i});
    
    close all
    
    % a = fmri_data(betamap_list{i});
    if i == 1
        a.dat = bb.dat; name = 'blue_base'; % mean(blue_base,2);
    elseif i == 2
        a.dat = bp.dat; name = 'blue_pain'; % mean(blue_pain,2);
    elseif i== 3
        a.dat = bw.dat; name = 'blue_warm';% mean(blue_warm,2);
    elseif i== 4
        a.dat = rb.dat; name = 'red_base'; % mean(red_base,2);
    elseif i == 5
        a.dat = rp.dat; name = 'red_pain'; % mean(red_pain,2);
    else
        a.dat = rw.dat; name = 'red_warm'; % mean(red_warm,2);
    end
    
    a2 = fmri_data('/Users/hongji/Dropbox/IRRH_2019S/NPS_POS.nii');
    a2_re = resample_space(a2, a, 'nearestneighbour');
    %  unique(a2_re.dat) % check if it only contains an either value of 0 or 1
    a3 = a;  a3.dat = a.dat .* a2_re.dat;
    %  orthviews_multiple_objs({a, a3}) % see pos values of NPS
    
        a22 = fmri_data('/Users/hongji/Dropbox/IRRH_2019S/NPS_NEG2.nii');
    a22_re = resample_space(a22, a, 'nearestneighbour');
    %  unique(a22_re.dat) % check if it only contains an either value of 0 or 1
    a4 = a;  a4.dat = a.dat .* a22_re.dat;
    %  orthviews_multiple_objs({a, a4}) % see pos values of NPS
    
    a5 = a3; a5.dat = a3.dat + a4.dat; % no overlaps --> able to sum
    %  orthviews_multiple_objs({a, a5}) % see pos & neg values of NPS
    
    % a.u. calculation
    new_a5 =a3; new_a5.dat = a3.dat - a4.dat;
    new_pos = a3; new_pos.dat = a3.dat;
    new_neg = a3; new_neg.dat = a4.dat;
    
    au_trial_all{i} = mean(new_a5.dat);
    au_trial_pos{i} = mean(new_pos.dat);
    au_trial_neg{i} = mean(new_neg.dat);
    %  ALL -0.0013    0.0026   -0.0007   -0.0005    0.0026   -0.0012
    % 
%     tdat = ttest(a5); tdat_threshold = threshold(tdat, .005, 'unc');
% 
%     brain_activations_wani(region(tdat))
%     FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
%     for ifig = 1:length(FigList)
%         Fighandle = FigList(ifig);
%         Fighandle.Name = ['NPS_', name, '_fig', num2str(ifig), '_unc.png']; % = %get(Fighandle, [num2str(i), '_', num2str(ifig), '_NPC_unc']);
%         saveas(Fighandle, fullfile(pwd, Fighandle.Name))
%     end
%     close all;
end

%
for i =1:6, mean_nps_all(i) = mean(au_trial_all{i}); end
for i =1:6, mean_nps_pos(i) = mean(au_trial_pos{i}); end

for i =1:6, mean_nps_neg(i) = mean(au_trial_neg{i}); end

bar(mean_nps_all)
bar(scale(mean_nps_all)+1)

% -0.0013    0.0026   -0.0007   -0.0005    0.0026   -0.0012

%% See brain activations in NPS masks (from Sooahn)

preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model4/sub-irrh006';

betamap_list = filenames(fullfile(preproc_subject_dir, 'beta*.nii'));

for i = 1:numel(betamap_list)
    
    close all
    clear a;
    a = fmri_data(betamap_list{i});
    if i == 1
        a2 = fmri_data('/Users/hongji/Dropbox/IRRH_2019S/NPS_POS.nii');
        a2_re = resample_space(a2, a, 'nearestneighbour');
        %  unique(a2_re.dat) % check if it only contains an either value of 0 or 1
        a3 = a;  a3.dat = a.dat .* a2_re.dat;
        %  orthviews_multiple_objs({a, a3}) % see pos values of NPS
        
        a22 = fmri_data('/Users/hongji/Dropbox/IRRH_2019S/NPS_NEG2.nii');
        a22_re = resample_space(a22, a, 'nearestneighbour');
        %  unique(a22_re.dat) % check if it only contains an either value of 0 or 1
        a4 = a;  a4.dat = a.dat .* a22_re.dat;
        %  orthviews_multiple_objs({a, a4}) % see pos values of NPS
        
        a5 = a3; a5.dat = a3.dat + a4.dat; % no overlaps --> able to sum
        %  orthviews_multiple_objs({a, a5}) % see pos & neg values of NPS
    end
    
    a_fin = a5; a_fin.dat = a.dat .* a5.dat;
    a_fin = threshold(ttest(a_fin), 0.05, 'unc');
    brain_activations_wani(region(a_fin))
    % saveas(gcf, [num2str(i) 'pain_NPS_unc.png']);
    FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
    for ifig = 1:length(FigList)
        Fighandle = FigList(ifig);
        Fighandle.Name = [num2str(i), '_', num2str(ifig), '_NPC_unc.png']; % = %get(Fighandle, [num2str(i), '_', num2str(ifig), '_NPC_unc']);
        saveas(Fighandle, fullfile(pwd, Fighandle.Name))
    end
    close all;
    
end

%% Apply keuken 2014 mask

% binarize NPS via FSL
% terminal: fslmaths /Volumes/accumbens/github/canlab/MasksPrivate/Masks_private/2013_Wager_NEJM_NPS/weights_NSF_FDR05_positive_smoothed_larger_than_10vox.hdr -bin /Users/Sooahn/Desktop/HBM/analysis/NPS_POS.nii
% terminal: fslmaths /Volumes/accumbens/github/canlab/MasksPrivate/Masks_private/2013_Wager_NEJM_NPS/weights_NSF_FDR05_negative_smoothed_larger_than_10vox.hdr -abs -bin /Users/Sooahn/Desktop/HBM/analysis/NPS_NEG2.nii