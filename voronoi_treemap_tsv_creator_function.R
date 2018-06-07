voronoi_treemap_tsv_creator<-function(termfile, datafile,outfile,columnmerge){
  terms<-read.table(termfile,header = T,sep = "\t")
  data<- read.table(datafile,header = T,sep = "\t")
  #head(data)
  
  termsNew<-ddply(terms,.(term),function(x){
    x<-df_defactorise(x,Msg = F)
    return(data.frame(term = x[,"term"],gene = gsub(pattern = " ",replacement = "",unlist(strsplit(x[,columnmerge],",")))))
  })
  
  colnames(data)[grep(pattern = columnmerge,colnames(data))]<-"gene"
  output<-merge(termsNew,data,by="gene")  
  colnames(output)[grep(pattern = "gene",colnames(output))]<-columnmerge
  
  write.table(x = output,file = outfile,quote = F,sep = "\t",row.names = F,col.names = T)
  message(sprintf("Output saved in :::: %s",outfile))
}
