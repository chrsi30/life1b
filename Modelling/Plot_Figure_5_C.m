

format long
format compact

set(0, 'DefaultFigureRenderer', 'painters');

run('../DATA/generate_pat_color.m')

load('struct_extended_resection_pred.mat');
load('struct_major_resection_pred.mat');
load('struct_minor_resection_pred.mat');
load('../DATA/meta_data.mat'); % importing data


%% Figure 2 - Bilirubin

f = figure();
set(gcf,'color','w')

set(f, 'outerposition',[0 0 500 500], 'PaperType','a4')

hold on
variable = 'Bilirubin';
%%% Extended 
%%% Pat 1
y1 = meta_data.('pat1').Preop_plasma.(variable);
y2 = struct_extended_resection_pred.pat1.U2(1,:);
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat1 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat1').Postop_plasma.(variable);
y4 = struct_extended_resection_pred.pat1.U3(1,:);
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat1 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat1)


%%% Pat 2
y1 = meta_data.('pat2').Preop_plasma.(variable);
y2 = struct_extended_resection_pred.pat2.U2(1,:);
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat2 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat2').Postop_plasma.(variable);
y4 = struct_extended_resection_pred.pat2.U3(1,:);
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat2 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat2)


%%% Pat 6
y1 = meta_data.('pat6').Preop_plasma.(variable);
y2 = struct_major_resection_pred.pat6.U2(1,:);
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat6 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat6').Postop_plasma.(variable);
y4 = struct_major_resection_pred.pat6.U3(1,:);
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat6 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat6)

%%% Pat 7
y1 = meta_data.('pat7').Preop_plasma.(variable);
y2 = struct_major_resection_pred.pat7.U2(1,:);
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat7 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat7').Postop_plasma.(variable);
y4 = struct_major_resection_pred.pat7.U3(1,:);
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat7 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat7)

%%% Pat 4
y1 = meta_data.('pat4').Preop_plasma.(variable);
y2 = log ( struct_major_resection_pred.pat4.U2(1,:) );
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat4 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat4').Postop_plasma.(variable);
y4 = log ( struct_major_resection_pred.pat4.U3(1,:) );
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat4 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat4)


%%% Pat 12
y1 = meta_data.('pat12').Preop_plasma.(variable);
y2 = struct_minor_resection_pred.pat12.U2(1,:);
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat12 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat12').Postop_plasma.(variable);
y4 = struct_minor_resection_pred.pat12.U3(1,:);
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat12 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat12)

%%% Pat 8
y1 = meta_data.('pat8').Preop_plasma.(variable);
y2 = struct_minor_resection_pred.pat8.U2(1,:);
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat8 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat8').Postop_plasma.(variable);
y4 = struct_minor_resection_pred.pat8.U3(1,:);
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat8 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat8)

%%% Pat 9
y1 = meta_data.('pat9').Preop_plasma.(variable);
y2 = log( struct_minor_resection_pred.pat9.U2(1,:) );
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat9 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat9').Postop_plasma.(variable);
y4 = log( struct_minor_resection_pred.pat9.U3(1,:) );
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat9 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat9)

%%% Pat 10
y1 = meta_data.('pat10').Preop_plasma.(variable);
y2 = log( struct_minor_resection_pred.pat10.U2(1,:) );
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat10 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat10').Postop_plasma.(variable);
y4 = log( struct_minor_resection_pred.pat10.U3(1,:));
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat10 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat10)

%%% Pat 11
y1 = meta_data.('pat11').Preop_plasma.(variable);
y2 = log(struct_minor_resection_pred.pat11.U2(1,:));
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat11 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat11').Postop_plasma.(variable);
y4 = log(struct_minor_resection_pred.pat11.U3(1,:));
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat11 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat11)

%%% Pat 15
y1 = meta_data.('pat15').Preop_plasma.(variable);
y2 = log(struct_minor_resection_pred.pat15.U2(1,:));
scatter(y1,y2 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat15 , 'LineWidth',2  ) ;
hold on

y3 = meta_data.('pat15').Postop_plasma.(variable);
y4 = log(struct_minor_resection_pred.pat15.U3(1,:));
scatter(y3,y4 ,80,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',patcol.pat15 , 'LineWidth',2  ) ;
hold on

plot([y1 y3 ], [ y2, y4] , 'Color', patcol.pat15)

set(gca,'fontsize',14,'fontweight','bold')
ylabel('k_i (s^-^1)')
xlabel('Bilirubin')

