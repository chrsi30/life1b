


run('../Data/generate_id.m')
run('../Data/generate_pat_color.m')

volume_string = {'CT', 'MiaLab'};

e = {'U2','U3'};

load('p_ki_2C');




%%
%% MIALAB - Change Pre. vs. Post - 
f5 = figure() ; 
set(f5,'position',[0,0,500,500 ])
set( gcf,'color' , 'w')


p =  {  'pat1',...
        'pat6',...
        'pat7',...
        'pat8',...
        'pat12' }; % List of pat with pre and post


plot(0:6, ones(1,7),'k-') 
hold on

for kk = 1:size(p,2)
pat = p{kk};
prm1(kk,:) = ( exp( p_ki_2C.forsgren_NoBack_personalized.D_MeanSEM.no_scale.MiaLab.(pat).U3 )./exp(  p_ki_2C.forsgren_NoBack_personalized.D_MeanSEM.no_scale.MiaLab.(pat).U2  ))  ;  %  ones(1,5)' -
end

b = bar(prm1, 'FaceColor','flat');

b.CData(1,:) =  patcol.pat1;
b.CData(2,:) =  patcol.pat6;
b.CData(3,:) =  patcol.pat7;
b.CData(4,:) =  patcol.pat8;
b.CData(5,:) =  patcol.pat12;

ylabel('Relative change k_i (Post) / k_i (Pre)')
xlim([0 6]);
xticks(1:5);
xtickangle(90);
xticklabels({'pat1', 'pat6',  'pat7',  'pat8',  'pat12'  }    )
set(gca,'fontsize', 14 , 'fontweight', 'bold')



