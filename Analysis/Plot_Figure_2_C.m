warning 'off'

run('../Data/generate_id.m')

run('../Data/generate_pat_color.m')

load('master_pat_pre_and_post.mat'); T = master_pat_pre_and_post;


U2 = T( ismember(table2array(T(:,2)),'U2' ), :   );
U3 = T( ismember(table2array(T(:,2)),'U3' ), :   );

f4 = figure() ; 
set(f4,'position',[0,0,500,500 ])
set( gcf,'color' , 'w')


p =  {  'pat1',...
        'pat6',...
        'pat7',...
        'pat8',...
        'pat12' }; % List of pat with pre and post


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

%% LSC 10
LSC_10 = ( table2array(U3(:,'LSC_10'))./table2array(U2(:,'LSC_10')))  ;  
s1 = scatter( 1, LSC_10 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;
hold on;

%% LSC 20
LSC_20 = (  table2array(U3(:,'LSC_20'))./table2array(U2(:,'LSC_20')))  ;  
s1 = scatter( 2, LSC_20 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;
hold on;

%% NLSC 10
NLSC_10 = (  table2array(U3(:,'NLSC_10'))./table2array(U2(:,'NLSC_10')))    ;  
s1 = scatter( 3, NLSC_10 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;
hold on;

%% LSC 20
NLSC_20 = ( table2array(U3(:,'NLSC_20'))./table2array(U2(:,'NLSC_20')))    ;  
s1 = scatter( 4, NLSC_20 ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;
hold on;

%% LMC
LMC = (   table2array(U3(:,'LMC'))./table2array(U2(:,'LMC')))    ;  
s1 = scatter( 5, LMC ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;

hold on;

%% RE
RE = ( table2array(U3(:,'RE'))./table2array(U2(:,'RE')))  ;  
s1 = scatter( 6, RE ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;

hold on;
%% HUI- CT
HUI_CT = ( table2array(U3(:,'HUI_CT'))./table2array(U2(:,'HUI_CT')))   ;  
s1 = scatter( 7, HUI_CT ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;

hold on;
%% HUI- MiaLab
HUI_MiaLab = (   table2array(U3(:,'HUI_MiaLab'))./table2array(U2(:,'HUI_MiaLab')))   ;  
s1 = scatter( 8, HUI_MiaLab ,80,'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',col ,...
    'LineWidth',2  ,'HandleVisibility','off' ) ;

hold on;
end

plot(0:10,ones(1,11),'k-')

ylabel({'Relative change pre- and post', 'SI liver function measure'})
xlim([0 9]);
xticks(1:8);
xtickangle(90);
xticklabels({'LSC_1_0_m_i_n', 'LSC_2_0_m_i_n',  'NLSC_1_0_m_i_n',  'NLSC_2_0_m_i_n',  'LMC',   'RLE',  'HUI_C_T',   'HUI_M_i_a_L_a_b'    }    )
set(gca,'fontsize', 14 , 'fontweight', 'bold')

