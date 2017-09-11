function makefdrplot()
clc;clear;
option.glycopep      = 1;
option.singlemode    = 1;
fetuinfdrdata        = fdr('fetuin_cidetd.csv',option);
asiolofdrfdrdata     = fdr('asialofetuin_cidetd.csv',option);

plotFDR(fetuinfdrdata.CID);
plotFDR(asiolofdrfdrdata.CID);
plotFDR(fetuinfdrdata.ETD);
plotFDR(asiolofdrfdrdata.ETD);
end

function plotFDR(fdrdata)
    figure
    plot(fdrdata(:,1),fdrdata(:,2)*100,'LineWidth',3);
    hold on;
    width=12;
    height=10;
    set(gcf,'Units','centimeters','Position',[0,0,width,height])
%    box off;
     set(gca,'TickDir','out')
     set(gca,'FontSize',20)
     set(gca,'FontName','Helvetica')
     
     xtick = [0.05:0.1:0.45];
     axis([0.05 0.45 0 50]);
     set(gca,'XTick',xtick)
  %    set(gca,'XTickLabel',[0.2:0.1:0.7])
end

