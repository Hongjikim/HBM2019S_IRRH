% basic result of the model 7
% within subject prediction - leave one run out cross-validation 
% run folds doesn't work
% '10 folds' works in just valence
%% directory setup
[basedir, fastdatadir, fastprojectdir] = fast_vary_path('accumbens');
[D, fast_sub, jth, sub_f] = fast_load_data(fastprojectdir, 'mr-train');
modeldir = fullfile(fastprojectdir, '/analysis/imaging/first_level/model07_spm_sing_tri_remv_vw');

%% extract dimension score values

clear dimension_view;

dimension_view(:,:,1) = get_var(D, 'valence', 'conditional', {'eventname', 'view'});
dimension_view(:,:,2) = get_var(D, 'self-related', 'conditional', {'eventname', 'view'});
dimension_view(:,:,3) = get_var(D, 'time', 'conditional', {'eventname', 'view'});
dimension_view(:,:,4) = get_var(D, 'vividness', 'conditional', {'eventname', 'view'});
dimension_view(:,:,5) = get_var(D, 'safe_threat', 'conditional', {'eventname', 'view'});
dimension_view = dimension_view(fast_sub.mr.trainid_n93,:,:);

%% first level model: model07 - single trial model, 15 seconds, removed vw

for subj_i = 1:numel(sub_f)
    
    disp('======================================================')
    fprintf('WORKING ON MODEL7: %s\n', sub_f{subj_i});
    disp('======================================================')
    
    dat = fmri_data(filenames(fullfile(modeldir, sub_f{subj_i}, 'view_*.nii')), which('mni_brain_mask.nii'));
    load(fullfile(modeldir, sub_f{subj_i}, 'vifs.mat'));
    highvif_idx = out.allvifs(contains(out.name, 'view'))>3;
    
    dat.Y = squeeze(dimension_view(subj_i,:,1))';
    wh_fold_all{subj_i} = repmat(1:4, 40, 1); % leave-one-run-out Cross validation
    wh_fold_all{subj_i} = wh_fold_all{subj_i}(:);
    
    dat.dat(:,highvif_idx) = [];
    dat.Y(highvif_idx) = [];
    wh_fold_all{subj_i}(highvif_idx) = [];
    
  
    % valence and use run folds & pcr_lasso
    [cverr, stats_oro_valence{subj_i}, optout] = predict(dat, 'algorithm_name', 'cv_lassopcr', 'nfolds', wh_fold_all{subj_i}, 'error_type', 'mse');
    r7_valence.oro(subj_i,1) = stats_oro_valence{subj_i}.pred_outcome_r;
    % valence and use 10 folds & pcr_lasso
    [cverr, stats_10fold_valence{subj_i}, optout] = predict(dat, 'algorithm_name', 'cv_lassopcr', 'nfolds', 10, 'error_type', 'mse');
    r7_valence.f10(subj_i,1) = stats_10fold_valence{subj_i}.pred_outcome_r;
    
%     % self-relevance
%     dat.Y = squeeze(dimension_view(subj_i,:,2))';
%     dat.Y(highvif_idx) = [];
%     
%     % self-relevance and use run folds
%     [cverr, stats_oro_self{subj_i}, optout] = predict(dat, 'algorithm_name', 'cv_lassopcr', 'nfolds', wh_fold, 'error_type', 'mse');
%     r7_self.oro(subj_i,1) = stats_oro_self{subj_i}.pred_outcome_r;
%     
%     % self-relevance and use 10 folds
%     [cverr, stats_10fold_self{subj_i}, optout] = predict(dat, 'algorithm_name', 'cv_lassopcr', 'nfolds', 10, 'error_type', 'mse');
%     r7_self.f10(subj_i,1) = stats_10fold_self{subj_i}.pred_outcome_r;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SAVE
m7_stats_oro.valence.lasso = stats_oro_valence_lasso;
m7_stats_oro.valence.pcr = stats_oro_valence_pcr;
m7_stats_10fold.valence.lasso = stats_10fold_valence_lasso;
m7_stats_10fold.valence.pcr = stats_10fold_valence_pcr;


save(fullfile(fastprojectdir,'data/analysis_results/model7_pcr_lasso.mat'), ...
   'm7_stats_10fold', 'm7_stats_oro', 'r7_valence_pcr', 'r7_self_pcr', ...
   'wh_fold_all', 'r7_valence_lasso', '-v7.3');

load(fullfile(fastprojectdir,'data/analysis_results/model7_pcr_lasso.mat'))


%% results
% mean(r7_valence_pcr.f10) =    0.4151
% mean(r7_valence_pcr.oro) =   -0.0991
% mean(r7_valence_lasso.f10) =    0.4151
% mean(r7_valence_lasso.oro) =   -0.0991
% mean(r7_self_pcr.f10) =    0.4485
% mean(r7_self_pcr.oro) =   -0.0935