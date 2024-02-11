

clear
clc
close all

format long
format compact

linklr
modelName = 'forsgren_NoBack_8C' ;  model_dir = './Models/8C' ; 

init

%% Pre op
pat           = 'pat8'; 
doScale       =  0; 
scale_string  = 'no_scale';
signaltype    = 'Conc';
type_folder   = 'U2_U3';
Volume_string = 'CT';
Bound_string  = 'OrgBound';
exam          = 'U2';

LoadFolder = strcat('./Results/8C/',modelName,'/',signaltype,'/', scale_string , '/', Bound_string  ,'/',Volume_string ,'/');

tmp4 = strcat ( LoadFolder, type_folder, '/' , pat , '/', exam  );

[p_dir,~] = FindBestParametersFile(tmp4, 0, '.mat'); 
load(p_dir); theta = Results.xbest;


Data1 = D.(pat).(exam);
Mdata = meta_data.(pat);

Data1.LiverVolume = D.(pat).(exam).LiverVolume.(Volume_string) ;

[theta, scale ] = setupParam8C(theta, Data1 , Mdata);

[simLiver ,  ~ , s  ]  = wholeBodySimLiverConc_8C( theta, 0:0.1:3600' , modelName, scale, doScale);       

tmp  = Data1.liver.segment;


%% Post op



%%
f = figure();
set(f, 'outerposition',[0 0 2000 1000], 'PaperType','a4')

sim_line_width = 1.5;
title_size = 16;
gca_size =14;

col1 = [ 0 0  0];
col2 = [ 1 0.5 0];

tiledlayout(4,2, "TileSpacing","tight")

sgtitle( strcat( pat,'-', exam), 'FontSize', title_size);
hold on
%%


nexttile(1);
plot( (s.time)./60, simLiver.sim_segment_c1(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( (Data1.time)./60, tmp(:,1), tmp(:,1)*0.1 ,'O','color' , col1, 'LineWidth', 1)
ylim([0 0.3]); %% <-- OBS-temp


set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); 

ylim([0 0.3]); yticks([ 0 0.1 0.2 0.3])
xticks([0 20 40 60]);
ylabel('Gd-EOB-DTPA (mmol/L)');

legend({'Pre-op simulation', 'Pre-op data', 'Post-op simulation', 'Post-op data'},'Location','northwest');

box 'off'
%%

nexttile(2);
plot( (s.time)./60, simLiver.sim_segment_c2(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( (Data1.time)./60, tmp(:,2), tmp(:,2)*0.1 ,'O','color' , col1, 'LineWidth', 1)

set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); 
ylim([0 0.25]); 


ylim([0 0.3]);  yticks([ 0 0.1 0.2 0.3])
xticks([0 20 40 60]);


box 'off'
%%

nexttile(3);
plot( (s.time)./60, simLiver.sim_segment_c3(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( (Data1.time)./60, tmp(:,3), tmp(:,3)*0.1 , 'O','color' , col1, 'LineWidth', 1)

set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); 
ylim([0 0.25]); 


ylim([0 0.3]);  yticks([ 0 0.1 0.2 0.3])
xticks([0 20 40 60]);

box 'off'
%%
nexttile(4);
plot( (s.time)./60, simLiver.sim_segment_c4(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( (Data1.time)./60, tmp(:,4), tmp(:,4)*0.1 ,'O','color' , col1, 'LineWidth', 1)

set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); 
ylim([0 0.25]); 


ylim([0 0.3]);  yticks([ 0 0.1 0.2 0.3])
xticks([0 20 40 60]);

box 'off'
%%

nexttile(5);
plot( (s.time)./60, simLiver.sim_segment_c5(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( (Data1.time)./60, tmp(:,5), tmp(:,5)*0.1 ,'O','color' , col1, 'LineWidth', 1)

ylabel('Gd-EOB-DTPA (mmol/L)');

set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); xlabel('Time (min) ');
ylim([0 0.25]); 


ylim([0 0.3]);  yticks([ 0 0.1 0.2 0.3])
xticks([0 20 40 60]);

box 'off'

%%
nexttile(6);
plot( (s.time)./60, simLiver.sim_segment_c6(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( (Data1.time)./60, tmp(:,6), tmp(:,6)*0.1 ,'O','color' , col1, 'LineWidth', 1)

set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); xlabel('Time (min) ');
ylim([0 0.25]); 


ylim([0 0.3]);  yticks([ 0 0.1 0.2 0.3])
xticks([0 20 40 60]);

box 'off'

%%
nexttile(7);
plot( (s.time)./60, simLiver.sim_segment_c7(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( (Data1.time)./60, tmp(:,7), tmp(:,7)*0.1 ,'O','color' , col1, 'LineWidth', 1)

set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); xlabel('Time (min) ');
ylim([0 0.25]); 


ylim([0 0.3]);  yticks([ 0 0.1 0.2 0.3])
xticks([0 20 40 60]);

box 'off'

%%
nexttile(8);
plot( (s.time)./60, simLiver.sim_segment_c8(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( (Data1.time)./60, tmp(:,8), tmp(:,8)*0.1 ,'O','color' , col1, 'LineWidth', 1)

set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); xlabel('Time (min) ');
ylim([0 0.25]); 


ylim([0 0.3]);  yticks([ 0 0.1 0.2 0.3])
xticks([0 20 40 60]);

box 'off'

%%

set(gcf,'color','w')









