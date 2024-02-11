function [cost] = CostFunction_8C(theta,modelName, Dx, Mdata, doScale)
if size(theta,1) > 1
    theta = theta';
end

%% simulation
[theta, scale ] = setupParam8C(theta, Dx , Mdata);

try 
[simLiver ,  simSpleen , ~  ]  = wholeBodySimLiverConc_8C( theta, Dx.time' , modelName, scale, doScale);        
%% cost
tmp  = Dx.liver.segment;
tmp2 = Dx.spleen;

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
%%
cost = c1  + c2;
catch
    cost = 1e99;
    
end


end

