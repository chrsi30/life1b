function [cost] = CostFunction_8C_resection(theta,modelName, Dx,Mdata , doScale)
if size(theta,1) > 1
    theta = theta';
end

%% simulation 1 - Pre surgery
[theta1, scale ] = setupParam8C(theta, Dx.U2 , Mdata);

theta1 = [ theta1 1];
[simLiver ,  simSpleen , ~  ]  = wholeBodySimLiverConc_8C( theta1, Dx.U2.time' , modelName, scale, doScale);   
%%
tmp  = Dx.U2.liver.segment;
tmp2 = Dx.U2.spleen;

c1 = nansum( ( (( simLiver.sim_segment_c1(:) - tmp(:,1)).^2 )./(tmp(:,1)*0.1).^2).*1);
c2 = nansum( ( (( simLiver.sim_segment_c2(:) - tmp(:,2)).^2 )./(tmp(:,2)*0.1).^2).*1);
c3 = nansum( ( (( simLiver.sim_segment_c3(:) - tmp(:,3)).^2 )./(tmp(:,3)*0.1).^2).*1);
c4 = nansum( ( (( simLiver.sim_segment_c4(:) - tmp(:,4)).^2 )./(tmp(:,4)*0.1).^2).*1);
c5 = nansum( ( (( simLiver.sim_segment_c5(:) - tmp(:,5)).^2 )./(tmp(:,5)*0.1).^2).*1);
c6 = nansum( ( (( simLiver.sim_segment_c6(:)-  tmp(:,6)).^2 )./(tmp(:,6)*0.1).^2).*1);
c7 = nansum( ( (( simLiver.sim_segment_c7(:) - tmp(:,7)).^2 )./(tmp(:,7)*0.1).^2).*1);
c8 = nansum( ( (( simLiver.sim_segment_c8(:) - tmp(:,8)).^2 )./(tmp(:,8)*0.1).^2).*1);

tmp3 = [ c1 c2 c3 c4 c5 c6 c7 c8 ];
c1 = sum(tmp3(isfinite(tmp3))) ; % cost from fit to liver data

c2 = nansum( (( simSpleen' - tmp2.mean).^2 )./(tmp2.SEM.^2) ); % cost from fit to liver data data

cost1 = c1  + c2;

%% simulation 2 - Pre surgery
[theta2, scale ] = setupParam8C(theta, Dx.U3 , Mdata);

theta2 = [ theta2 1];
theta2( ismember( SBparameters(modelName), 'x_stress')) = 0; % stress factor

[simLiver ,  simSpleen , ~  ]  = wholeBodySimLiverConc_8C( theta2, Dx.U3.time' , modelName, scale, doScale);   
%%
tmp  = Dx.U3.liver.segment;
tmp2 = Dx.U3.spleen;

c1 = nansum( ( (( simLiver.sim_segment_c1(:) - tmp(:,1)).^2 )./(tmp(:,1)*0.1).^2).*1);
c2 = nansum( ( (( simLiver.sim_segment_c2(:) - tmp(:,2)).^2 )./(tmp(:,2)*0.1).^2).*1);
c3 = nansum( ( (( simLiver.sim_segment_c3(:) - tmp(:,3)).^2 )./(tmp(:,3)*0.1).^2).*1);
c4 = nansum( ( (( simLiver.sim_segment_c4(:) - tmp(:,4)).^2 )./(tmp(:,4)*0.1).^2).*1);
c5 = nansum( ( (( simLiver.sim_segment_c5(:) - tmp(:,5)).^2 )./(tmp(:,5)*0.1).^2).*1);
c6 = nansum( ( (( simLiver.sim_segment_c6(:)-  tmp(:,6)).^2 )./(tmp(:,6)*0.1).^2).*1);
c7 = nansum( ( (( simLiver.sim_segment_c7(:) - tmp(:,7)).^2 )./(tmp(:,7)*0.1).^2).*1);
c8 = nansum( ( (( simLiver.sim_segment_c8(:) - tmp(:,8)).^2 )./(tmp(:,8)*0.1).^2).*1);


tmp3 = [ c1 c2 c3 c4 c5 c6 c7 c8 ];
c3 = sum(tmp3(isfinite(tmp3))) ; % cost from fit to liver data

c4 = nansum( (( simSpleen' - tmp2.mean).^2 )./(tmp2.SEM.^2) ); % cost from fit to liver data data

cost2 = c3  + c4;

%%

cost = cost1 + cost2;


end

