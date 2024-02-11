clear
clc
close all

format long
format compact

set(0, 'DefaultFigureRenderer', 'painters');

modelName = 'forsgren_NoBack_8C_resection';
if contains(modelName, '8C' )
    model_dir = './Models/8C' ; 
else
    model_dir = './Models/2C' ; 
end
load('../DATA/D_MeanSEM.mat'); % importing data
load('../DATA/meta_data.mat'); % importing data
init %% Setting up model
%%
pat = 'pat1'; 
doScale     = 0; 
tmp2        = 'no_scale';
signaltype  = 'Conc';
type_folder = 'U2_U3';
exam        = 'U2';
Volume_string ='CT';
Bound_string ='OrgBound';

LoadFolder = strcat('./Results/8C/',modelName,'/',signaltype,'/', tmp2, '/', Bound_string  ,'/',Volume_string ,'/');
SaveFolder = strcat('./Figures/8C/',modelName,'/',signaltype,'/', tmp2, '/', Bound_string ,'/',Volume_string ,'/');

tmp4 = strcat ( LoadFolder, type_folder, '/' , pat , '/', exam  );

[p_dir,~] = FindBestParametersFile(tmp4, 0 ,'.mat'); 
load(p_dir); theta = Results.xbest;

eval( strcat('tmp3 = D.', pat ))

eval( strcat('D.', pat, '.', 'U2' ,'.LiverVolume = D.',pat,'.U2.LiverVolume.', Volume_string ) );
eval( strcat('D.', pat, '.', 'U3' ,'.LiverVolume = D.',pat,'.U3.LiverVolume.', Volume_string ) );

eval( strcat('tmp7 = D.', pat));
eval(strcat('Mdata = meta_data.', pat,';') );

%% PLOT

fig = 0;
sim_line_width = 1.5;
title_size = 16;
gca_size =12;

%%
f = figure();

f.Position = [0 0 600 350];

%%% Simulation 1 

[theta1, scale ] = setupParam8C(theta, tmp7.U2 , Mdata);
theta1 = [ theta1 1];
[simLiver1 ,  ~ , s1  ]  = wholeBodySimLiverConc_8C( theta1, 0:1:3600', modelName, scale, doScale);   
[theta2, scale ] = setupParam8C(theta, tmp7.U3 , Mdata);
theta2 = [ theta2 1];
theta2( ismember( SBparameters(modelName), 'x_stress')) = 0; % stress factor

[simLiver2 ,  ~ , s2  ]  = wholeBodySimLiverConc_8C( theta2, 0:1:3600' , modelName, scale, doScale);   


col1 = [ 0 0 0];


y_max = 0.3;

for kk = 1:8

hold on
subplot(2,4,kk)

eval(['tmp2 = simLiver1.sim_segment_c'  int2str(kk) , ';']);

plot( (s1.time)./60, tmp2', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on

if kk == 1
 xlabel('Time (min) ');
 ylabel('Gd-EOB-DTPA (mM)');
end
set(gca,'FontSize',gca_size);
ylim([0 y_max]);
xlim([0 60]);
end
set(gcf,'color','w');
box 'off'


%%% simulation 2 - readding segment 4

tmp_sc2 = tmp7;
tmp_sc2.U3.LiverVolume.segments(4) = tmp7.U2.LiverVolume.segments(4);
% segment 4
[theta3, scale ] = setupParam8C(theta, tmp_sc2.U3 , Mdata);
theta3 = [ theta3 1];
theta3( ismember( SBparameters(modelName), 'x_stress')) = 0; % stress factor
theta3( ismember( SBparameters(modelName), 'px4')) = 1; % Re adding segment 4;
[simLiver3 ,  ~ , s3  ]  = wholeBodySimLiverConc_8C( theta3, 0:1:3600' , modelName, scale, doScale);   

col3 = [ 0 1 0.8];

for kk = 1:8

hold on
subplot(2,4,kk)

eval(['tmp2 = simLiver3.sim_segment_c'  int2str(kk) , ';']);

plot( (s1.time)./60, tmp2', 'color' , col3 , 'LineWidth', sim_line_width   )
hold on


set(gca,'FontSize',gca_size);
ylim([0 0.3]); yticks([ 0 0.3]);
xlim([0 60]); xticks([ 0 60]);

box 'off'

end

%%% Simulation 3 - better kinflux


%%% 15 different influxes 
for kk = 1:15

[theta4, scale ] = setupParam8C(theta, tmp7.U3 , Mdata);
theta4x = [ theta4 1];
theta4x( ismember( SBparameters(modelName), 'x_stress')) = 0; % stress factor


theta4x( ismember( SBparameters(modelName), 'kstress')) =  theta4x( ismember( SBparameters(modelName), 'kstress'))*(0.1*kk); % stress factor


[simLiver4 ,  ~ , s4  ]  = wholeBodySimLiverConc_8C( theta4x, 0:1:3600' , modelName, scale, doScale);   

Kstress_exmpales.(['example' int2str(kk) ]) = simLiver4;
Kstress_exmpales.(['Allsim' int2str(kk) ])  = s4;

box 'off'

clear simLiver4;
end

col4 = [ 0 0 0.8];
%%% Pick the middle scenario, influx increase 50% 

for kk = 1:8

hold on
subplot(2,4,kk)

eval(['tmp2 = Kstress_exmpales.example15.sim_segment_c'  int2str(kk) , ';']);

plot( (s1.time)./60, tmp2', 'color' , col4 , 'LineWidth', sim_line_width   )
hold on


set(gca,'FontSize',gca_size);
box 'off'
end

set(gcf,'color','w');

%% Total

Fb    = 0.12 ;                   % Fraction of blood in liver volume
Flees = 0.20 ;                   % EES fraction in liver volume.


f = figure();
set(gcf, 'color', 'w' ) ;
set(gcf, 'Units', 'centimeters');
set(gcf,'position', [ 0  0 30 10])


col2 = [ 1 0.8 0 ]; % for post-surgery

tiledlayout(1,3,"TileSpacing","tight");

nexttile;

idx = ismember(s1.states,{'Ch_1', 'Ch_2' , 'Ch_3', 'Ch_4', 'Ch_5', 'Ch_6', 'Ch_7', 'Ch_8'}) ;
tmp2 = sum (  s1.statevalues(:,idx ).*tmp7.U2.LiverVolume.segments' , 2) ;
plot( s1.time./60, tmp2 , 'color' , col1 , 'LineWidth', 2 ) ;
hold on

tmp2 = sum (  s3.statevalues(:,idx ).*tmp_sc2.U3.LiverVolume.segments' , 2) ;
plot( s1.time./60, tmp2 , 'color' , col3, 'LineWidth', 2 ) ;
hold on

tmp2 = sum (  Kstress_exmpales.Allsim15.statevalues(:,idx ).*tmp7.U3.LiverVolume.segments' , 2) ;
plot( s1.time./60, tmp2 , 'color' , col4 , 'LineWidth', 2 ) ;
hold on

tmp2 = sum (  s2.statevalues(:,idx ).*tmp7.U3.LiverVolume.segments' , 2) ;
plot( s1.time./60, tmp2 , 'color' , col2 , 'LineWidth', 2) ;
hold on

plot([20 20], [-100,100], 'k--','linewidth', 0.5)

xlabel('Time (min) ');
ylabel('Total Gd-EOB-DTPA (mmol)');
set(gca,'FontSize',gca_size ,'FontWeight','bold');
xlim([0 60]); xticks([ 0 60]);
ylim([ 0 2.5e-4]);

box 'off'



%%% Extracting data for last two figures
tmp1 = tmp7.U2;

Ch1_gd_U2_20 = s1.statevalues(60*20, ismember(s1.states, 'Ch_1'))*tmp1.LiverVolume.segments(1) ;  
Ch2_gd_U2_20 = s1.statevalues(60*20, ismember(s1.states, 'Ch_2'))*tmp1.LiverVolume.segments(2) ;  
Ch3_gd_U2_20 = s1.statevalues(60*20, ismember(s1.states, 'Ch_3'))*tmp1.LiverVolume.segments(3) ;  
Ch4_gd_U2_20 = s1.statevalues(60*20, ismember(s1.states, 'Ch_4'))*tmp1.LiverVolume.segments(4) ;  
Ch5_gd_U2_20 = s1.statevalues(60*20, ismember(s1.states, 'Ch_5'))*tmp1.LiverVolume.segments(5) ;  
Ch6_gd_U2_20 = s1.statevalues(60*20, ismember(s1.states, 'Ch_6'))*tmp1.LiverVolume.segments(6) ;  
Ch7_gd_U2_20 = s1.statevalues(60*20, ismember(s1.states, 'Ch_7'))*tmp1.LiverVolume.segments(7) ;  
Ch8_gd_U2_20 = s1.statevalues(60*20, ismember(s1.states, 'Ch_8'))*tmp1.LiverVolume.segments(8) ;  

sc_U2 = [ Ch1_gd_U2_20 Ch2_gd_U2_20  Ch3_gd_U2_20  Ch4_gd_U2_20  Ch5_gd_U2_20  Ch6_gd_U2_20 Ch7_gd_U2_20  Ch8_gd_U2_20 ];


%%%

tmp2 = tmp7.U3;

Ch1_gd_U3_20 = s2.statevalues(60*20, ismember(s1.states, 'Ch_1'))*tmp2.LiverVolume.segments(1) ;  
Ch2_gd_U3_20 = s2.statevalues(60*20, ismember(s1.states, 'Ch_2'))*tmp2.LiverVolume.segments(2) ;  
Ch3_gd_U3_20 = s2.statevalues(60*20, ismember(s1.states, 'Ch_3'))*tmp2.LiverVolume.segments(3) ;  
Ch4_gd_U3_20 = s2.statevalues(60*20, ismember(s1.states, 'Ch_4'))*tmp2.LiverVolume.segments(4) ;  
Ch5_gd_U3_20 = s2.statevalues(60*20, ismember(s1.states, 'Ch_5'))*tmp2.LiverVolume.segments(5) ;  
Ch6_gd_U3_20 = s2.statevalues(60*20, ismember(s1.states, 'Ch_6'))*tmp2.LiverVolume.segments(6) ;  
Ch7_gd_U3_20 = s2.statevalues(60*20, ismember(s1.states, 'Ch_7'))*tmp2.LiverVolume.segments(7) ;  
Ch8_gd_U3_20 = s2.statevalues(60*20, ismember(s1.states, 'Ch_8'))*tmp2.LiverVolume.segments(8) ;  

sc_U3 = [ Ch1_gd_U3_20 Ch2_gd_U3_20  Ch3_gd_U3_20  Ch4_gd_U3_20  Ch5_gd_U3_20  Ch6_gd_U3_20 Ch7_gd_U3_20  Ch8_gd_U3_20 ];

%%%

tmp2 = tmp_sc2.U3;

Ch1_gd_U3sc2_20 = s3.statevalues(60*20, ismember(s1.states, 'Ch_1'))*tmp2.LiverVolume.segments(1) ;  
Ch2_gd_U3sc2_20 = s3.statevalues(60*20, ismember(s1.states, 'Ch_2'))*tmp2.LiverVolume.segments(2) ;  
Ch3_gd_U3sc2_20 = s3.statevalues(60*20, ismember(s1.states, 'Ch_3'))*tmp2.LiverVolume.segments(3) ;  
Ch4_gd_U3sc2_20 = s3.statevalues(60*20, ismember(s1.states, 'Ch_4'))*tmp2.LiverVolume.segments(4) ;  
Ch5_gd_U3sc2_20 = s3.statevalues(60*20, ismember(s1.states, 'Ch_5'))*tmp2.LiverVolume.segments(5) ;  
Ch6_gd_U3sc2_20 = s3.statevalues(60*20, ismember(s1.states, 'Ch_6'))*tmp2.LiverVolume.segments(6) ;  
Ch7_gd_U3sc2_20 = s3.statevalues(60*20, ismember(s1.states, 'Ch_7'))*tmp2.LiverVolume.segments(7) ;  
Ch8_gd_U3sc2_20 = s3.statevalues(60*20, ismember(s1.states, 'Ch_8'))*tmp2.LiverVolume.segments(8) ;  

sc_U3sc3 = [ Ch1_gd_U3sc2_20 Ch2_gd_U3sc2_20  Ch3_gd_U3sc2_20  Ch4_gd_U3sc2_20  Ch5_gd_U3sc2_20  Ch6_gd_U3sc2_20 Ch7_gd_U3sc2_20  Ch8_gd_U3sc2_20 ];

%%%

tmp1 = Kstress_exmpales.Allsim15;
tmp2 = tmp7.U3;

Ch1_gd_U3sc4_20 = tmp1.statevalues(60*20, ismember(s1.states, 'Ch_1'))*tmp2.LiverVolume.segments(1) ;  
Ch2_gd_U3sc4_20 = tmp1.statevalues(60*20, ismember(s1.states, 'Ch_2'))*tmp2.LiverVolume.segments(2) ;  
Ch3_gd_U3sc4_20 = tmp1.statevalues(60*20, ismember(s1.states, 'Ch_3'))*tmp2.LiverVolume.segments(3) ;  
Ch4_gd_U3sc4_20 = tmp1.statevalues(60*20, ismember(s1.states, 'Ch_4'))*tmp2.LiverVolume.segments(4) ;  
Ch5_gd_U3sc4_20 = tmp1.statevalues(60*20, ismember(s1.states, 'Ch_5'))*tmp2.LiverVolume.segments(5) ;  
Ch6_gd_U3sc4_20 = tmp1.statevalues(60*20, ismember(s1.states, 'Ch_6'))*tmp2.LiverVolume.segments(6) ;  
Ch7_gd_U3sc4_20 = tmp1.statevalues(60*20, ismember(s1.states, 'Ch_7'))*tmp2.LiverVolume.segments(7) ;  
Ch8_gd_U3sc4_20 = tmp1.statevalues(60*20, ismember(s1.states, 'Ch_8'))*tmp2.LiverVolume.segments(8) ;  

sc_U3sc4 = [ Ch1_gd_U3sc4_20 Ch2_gd_U3sc4_20  Ch3_gd_U3sc4_20  Ch4_gd_U3sc4_20  Ch5_gd_U3sc4_20  Ch6_gd_U3sc4_20 Ch7_gd_U3sc4_20  Ch8_gd_U3sc4_20 ];



nexttile;
sc_U2_total = sum (sc_U2);
sc_U3_total = sum (sc_U3);
sc_U3sc3_total = sum(sc_U3sc3);
sc_U3sc4_total = sum(sc_U3sc4);

b = bar([ [sc_U2_total  ]; [sc_U3_total  ] ; [sc_U3sc3_total  ] ; [ sc_U3sc4_total  ] ], 'FaceColor','flat');


%setting colors
%%% U2
b(1).CData(1,:) = col1;

%%% U3
b(1).CData(2,:) = col2;

%%% U3 sc1 
b(1).CData(3,:) =  col3;

 %%% U3 sc2 
b(1).CData(4,:) =  col4;

ylim([ 0 2.5e-4])

set(gca, 'fontsize',12)

box 'off'

ylabel('Total Gd-EOB-DTPA (mmol) at 20 min');
xticklabels({'Pre surgery','Post surgery' ,'Post surgery Sc 1' ,'Post surgery Sc 2'})
set(gca,'FontSize',gca_size ,'FontWeight','bold');


%%%

nexttile;

b = bar([ [ sc_U2 ]; [ sc_U3 ] ; [ sc_U3sc3 ] ; [  sc_U3sc4 ] ], 'FaceColor','flat');

%setting colors
%%% U2
b(1).CData(1,:) = col1;
b(2).CData(1,:) = col1;
b(3).CData(1,:) = col1;
b(4).CData(1,:) = col1;
b(5).CData(1,:) = col1;
b(6).CData(1,:) = col1;
b(7).CData(1,:) = col1;
b(8).CData(1,:) = col1;
%%% U3
b(1).CData(2,:) = col2;
b(2).CData(2,:) = col2;
b(3).CData(2,:) = col2;
b(4).CData(2,:) = col2;

%%% U3 sc1 
b(1).CData(3,:) =  col3;
b(2).CData(3,:) =  col3;
b(3).CData(3,:) =  col3;
b(4).CData(3,:) =  col3;

 %%% U3 sc2 
b(1).CData(4,:) =  col4;
b(2).CData(4,:) =  col4;
b(3).CData(4,:) =  col4;
b(4).CData(4,:) =  col4;

ylim([ 0 2.5e-4])

xticklabels('')

set(gca,'FontSize',gca_size ,'FontWeight','bold');
set(gcf,'color','w');
box 'off'

ylabel('Segmental Gd-EOB-DTPA (mmol) at 20 min');



