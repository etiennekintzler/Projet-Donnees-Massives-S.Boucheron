library("textreuse")
library("dplyr")
dir <- system.file("extdata/ats/", package = "textreuse")
corpus <- TextReuseCorpus(dir = dir,minhash_func = minhash,skip_short = TRUE)
names(corpus)
doc <- corpus[["lifeofrevrichard00baxt"]]
tokens(doc)[200:210]

# Generer les fonctions minhash
minhash <- minhash_generator(n = 240, seed = 3552)


### A verifier pour la forme de corpus de tm 


#dir <- "~/Desktop/projet_bigdata_P7/data_test"
#corpus <- TextReuseCorpus(dir = dir,minhash_func = minhash,skip_short = TRUE)
#dir <- system.file("extdata/ats", package = "textreuse")
#corpus <- TextReuseCorpus(dir = dir, tokenizer = tokenize_ngrams, n = 5,
#                         minhash_func = minhash, keep_tokens = TRUE,
#progress = FALSE)



# Calculer le seuil de JAccard par le nombre de minhash et largeur de bande 
lsh_threshold(h = 200, b = 50)

#the probability of marking the documents as a candidate pair 
#lsh_probability(h = 20, b = 10, s = 0.2)



#jaccard_similarity(corpus[["remember00palm"]],corpus[["remembermeorholy00palm"]])




####CONSTRUIRE LES BUCKETS 
## Nombre de bands est divise par nombre de minhash
buckets <- lsh(corpus, bands = 80, progress = FALSE)




#lsh_query: returns matches for only one document, specified by its ID
baxter_matches <- lsh_query(buckets, "calltounconv00baxt")
baxter_matches
#returns all potential pairs of matches.
candidates <- lsh_candidates(buckets)
candidates

#lsh_compare() to apply a similarity function to the candidate pairs of documents
lsh_compare(candidates, corpus, jaccard_similarity, progress = FALSE)

