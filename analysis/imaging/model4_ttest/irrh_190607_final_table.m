%% Basic Setting (run-averaged)

sub_idx = input('Subject index? 3? 4? :');

% reorganization

%load
bbfiles = filenames(fullfile(pwd, 'bb*'));
bwfiles = filenames(fullfile(pwd, 'bw*'));
bpfiles = filenames(fullfile(pwd, 'bp*'));
rbfiles = filenames(fullfile(pwd, 'rb*'));
rwfiles = filenames(fullfile(pwd, 'rw*'));
rpfiles = filenames(fullfile(pwd, 'rp*'));

bb3 = load(bbfiles{1}); bb4 = load(bbfiles{2}); clear bbfiles;
bw3 = load(bwfiles{1}); bw4 = load(bwfiles{2}); clear bwfiles;
bp3 = load(bpfiles{1}); bp4 = load(bpfiles{2}); clear bpfiles;
rb3 = load(rbfiles{1}); rb4 = load(rbfiles{2}); clear rbfiles;
rw3 = load(rwfiles{1}); rw4 = load(rwfiles{2}); clear rwfiles;
rp3 = load(rpfiles{1}); rp4 = load(rpfiles{2}); clear rpfiles;

if sub_idx == 4
    preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model4/sub-irrh006';
    beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
    dat = fmri_data(beta_fnames(1,:), which('gray_matter_mask.img'));
    
    blue_base = dat; blue_base.dat = bb4.bb_run5_sub03;
    blue_warm = dat; blue_warm.dat = bw4.bw_run5_sub03;
    blue_pain = dat; blue_pain.dat = bp4.bp_run5_sub03;
    
    red_base = dat; red_base.dat = rb4.rb_run5_sub03;
    red_warm = dat; red_warm.dat = rw4.rw_run5_sub03;
    red_pain = dat; red_pain.dat = rp4.rp_run5_sub03;
    
elseif sub_idx == 3
    preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model4/sub-irrh005';
    beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
    dat = fmri_data(beta_fnames(1,:), which('gray_matter_mask.img'));
    
    blue_base = dat; blue_base.dat = bb3.bb_run5_sub03;
    blue_warm = dat; blue_warm.dat = bw3.bw_run5_sub03;
    blue_pain = dat; blue_pain.dat = bp3.bp_run5_sub03;
    
    red_base = dat; red_base.dat = rb3.rb_run5_sub03;
    red_warm = dat; red_warm.dat = rw3.rw_run5_sub03;
    red_pain = dat; red_pain.dat = rp3.rp_run5_sub03;
    
end

%% %% Basic Setting (trial - based)

sub_idx = input('Subject index? 3? 4? :');

% reorganization

%load

if sub_idx == 3
    allfiles = filenames(fullfile(pwd, 'A*'));
    for i =1:6
        load(allfiles{i})
    end
    
    preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model4/sub-irrh006';
    beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
    dat = fmri_data(beta_fnames(1,:), which('gray_matter_mask.img'));
    
    bb = dat; bb.dat = blue_base;
    bw = dat; bw.dat = blue_warm;
    bp = dat; bp.dat = blue_pain;
    rb = dat; rb.dat = red_base;
    rw = dat; rw.dat = red_warm;
    rp = dat; rp.dat = red_pain;
    
elseif sub_idx == 4
    allfiles = filenames(fullfile(pwd, 'XX*'));
    for i =1:6
        load(allfiles{i})
    end
    
    preproc_subject_dir = '/Users/hongji/Dropbox/IRRH_2019S/scripts_git/analysis/imaging/first_level/model4/sub-irrh005';
    beta_fnames = filenames(fullfile(preproc_subject_dir, 'beta*'), 'char');
    dat = fmri_data(beta_fnames(1,:), which('gray_matter_mask.img'));
    
    bb = dat; bb.dat = blue_base;
    bw = dat; bw.dat = blue_warm;
    bp = dat; bp.dat = blue_pain;
    rb = dat; rb.dat = red_base;
    rw = dat; rw.dat = red_warm;
    rp = dat; rp.dat = red_pain;
    
end

%% Condition

diff_pain_base = dat; diff_pain_base.dat = [rp.dat - rb.dat, bp.dat - bb.dat]; % PAIN - BASE

diff_pain_base = dat; diff_pain_base.dat = [rp.dat - rb.dat - (bp.dat - bb.dat)]; % (RP - RB) - (BP - BB)
diff_pain_base = dat; diff_pain_base.dat = [rw.dat - rb.dat - (bw.dat - bb.dat)]; % (RW - RB) - (BW - BB)

diff_pain_base = dat; diff_pain_base.dat = [rb.dat - bb.dat]; % (RB -BB) 


%% T-test, visualization, table

diff_pain_base = dat; diff_pain_base.dat = [rp.dat - rb.dat, bp.dat - bb.dat]; % PAIN - BASE
diff_pain_base = dat; diff_pain_base.dat = [rp.dat - rb.dat + bp.dat - bb.dat]; % PAIN - BASE

diff_pain_base = dat; diff_pain_base.dat = []; 
diff_pain_base = dat; diff_pain_base.dat = [(rp.dat - bp.dat) - (rb.dat - bb.dat)]; % PAIN - BASE

tdat = ttest(diff_pain_base);
% tdat_threshold = threshold(tdat, .005, 'fdr', 'k', 5);
%tdat_threshold = threshold(tdat, .05, 'unc', 'k', 20);
tdat_threshold = threshold(tdat, .01, 'unc', 'k', 10);

ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
close all;
brain_activations_wani(region(ma))

FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for ifig = 1:length(FigList)
    Fighandle = FigList(ifig);
    Fighandle.Name = ['FINAL', '_RB_PB_unc_' num2str(ifig) '.png']; % = %get(Fighandle, [num2str(i), '_', num2str(ifig), '_NPC_unc']);
    saveas(Fighandle, fullfile(pwd, Fighandle.Name))
end

dat1 = tdat_threshold;
dat1.dat = -log10(dat1.p) .* dat1.sig .* (-(dat1.dat < 0) + (dat1.dat > 0));
dat1.fullpath = fullfile(pwd, 'temp_for_table.img');
write(dat1);
cl = region(dat1.fullpath);

nowtime = clock;
savename = fullfile(pwd, ['FINAL_RB_PB_unc_Sub04_' date '_' ...
    num2str(nowtime(4)) '-' num2str(nowtime(5)) '.txt']);
cluster_table_wani_hongji(cl, 1, 0, [1 32], 'writefile', savename);

%%

diff_red = red_pain; diff_red.dat = red_warm.dat - red_base.dat;
diff_blue = blue_pain; diff_blue.dat = blue_warm.dat - blue_base.dat;

diff_warm_base.dat = [red_warm.dat - red_base.dat, blue_warm.dat - blue_base.dat];

sum_pain = red_pain; sum_pain.dat = (red_pain.dat + blue_pain.dat)/2;
sum_warm = red_pain; sum_warm.dat = (red_warm.dat + blue_warm.dat)/2;
sum_base = red_pain; sum_base.dat = (red_base.dat + blue_base.dat)/2;

% Pain vs Base (Red + blue)
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_pain.dat - red_base.dat, blue_pain.dat - blue_base.dat];

% Warm vs Base (Red + blue)
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_warm.dat - red_base.dat, blue_warm.dat - blue_base.dat];

% Red vs Blue (all condition)
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_pain.dat - blue_pain.dat, red_warm.dat - blue_warm.dat, red_base.dat - blue_base.dat];

% Red vs Blue (PW condition)
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_pain.dat - blue_pain.dat, red_warm.dat - blue_warm.dat];

% Red vs Blue (base only)
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_base.dat - blue_base.dat];

% RP vs BP
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_pain.dat - blue_pain.dat];

% Rw vs Bw
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_warm.dat - blue_warm.dat];

% RP - RB vs BP - BB
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_pain.dat - red_base.dat - blue_pain.dat + blue_base.dat];

% RW - RB vs BW - BB
diff_redblue = red_pain;
diff_redblue.dat = [];
diff_redblue.dat = [red_warm.dat - red_base.dat - blue_warm.dat + blue_base.dat];

%%
diff_pain_base = red_pain; diff_pain_base.dat = sum_pain.dat - sum_base.dat;

diff_warm_base_RB = diff_red; diff_warm_base_RB.dat = diff_red.dat - diff_blue.dat;
diff_warm_base_RB = diff_red; diff_warm_base_RB.dat = (diff_red.dat + diff_blue.dat)/2;
diff_pain_warm = sum_pain; diff_pain_warm.dat = (sum_pain.dat - sum_warm.dat);

% plot
tdat = ttest(diff_redblue);
tdat_threshold = threshold(tdat, .05, 'unc', 'k', 50);
% tdat_threshold = threshold(tdat, .05, 'fdr', 'k' ,10);
% brain_activations_wani(region(tdat_threshold))
% tdat_threshold = threshold(tdat, .01, 'unc', 'k', 10);

% orthviews(tdat_threshold)
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
close all;
brain_activations_wani(region(ma))

%% ttest Warm vs. Base

diff_red = red_warm; diff_red.dat = red_warm.dat - red_base.dat;
diff_blue = blue_warm; diff_blue.dat = blue_warm.dat - blue_base.dat;

diff_warm_base_RB = diff_red; diff_warm_base_RB.dat = diff_red.dat - diff_blue.dat;

% plot
tdat = ttest(diff_warm_base_RB);
tdat_threshold = threshold(tdat, .1, 'unc', 'k', 50);
% tdat_threshold = threshold(tdat, .05, 'fdr', 'k' ,10);
% brain_activations_wani(region(tdat_threshold))

% orthviews(tdat_threshold)
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
brain_activations_wani(region(ma))

%% compare two preproc (Pain - Base)

diff_new = new_pain;
diff_new.dat = new_pain.dat - new_base.dat;

diff_old = old_pain;
diff_old.dat = old_pain.dat - old_base.dat;

tdat = ttest(diff_old);
tdat_threshold = threshold(tdat, .005, 'unc', 'k', 10);
% tdat_threshold = threshold(tdat, .05, 'fdr', 'k' ,10);
% brain_activations_wani(region(tdat_threshold))

% orthviews(tdat_threshold)
ma = apply_mask(tdat_threshold, which('keuken_2014_enhanced_for_underlay.img'));
brain_activations_wani(region(ma))


%% MAKE TABLE

dat = threshold(dat, 0.000001, 'unc', 'k', 3);
dat1 = dat;
dat1.dat = -log10(dat1.p) .* dat1.sig .* (-(dat1.dat < 0) + (dat1.dat > 0));
dat1.fullpath = fullfile(resdir, 'temp_for_table.img');
write(dat1);
cl = region(dat1.fullpath);

savename = fullfile(outputdir, ['table1_temp_000001_' date_now '.txt']);
% cluster_table_wani_hongji(cl, 1, 0, [1 32], 'writefile', savename);




