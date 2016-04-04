#' ---
#' title: "Données massives: Enron Dataset"
#' author: "Do Kintzler"
#' date: " 01 Avril 2016"
#' output: pdf_document
#' ---

#' # Enron dataset
#' 
rm(list=ls())
require(tm)
setwd("~/R/projet_boucheron")

enronpath <- paste(getwd(),"maildir",sep="/") # dir of enron data

dir(enronpath) #list all folders of enronpath

ovid <- VCorpus(DirSource(txt, encoding = "UTF-8"), readerControl=list(language="lat"))

enron <- VCorpus(DirSource(enronpath, encoding= "UTF-8",recursive=T),
                 readerControl=list(language= "en"))    

enronp <- "~/R/projet_boucheron/maildir/allen-p/"
Venronp <- VCorpus(DirSource(enronp, encoding= "UTF-8",recursive=T),
                            readerControl=list(language= "en")) 
inspect(Venronp[1:10])

dmat <- DocumentTermMatrix(Venronp)

inspect(dmat[1300:1310,1:10])

dmat$dimnames$Terms[2000:3000]

lapply(inspect(Venronp[1:3]),as.character)
dmat$dimnames$Docs[1:10]


dmat$dimnames$Terms[sample(x=length(dmat$dimnames$Terms),100)]
