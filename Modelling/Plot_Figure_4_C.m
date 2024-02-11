

format long
format compact

warning 'off'

set(0, 'DefaultFigureRenderer', 'painters');

modelName = 'forsgren_NoBack_8C_resection';

if contains(modelName, '8C' )
    model_dir = './Models/8C' ; 
else
    model_dir = './Models/2C' ; 
end

load('../Data/D_MeanSEM.mat'); % importing data
load('../Data/meta_data.mat'); % importing data

run('../Data/generate_pat_color.m')


init %% Setting up model

%%

p =  {  'pat1',...
        'pat6',...
        'pat7',...
        'pat8',...
        'pat12' }; % List of pat with pre and post

Volume_string = {'CT', 'MiaLab'};

count = 0;
for k = 1:size(Volume_string,2)
for i = 1:size(p,2)
count = count + 1;
pat = p{i}; %% Changed to pat 2
doScale     = 0; 
tmp2        = 'no_scale';
signaltype  = 'Conc';
type_folder = 'U2_U3';
exam        = 'U2';
Bound_string ='OrgBound';

LoadFolder = strcat('./Results/8C/',modelName,'/',signaltype,'/', tmp2, '/', Bound_string  ,'/',Volume_string{k} ,'/');
SaveFolder = strcat('./Figures/8C/',modelName,'/',signaltype,'/', tmp2, '/', Bound_string ,'/',Volume_string{k} ,'/');

tmp4 = strcat ( LoadFolder, type_folder, '/' , pat , '/', exam  );

if ~exist(tmp4,'dir')

    continue
else
    [p_dir,~] = FindBestParametersFile(tmp4, 0,'.mat'); 

    load(p_dir); theta = Results.xbest;

    Tmp  = D;
    Tmp.(pat).U2.LiverVolume = D.(pat).U2.LiverVolume.(Volume_string{k}) ;
    Tmp.(pat).U3.LiverVolume = D.(pat).U3.LiverVolume.(Volume_string{k}) ;

    eval(strcat('Mdata = meta_data.', pat,';') );

    P.(pat).(Volume_string{k}).kphx = theta(ismember(pNames,'kstress')) ;

end ; clear Tmp;
end
end

%% CT 
f2 = figure();
set(gcf,'color','w')
set(f2, 'outerposition',[0 0 500 500], 'PaperType','a4')

title('CT-based liver volumes');
hold on


p =  {  'pat1',...
        'pat6',...
        'pat7',...
        'pat8',...
        'pat12' }; % List of pat with pre and post

count = 0;
for i = 1:size(p,2)
    pat = p{i}; %% Changed to pat 2

    if isfield(P.(pat), 'CT')
        count = count +1;
        kphx1(count,:) = exp(P.(pat).('CT').kphx)*100; 
        kphx1_reduction.(pat) = (1 - exp(P.(pat).('CT').kphx))*100; 

    else
        continue

    end

end

b1 = bar(kphx1,'FaceColor','flat') ;
b1.CData(1,:) =  patcol.pat1;
b1.CData(2,:) =  patcol.pat7;
b1.CData(3,:) =  patcol.pat8;
hold on

ylabel('k_s_t_r_e_s_s - change in influx pre-and-post (%)')
xlim([0 4]);
xticks(1:3);
xtickangle(90);
xticklabels({'pat1',  'pat7',  'pat8', }    )
set(gca,'fontsize', 14 , 'fontweight', 'bold')

box 'off'



%% Mialab 

f3 = figure();
set(gcf,'color','w')
set(f3, 'outerposition',[0 0 500 500], 'PaperType','a4')

title('MiaLab-based liver volumes');
hold on

p =  {  'pat1',...
        'pat6',...
        'pat7',...
        'pat8',...
        'pat12' }; % List of pat with pre and post

count = 0;
for i = 1:size(p,2)
    pat = p{i}; %% Changed to pat 2

    if isfield(P.(pat), 'MiaLab')
        count = count +1;
        kphx2(count,:) = exp(P.(pat).('MiaLab').kphx)*100; 
        kphx2_reduction.(pat) = (1 - exp(P.(pat).('MiaLab').kphx))*100; 

    else
        continue

    end

end

b = bar(kphx2,'FaceColor','flat') ;
b.CData(1,:) =  patcol.pat1;
b.CData(2,:) =  patcol.pat6;
b.CData(3,:) =  patcol.pat7;
b.CData(4,:) =  patcol.pat8;
b.CData(5,:) =  patcol.pat12;
hold on

ylabel('k_s_t_r_e_s_s - change in influx pre-and-post (%)')
xlim([0 6]);
xticks(1:5);
xtickangle(90);
xticklabels({'pat1', 'pat6',  'pat7',  'pat8',  'pat12'  }    )
set(gca,'fontsize', 14 , 'fontweight', 'bold')

box 'off'

