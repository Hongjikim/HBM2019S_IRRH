% show orthviews of parcellation
%
% s = {'sfg','mfg','ifg','org','prg','pcl','stg','mtg','itg','fug','phg','psts',...
%     'spl','ipl','pcun','pog','ins','cg','mvocc','locc','amg','hip','bg','tha',...
%     'cb','hypothalamus','brainstem','periaqueductal','s_nigra','reg_nucleus'};
%
% example ::  parcel_view('pog')
%
% Copyright Byeol Kim, 2019
function parcel_view(i)
parcel_set{1} = 1:14;
parcel_set{2} = 15:28;
parcel_set{3} = 29:40;
parcel_set{4} = 41:52;
parcel_set{5} = 53:64;
parcel_set{6} = 65:68;
parcel_set{7} = 69:80;
parcel_set{8} = 81:88;
parcel_set{9} = 89:102;
parcel_set{10} = 103:108;
parcel_set{11} = 109:120;
parcel_set{12} = 121:124;
parcel_set{13} = 125:134;
parcel_set{14} = 135:146;
parcel_set{15} = 147:154;
parcel_set{16} = 155:162;
parcel_set{17} = 163:174;
parcel_set{18} = 175:188;
parcel_set{19} = 189:198;
parcel_set{20} = 199:210;
parcel_set{21} = 211:214;
parcel_set{22} = 215:218;
parcel_set{23} = 219:230;
parcel_set{24} = 231:246;
parcel_set{25} = 247:273;
parcel_set{26} = 274;
parcel_set{27} = 275;
parcel_set{28} = 276;
parcel_set{29} = 277:278;
parcel_set{30} = 279:280;


s = {'sfg','mfg','ifg','org','prg','pcl','stg','mtg','itg','fug','phg','psts',...
    'spl','ipl','pcun','pog','ins','cg','mvocc','locc','amg','hip','bg','tha',...
    'cb','hypothalamus','brainstem','periaqueductal','s_nigra','reg_nucleus'};

n = ismember(s, i);

parcel_dir = '/Volumes/wissen/github/cocoanlab/cocoanCORE/Canonical_brains';
parcel = fullfile(parcel_dir, 'Fan_et_al_atlas_r280.nii');

par = fmri_data(parcel);

% viewing
regn = parcel_set{n};     % region you want to see
idx = ismember(par.dat, regn);
par_t = par;
par_t.dat(~idx) = 0;

orthviews(par_t)
end
