docs = []
from os import listdir, chdir, getcwd
import re, codecs, stop_words
import numpy as np
path_input = "/home/kintzler/R/projet_boucheron/maildir/"
path_output = "/home/kintzler/R/projet_boucheron/DATA/"

stopwords = stop_words.get_stop_words('en')
stopwords.extend("asap http www fyi hotmail email e-mail sent forwarded msn asked find send sent ect mail enron".split())
stopwords.extend(open("stopwords.txt","r").read().split())
stopwords = sorted(list(set(stopwords))) #supprime les doublons

# Here's my attempt at coming up with regular expressions to filter out
# parts of the enron emails that I deem as useless.
email_pat = re.compile(".+@.+")
to_pat = re.compile("To:.+\n")
cc_pat = re.compile("cc:.+\n")
subject_pat = re.compile("Subject:.+\n")
from_pat = re.compile("From:.+\n")
sent_pat = re.compile("Sent:.+\n")
received_pat = re.compile("Received:.+\n")
ctype_pat = re.compile("Content-Type:.+\n")
reply_pat = re.compile("Reply- Organization:.+\n")
date_pat = re.compile("Date:.+\n")
xmail_pat = re.compile("X-Mailer:.+\n")
mimver_pat = re.compile("MIME-Version:.+\n")
fwd_pat = re.compile("Forwarded:.+\n")


chdir(path_input)
names = [d for d in listdir(".") if "." not in d]
for name in names:
    print(name)
    chdir(path_input+"%s" % name) #"%s"=string
    subfolders = listdir('.')
    sent_dirs = [n for n, sf in enumerate(subfolders) if "sent" in sf] 
    sent_dirs_words = [subfolders[i] for i in sent_dirs]
    for d in sent_dirs_words:
        chdir(path_input+'%s/%s' % (name,d))
        file_list = listdir('.')
        docs.append([" ".join(codecs.open(f, 'r','latin-1').readlines()) for f in file_list if "." in f

docs_final = []
for subfolder in docs:
    for email in subfolder:
        if ".nsf" in email:
            etype = ".nsf"
        elif ".pst" in email:
            etype = ".pst"
        email_new = email[email.find(etype)+4:]
        
        email_new = to_pat.sub('', email_new)
        email_new = cc_pat.sub('', email_new)
        email_new = subject_pat.sub('', email_new)
        email_new = from_pat.sub('', email_new)
        email_new = sent_pat.sub('', email_new)
        email_new = email_pat.sub('', email_new)
        if "-----Original Message-----" in email_new:
            email_new = email_new.replace("-----Original Message-----","")
        email_new = ctype_pat.sub('', email_new)
        email_new = reply_pat.sub('', email_new)
        email_new = date_pat.sub('', email_new)
        email_new = xmail_pat.sub('', email_new)
        email_new = mimver_pat.sub('', email_new)
        email_new = fwd_pat.sub('', email_new)
        email_new = re.sub("[^a-zA-Z]", " ", email_new)
        email_new = ' '.join([word.lower() for word in email_new.split() if word.lower() not in stopwords])
        email_new = ' '.join([word for word in email_new.split() if len(word)>2 and len(word)<30])
        email_new = re.sub(' +',' ',email_new)
        docs_final.append(email_new)

# Here I proceed to dump each and every email into about 126 thousand separate 
# txt files in a newly created 'data' directory.  This gets it ready for entry into a Corpus using the tm (textmining)
# package from R.



for n, doc in enumerate(docs_final):
    if np.random.rand()<0.3:
        outfile = open(path_output+"%s.txt" % n ,'w')
        outfile.write(doc)
        outfile.write('\n')
        outfile.close
        
print("Fin du script")
