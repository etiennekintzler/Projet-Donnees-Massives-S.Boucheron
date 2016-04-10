#supression des objets dans l'environnement global
rm(list=ls())

plyr::laply(.data=c("ggplot2","tm","topicmodels","filehash", "SnowballC","slam","textreuse"),
                     .fun=require,
                     character.only=TRUE,
                     quietly=TRUE,
                     warn.conflicts=FALSE)


#Repertoire dans lequel se trouve le dossier avec les mails
setwd("~/R/projet_boucheron/")
enronpath <- paste(getwd(),"sub",sep="/") # dir of enron data

##########################MinHashing###########################################

minhash    <- minhash_generator(n = 240, seed=NULL)
corpus     <- TextReuseCorpus(dir = enronpath, minhash_func = minhash,skip_short = TRUE)

## Nombre de bands est divise par nombre de minhash
buckets <- lsh(corpus, bands = 80, progress = FALSE)
candidates <- lsh_candidates(buckets)

lsh_compare(candidates, corpus, jaccard_similarity, progress = FALSE)

############################LDA################################################

enron    <- VCorpus(DirSource(enronpath, encoding= "UTF-8"), 
                    readerControl=list(language= "en"))    

#Création de la matrice des fréquences
d <- DocumentTermMatrix(enron,control=list(
  tolower                         = T,
  removePunctuation         = T,
  removeNumbers                 = T,
  stopwords                         = c(stopwords("english")),
  stemming                         = F,
  wordLengths                 = c(3,20),
  weighting                         = weightTf
))


d$dimnames$Terms[sample(x=length(d$dimnames$Terms),1000)]

#d = removeSparseTerms(d,0.9999) #inutile pour les petits corpus

#Préparation de la matrice pour la fonction LDA

dtm       <- d[rowSums(as.matrix(d))>0,]
#ou bien
dtm2      <- d[as.matrix(rollup(d, 2, na.rm=T, FUN = sum))>0,]
lda.model <- LDA(dtm, 4)

#Affichage des 40 premiers mot pour les k=4 topics différents retenus
terms(lda.model,40)

############################FIN################################################

#Analyse des posteriors pour LDA

# Beware: this step takes a lot of patience!  My computer was chugging along for probably 10 or so minutes before it completed the LDA here.
lda.model = LDA(dtm, k)

# This enables you to examine the words that make up each topic that was calculated.  Bear in mind that I've chosen to stem all words possible in this corpus, so some of the words output will look a little weird.
terms(lda.model,20)

# Here I construct a dataframe that scores each document according to how closely its content 
# matches up with each topic.  The closer the score is to 0, the more likely its content matches
# up with a particular topic. 

emails.topics = posterior(lda.model, dtm)$topics
df.emails.topics = as.data.frame(emails.topics)
df.emails.topics = cbind(email=as.character(rownames(df.emails.topics)), 
                         df.emails.topics, stringsAsFactors=F)

