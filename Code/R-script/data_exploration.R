save_data_exploration_plot <- function(dataset) {
  
  pdf("DataExplorer/plot_intro.pdf") 
  plot_intro(dataset)
  dev.off() 
  
  pdf("DataExplorer/plot_bar.pdf") 
  plot_bar(dataset, nrow=1L, ncol=1L)
  dev.off() 
  
  pdf("DataExplorer/plot_histogram.pdf") 
  plot_histogram(dataset, nrow=3L, ncol=3L)
  dev.off() 
  
  pdf("DataExplorer/plot_qq.pdf") 
  plot_qq(dataset, sampled_rows = 26000L, nrow=2L, ncol=2L)
  dev.off() 
  
  pdf("DataExplorer/plot_qq_byname.pdf") 
  plot_qq(dataset, by = "result", sampled_rows = 26000L, nrow=2L, ncol=2L )
  dev.off() 
  
  pdf("DataExplorer/plot_correlation.pdf") 
  plot_correlation(na.omit(dataset), maxcat = 5L)
  dev.off() 
  
  pdf("DataExplorer/plot_correlation_discrete.pdf") 
  plot_correlation(na.omit(dataset), type="d")
  dev.off() 
  
  pdf("DataExplorer/plot_correlation_continuos.pdf") 
  plot_correlation(na.omit(dataset), type = "c")
  dev.off() 
  
  pca <- na.omit(dataset[, colnames(dataset)])
  
  #pdf("DataExplorer/plot_prcomp.pdf") 
  #plot_prcomp(pca, variance_cap = 1)
  #dev.off() 
  
  pdf("DataExplorer/plot_boxplot.pdf") 
  plot_boxplot(dataset, by = "result", nrow=2L, ncol=2L)
  dev.off() 
  
  pdf("DataExplorer/plot_scatterplot.pdf") 
  plot_scatterplot(dataset, by = "result", sampled_rows = 26000L, nrow=2L, ncol=2L)
  dev.off() 
}
