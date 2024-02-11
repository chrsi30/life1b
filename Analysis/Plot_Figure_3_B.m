clear all
close all
clc


%load('master.mat');
%id =  master.Properties.VariableNames(3:end);

warning 'off'

run('../Data/generate_id.m')
run('../Data/generate_pat_color.m')


load('master_prm_pre_post.mat'); T = master_prm_pre_post;


U2 = T( ismember(table2array(T(:,2)),'U2' ), :   );
U3 = T( ismember(table2array(T(:,2)),'U3' ), :   );



%% MIALAB - Change Pre. vs. Post - 
f6 = figure() ; 
set(f6,'position',[0,0,500,500 ])

p =  {  'pat1',...
        'pat6',...
        'pat7',...
        'pat8',...
        'pat12' }; % List of pat with pre and post

col = [ 1 1 1];
plot(0:10, ones(1,11),'k-')
hold on


for kk = 1:size(p,2)

A = T(ismember(table2array(T(:,1)),p{kk} ), :  );

U2 = A( ismember(table2array(A(:,2)),'U2' ), :   );
U3 = A( ismember(table2array(A(:,2)),'U3' ), :   );


      if kk == 1
        col = patcol.pat1; % Pat 1
    elseif kk == 2
        col = patcol.pat6;  % Pat 6 
    elseif kk == 3
        col = patcol.pat7; % Pat 7
    elseif kk == 4
        col = patcol.pat8;  % Pat 8
    elseif kk == 5
        col =patcol.pat12;  % Pat 12
    else
        col = [1 1 1];
    end

%% S1
prm1 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S1')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S1'))))  ;  %  ones(1,5)' -   

s1 = scatter( 1, prm1 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;

%% S2
prm2 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S2')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S2'))))  ;  %  ones(1,5)' -   
s2 = scatter( 2, prm2 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;
%% S3
prm3 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S3')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S3'))))  ;  %  ones(1,5)' -   
s3 = scatter( 3, prm3 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;
%% S4
prm4 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S4')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S4'))))  ;  %  ones(1,5)' -   
s4 = scatter( 4, prm4 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;
%% S5
prm5 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S5')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S5'))))  ;  %  ones(1,5)' -   
s5 = scatter( 5, prm5 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;
%% S6
prm6 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S6')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S6'))))  ;  %  ones(1,5)' -   
s6 = scatter( 6, prm6 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;
%% S7
prm7 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S7')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S7'))))  ;  %  ones(1,5)' -   
s7 = scatter( 7, prm7 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;
%% S8
prm8 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S8')))./ exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S8'))) )  ;  %  ones(1,5)' -   
s8 = scatter( 8, prm8 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;

end

ylabel('k_i (Post) / k_i (Pre)')
%xlim([- 9]);
xticks(1:8);
xtickangle(90);
xticklabels({'S1', 'S2',  'S3',  'S4',  'S5',   'S6',  'S7',   'S8'    }    )
set(gca,'fontsize', 14 , 'fontweight', 'bold')
set(gcf, 'color' , 'w')

%saveas(f6, sprintf('./Figures/%s.pdf', 'change_8C_prm_pre_and_post_pat_wise_MiaLab'  ) )
%saveas(f6, sprintf('./Figures/%s.fig', 'change_8C_prm_pre_and_post_pat_wise_MiaLab'  ) )
%saveas(f6, sprintf('./Figures/%s.png', 'change_8C_prm_pre_and_post_pat_wise_MiaLab'  ) )

%% Calculating mean and SD 

for kk = 1:size(p,2)

A = T(ismember(table2array(T(:,1)),p{kk} ), :  );

U2 = A( ismember(table2array(A(:,2)),'U2' ), :   );
U3 = A( ismember(table2array(A(:,2)),'U3' ), :   );

% S1
prm1 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S1')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S1'))))  ;  %  ones(1,5)' -   

% S2
prm2 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S2')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S2'))))  ;  %  ones(1,5)' -   

% S3
prm3 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S3')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S3'))))  ;  %  ones(1,5)' -   

% S4
prm4 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S4')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S4'))))  ;  %  ones(1,5)' -   

% S5
prm5 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S5')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S5'))))  ;  %  ones(1,5)' -   

% S6
prm6 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S6')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S6'))))  ;  %  ones(1,5)' -   

% S7
prm7 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S7')))./exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S7'))))  ;  %  ones(1,5)' -   

% S8
prm8 = ( exp(table2array(U3(:,'forsgren_NoBack_8C_MiaLab_S8')))./ exp(table2array(U2(:,'forsgren_NoBack_8C_MiaLab_S8'))) )  ;  %  ones(1,5)' -   

tmp = (1 - [prm1 prm2 prm3 prm4 prm5 prm6 prm7 prm8])*100;
tmp(isnan(tmp)) = [];

prm.(p{kk}).mean = mean(tmp) ;
prm.(p{kk}).SD   = std(tmp) ;

end


