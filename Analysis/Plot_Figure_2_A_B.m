load('../DATA/meta_data.mat')
run('../DATA/generate_id.m')
run('../DATA/generate_pat_color.m')

%%
if isfile('spider_plot.m')
     % File exists. 
%%
color = [patcol.pat1    ;...
         patcol.pat2    ;...
         patcol.pat4    ;...
         patcol.pat6    ;...
         patcol.pat7    ;...
         patcol.pat8    ;...
         patcol.pat9    ;...
         patcol.pat10    ;...
         patcol.pat11    ;...
         patcol.pat12    ;...
         patcol.pat15    ;...
         patcol.pat16    ;...
         patcol.pat17    ;...
         ]; 


%% Example using Patient 1
f = figure();
set(f,'outerPosition', [ 0 0 750 750])
set(gcf,'color','w');

tmp = meta_data.pat1.Preop_plasma;
tmp2 = [tmp.GBT tmp.PDR tmp.R15 tmp.PK_INR tmp.Bilirubin tmp.Albumin];
labels = fieldnames(tmp) ;

tmp3 = meta_data.pat1.Postop_plasma;
tmp4 = [tmp3.GBT tmp3.PDR tmp3.R15 tmp3.PK_INR tmp3.Bilirubin tmp3.Albumin];

x = [tmp2 ; tmp4 ];

spider_plot(x ,...
    'AxesLabels', (labels'),...
    'AxesInterval', 5,...
    'FillOption', {'off'},...
    'AxesLimits', [ones(1,length(tmp2))*0; [15 30 20 1.8 110 45] ],...
    'AxesDisplay', 'data',...
    'AxesLabelsOffset', 0.1,...
    'AxesFontColor', [0, 0, 1],...
    'Color', [0   , 0   , 0    ;...
              0   , 0   , 0],...
    'LineWidth', 2,...
    'Marker', 'none',...
    'AxesFontSize', 12,...
    'LabelFontSize', 10,...
    'AxesColor', [0.8, 0.8, 0.8],...
    'AxesLabelsEdge', 'none');

saveas(f, sprintf('./%s.pdf', 'SP_pat1'  ) )
saveas(f, sprintf('./%s.fig', 'SP_pat1'  ) )
saveas(f, sprintf('./%s.png', 'SP_pat1'  ) )


%% Pre-OP
clear tmp; clear tmp2; clear tmp3;

f = figure();
set(gcf,'color','w');
set(f,'outerPosition', [ 0 0 750 750])

count = 0;
for i = 1:size(p,2)
    tmp = meta_data.(p{i}).Preop_plasma;
    tmp2 = [tmp.GBT tmp.PDR tmp.R15 tmp.PK_INR tmp.Bilirubin tmp.Albumin];

    if nansum(tmp2) > 0
        count = count + 1;
        tmp3(count,:) = tmp2;
        color_tmp(count,:) = patcol.(p{i});
    end

end

spider_plot(tmp3 ,...
    'AxesLabels', (labels'),...
    'AxesInterval', 5,...
    'FillOption', {'off'},...
    'AxesLimits', [ones(1,length(tmp2))*0; [15 30 20 1.8 110 45] ],...
    'AxesDisplay', 'none',...
    'AxesLabelsOffset', 0.1,...
    'AxesFontColor', [0, 0, 1],...
    'Color',color_tmp,...
    'LineWidth', 2,...
    'Marker', 'none',...
    'AxesFontSize', 12,...
    'LabelFontSize', 10,...
    'AxesColor', [0.8, 0.8, 0.8],...
    'AxesLabelsEdge', 'none');

saveas(f, sprintf('./%s.pdf', 'SP_preOP'  ) )
saveas(f, sprintf('./%s.fig', 'SP_preOP'  ) )
saveas(f, sprintf('./%s.png', 'SP_preOP'  ) )

%% Post-OP
clear tmp; clear tmp2; clear tmp3; clear color_tmp;

f = figure();
set(f,'outerPosition', [ 0 0 750 750])
set(gcf,'color','w');

count = 0;
for i = 1:size(p,2)
tmp = meta_data.(p{i}).Postop_plasma;
tmp2 = [tmp.GBT tmp.PDR tmp.R15 tmp.PK_INR tmp.Bilirubin tmp.Albumin];

    if nansum(tmp2) > 0
        count = count + 1;
        tmp3(count,:) = tmp2;
        color_tmp(count,:) = patcol.(p{i});
    end

end

spider_plot(tmp3 ,...
    'AxesLabels', (labels'),...
    'AxesInterval', 5,...
    'FillOption', {'off'},...
    'AxesLimits', [ones(1,length(tmp2))*0; [15 30 20 1.8 110 45] ],...
    'AxesDisplay', 'none',...
    'AxesLabelsOffset', 0.1,...
    'AxesFontColor', [0, 0, 1],...
    'Color',color,...
    'LineWidth', 2,...
    'Marker', 'none',...
    'AxesFontSize', 12,...
    'LabelFontSize', 10,...
    'AxesColor', [0.8, 0.8, 0.8],...
    'AxesLabelsEdge', 'none');


else
    disp('Please install spider_plot: https://se.mathworks.com/matlabcentral/fileexchange/59561-spider_plot')


end













