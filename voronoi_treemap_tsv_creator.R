#!/usr/bin/env Rscript
#### voronoi treemaps-tsv-creator.
# R version of voronoi treemaps-tsv-creator.

#require(devtools)
#install_github("praveenbas/myMiscFunc")
pkgTests <- function(package){
  if (!suppressWarnings(require(package,character.only = TRUE,quietly = TRUE)))
  {
    message(sprintf("Required package :::: %s :::: is not installed",package))
    message ("Type yes if you want to install [yes/no]:::: ")
    User_check= readLines(con=stdin(),1)
    
    if(User_check %in% c("y","Y","Yes","yes","YES")){
      #install.packages(package,dep=TRUE)
      
      if(!require("BiocInstaller",character.only = T)){
       # biocLite("BiocInstaller")
        source("https://bioconductor.org/biocLite.R")
        biocLite("BiocInstaller")
        biocLite(package)
      }else{
        biocLite(package)
      }
      # load and check the installed packages
      # incase of install from github, remove the where thing before and including "/"
      if(!require(gsub(pattern = ".*/",replacement = "",package),character.only = TRUE)) {
        stop("package not found")
      }
    }else{
      stop()
    }
  }
}


pkgTests(package = "optparse")
pkgTests(package = "plyr")
pkgTests(package = "progress")
#suppressPackageStartupMessages(require("optparse"))
#suppressPackageStartupMessages(require("plyr"))
#suppressPackageStartupMessages(require("progress"))

option_list <- list(
  make_option(c("-d","--datafile"),default = "klsjad",	
              help = "A tsv-file containing the genes and their values (expression/ratios/p-values)"),
  make_option(c("-t","--termfile"),default = "klsjad",
              help = "A tsv-file containing the terms and gene-lists"),
  make_option(c("-o","--outfile"),default = "klsjad",
              help="output file name"),
  make_option(c("-m","--columnname"),default="gene",
              help="column name to merge two files"))



#  help = "Remove upper outliers for better scaling [default \"%default\"]"))


parser <- OptionParser(usage = "Rscript voronoi_treemap_tsv_creator.R [options]", option_list=option_list,
                       description="\n\nThis is the R version of voronoi treemaps-tsv-creator - a java program (https://github.com/qbicsoftware/voronoi-treemaps-tsv-creator). 
It converts a table like derived from DAVID with columns like \"Term\", \"Genes\" 
and a table with the Gene/Protein names plus data column (Expression/Ratio/p-value, etc) 
into a tsv file that can be processed for Voronoi-Treemap creation. ")

arguments <- parse_args(parser,positional_arguments =TRUE)
options <- arguments$options

if(length(arguments$options) != 5) {
  cat("\n\n*******************************************************\nIncorrect number of required positional arguments \n*******************************************************\n\n")
  print_help(parser)
  stop()      
}



#### function to merge the two input file
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




#### execute it
voronoi_treemap_tsv_creator(termfile = options$termfile,datafile = options$datafile,outfile = options$outfile,columnmerge = options$columnname)