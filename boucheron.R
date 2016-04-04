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