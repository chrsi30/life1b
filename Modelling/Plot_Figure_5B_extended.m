
format long
format compact

set(0, 'DefaultFigureRenderer', 'painters');

modelName  = 'forsgren_NoBack_8C_resection'; 

if contains(modelName, '8C' )
    model_dir = './Models/8C' ; 
else
    model_dir = './Models/2C' ; 
end

load('../DATA/D_MeanSEM.mat'); % importing data
load('../Data/meta_data.mat'); % importing data
load('../DATA/RSX.mat'); % importing data

init %% Setting up model


%% Loading parameters
load('master_8C_prm_resec.mat');
%%% EXTENDED GROUP - STRESSOR - BASED PAT1 PRE-and Post
kstress_pat1 = exp( table2array(master_8C_prm_resec("pat1",'forsgren_NoBack_8C_resection_MiaLab_kstress')));

%%
pat = 'pat2'; %% Changed to pat 2
doScale     = 0; 
tmp2        = 'no_scale';
signaltype  = 'Conc';
type_folder = 'U2';
exam        = 'U2';
Volume_string ='CT';
Bound_string ='OrgBound';

dirr_name_modelName = 'forsgren_NoBack_8C';

LoadFolder = strcat('./Results/8C/',dirr_name_modelName,'/',signaltype,'/', tmp2, '/', Bound_string  ,'/',Volume_string ,'/');
SaveFolder = strcat('./Figures/8C/',dirr_name_modelName,'/',signaltype,'/', tmp2, '/', Bound_string ,'/',Volume_string ,'/');

tmp4 = strcat ( LoadFolder, type_folder, '/' , pat , '/', exam  );

[p_dir,~] = FindBestParametersFile(tmp4, 0, '.mat'); 
load(p_dir); theta = Results.xbest;


eval( strcat('D.', pat, '.', 'U2' ,'.LiverVolume = D.',pat,'.U2.LiverVolume.', Volume_string ) );

tmp7 = D.(pat);
Mdata = meta_data.(pat);

%% simulationa 

[theta1, scale , px] = setupParam8C(theta, tmp7.U2 , Mdata);

theta1x = [theta1(1:17)  1  theta1(18:end)  1 ];

[simLiver1 ,  ~ , s1  ]  = wholeBodySimLiverConc_8C( theta1x, 0:0.1:3600', modelName, scale, doScale);   

tmp = RSX.(pat);

theta1x = [ theta1x( 1:(end-9))    tmp    1 ];

theta1x( ismember( SBparameters(modelName), 'x_stress')) = 0; % stress factor

theta1x( ismember( SBparameters(modelName), 'kstress')) = kstress_pat1; % stress factor

[simLiver2 ,  ~ , s2  ]  = wholeBodySimLiverConc_8C( theta1x, 0:0.1:3600' , modelName, scale, doScale);   

%% 
f4 = figure() ;
tmp4  = tmp7.U2.liver.segment;
set(gcf,'color','w')

set(f4, 'outerposition',[0 0 500 500], 'PaperType','a4')

sim_line_width = 2;
title_size     = 16;
gca_size       = 14;

col1           = [ 0   0   0] ;
col2           = [ 1   0   0] ;

sgtitle( strcat( pat,'-', exam), 'FontSize', title_size);
hold on

plot( (s1.time)./60, simLiver1.sim_segment_c1(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( D.(pat).U2.time/60 , tmp4(:,1), tmp4(:,1)*0.1 , 'O', 'color' , col1 , 'LineWidth', 1 )

plot( (s2.time)./60, simLiver2.sim_segment_c1(:)', 'color' , col2 , 'LineWidth', sim_line_width   )

set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); xlabel('Time (min) ');
ylabel('Gd-EOB-DTPA (mmol/L)');
ylim([0 0.25]); 
yticks([ 0 0.1 0.2])
legend({'Pre-op model simulation','Pre-op data', 'Post-op model simulation','Post-op data'});


