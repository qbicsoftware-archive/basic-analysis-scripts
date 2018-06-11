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
  output<-output[,c(2,1,3:ncol(output))]
  if (ncol(output) == 3){ ### if only three colums are in the output, add a second column with NAs
    output$level1<-NA
    output<-output[,c(1,ncol(output),2,3:(ncol(output)-1))]
  }
  ### santiy check ## remove terms/pathways with
  first_col<-colnames(output)[1]
  terms_ngenes<-ddply(output,.variables = first_col,summarise,n=nrow(piece))
  terms_ngenes<-terms_ngenes[terms_ngenes$n >= 2,]
  
  
  ### check for duplicates.
  terms_ngenes_entry<-ddply(output,.variables = c(first_col,columnmerge),summarise,n= nrow(piece))

  
  output<-output[output[,1] %in% c(as.vector(terms_ngenes[,1]),as.vector(pathway_ngenes[,1])),]
  
  
  write.table(x = output,file = outfile,quote = F,sep = "\t",row.names = F,col.names = T)
  message(sprintf("Output saved in :::: %s",outfile))
}
