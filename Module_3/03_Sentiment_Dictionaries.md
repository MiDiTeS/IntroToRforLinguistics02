# Sentiment analysis and LSF
## Replication of Lima-Lopes (2020) - Part 3

Rodrigo Esteves de Lima Lopes\
*Campinas State University*\
[rll307@unicamp.br](mailto:rll307@unicamp.br)

# Introduction

This script will discuss how to prepare our dictionaries and count the sentiments. My analysis replicates Lima-Lopes (2020) and is based on SFL (Systemic-Functional Linguistics) approach [(Halliday and Mathissen, 2013)](https://www.taylorfrancis.com/books/mono/10.4324/9780203431269/halliday-introduction-functional-grammar-halliday-christian-matthiessen), mostly specifically the Appraisal System [(Martin and White, 2005)](https://www.palgrave.com/gp/book/9781403904096). 

Our objectives here are twofold:

1. Prepare the dictionaries 
2. Process the counting and normalisation

In both cases, we are using [Quanteda](https://quanteda.io) as our main package. 

# Packages 


```r
library(quanteda)
library(dplyr)
```

Each package has a function:

- `quanteda`: text analysis (counting the features)
- `dplyr`: data manipulation

# Dictionaries 
Dictionaries are formal classes which associate keys (some classificatory values) with elements in a list. The idea of a dictionary is to identify `character/strings` with a pre-defined category, in order to tell us how any of each class is present in a corpus. It is important to notice that a corpus might have one or more texts in its structure. 

There are a number of possibilities, packages and methods, in `R` to work with dictionaries. In this tutorial, we are going to use `quanteda` for its easiness of use and because it brings tools for other analysis as we will discuss latter. 

## Creating the dictionaries

Our first step is to create a number of vectors with each categories we would need to analyse in the corpus. 


```r
adj.1 <-  c("squat", "filthy", "dirty", "behaviour", "very", "unrestricted", "awful", "black", "hungry", "old", "dangerous", "fake", "legitimate", "bad", "bogus", "hard", "racist", "temporary", "high", "proper english",  "proper ticket", "english", "properly", "significant", "top", "white citizen", "high hate", "high increase", "high since", "high on record", "genuine", "poor", "destitute", "frustrate", "poor level english", "european squatter", "poor foreigner", "contamination", "hovel", "smuggler", "smuggle", "big", "older", "higher", "proper tickets", "english properly", "white citizens", "highest since", "highest on record", "frustrated", "poor levels of english", "european squatters", "poor foreigners", "hovels", "smuggled", "biggest", "english proper",'increase', 'white', 'citizen', 'ticket','foreigner') |> 
  unique()

adj.2 <- c("unskilled migrant", "low-skilled", "skilled-worker", "jobless",  "qualification", "sharp mind", "skilled migration", "qualify", "honest", "workforce", "academic", "bright", "clean", "damage", "exceptional",  "extraordinary", "lower", "unemployed", "highly-skilled", "sharp", "unskilled worker", "unskille migrant", "low-skill", "skill-work", "job", "skill migration", "unemploy", "highly-skill", "unskill worker", "exception", "sharp", "mind", "skilled","migration", "skill","unskill","worker", "work","low","ordinary workers","workers","ordinary","welfare") |> 
  unique()

adj.3 <-  c("legal", "illegal", "unlawful", "unlawfully", "asylum seekers", "refugee", "genuine refugees", "commonwealth", "unauthorized", "temporary migrants", "unauthorized", "genuine", "legal", "illegal", "unlawful", "unlawfully", "asylum seeker", "refugee", "genuine refugee", "commonwealth", "unauthorise", "temporary migrant", "migrant", "migrants", "unauthorize", "unauthorize") |> 
  unique()

MC.1 <- c("spain", "from outside eu", "ethnic minorities", "portugal", "non-eea countries", "from europe", "from eastern europe", "from poorer eu countries", "beyond", "europe", "romania", "bulgaria", "afghanistan", "bulgarian", "syrian", "vietnamese", "mexican", "iranian", "iran", "foreigner", "foreign", "nigerian", "african", "indian", "iraqi", "turkish", "kurdish", "muslim", "asian", "eu migrants", "europeans", "european workers", "euro-immigrants", "european-based migration", "europe's immigration", "eastern european", "eastern europe", "east europeans", "mediterranean", "east", "cultural", "greek", "international", "overseas", "american", "global", "native", "polish", "white immigrants", "britons", "native counterparts", "local", "australian", "national", "former", "jamaican", "economic refugees", "economic migrants", "eu citizens", "indian national", "goa", "nigeria", "eastern european workers", "migrant workers", "spain", "outside eu", "ethnic minority", "portugal", "non-eea country", "europe", "eastern europe", "from poor eu country", "europe", "from romania and bulgaria", "afghanistan", "bulgarian", "syrian", "vietnamese", "mexican", "iranian", "iran", "foreigner", "foreign", "nigerian", "african", "indian", "iraqus", "turkish", "kurdish", "muslim", "asian", "eu migrant", "european", "european worker", "euro-immigrant", "european-base", "europe 's immigration", "eastern european", "eastern europe", "east european", "mediterranean", "east", "cultural", "greek", "international", "overseas", "american", "global", "native", "polish", "white immigrant", "briton", "native counterpart", "local", "australian", "national", "former", "jamaican", "economic", "refugee", "economic migrant", "eu citizen", "indian national", "goa", "nigeria", "eastern european", "worker", "migrant worker", 'eu',"abroad",'eurozone')  |> unique() 

MC.2 <-  c("home secretary", "theresa may", "mrs. may", "cabinet source", "mr johnson", "chairman", "mr farage", "nigel farage", "boris johnson", "trump", "spokesperson", "Migrationwatch", "Official statisticians", "statistics", "study", "she", "labour leader", "australian", "latest figures", "latest migration", "latest research", "latest census", "honest", "surest", "spokeswoman", "spokesman", "economists", "economist", "mayor", "added", "say", "prime minister", "president", "home secretary", "theresa may", "mr. may", "cabinet source", "mr johnson", "chairman", "mr farage", "nigel farage", "boris johnson", "trump", "spokesperson", "Migrationwatch", "Official statistician", "statistics", "study", "she", "labour leader", "australian", "latest figure", "latest migration", "latest research", "latest census", "honest", "sure", "spokeswoman", "spokesman", "economist", "economist", "mayor", "add", "say", "prime minister", "president", "may", "johnson", "minister", "secretary", "secretary", "farage", "nigel", "boris")  |> 
  unique()

MC.3 <- c("particularly", "very", "dramatic", "passionately", "directly", "quickly", "completely", "certainly", "controversi", "nearly", "actu", "illeg", "below", "longer", "work abroad", "politic", "immediately respond", "immediately", "clearly", "absurd", "bigger", "disastrous", "diverse", "easy", "harder", "awkward", "easier", "effective", "greater", "impossible", "minimum", "negative", "embarrassing", "medical", "radical", "rude", "attractive", "stronger", "tougher", "uncontrolled", "weak", "large", "proper policy", "proper border controls", "proper controls", "highest", "few britons", "high migrant demand", "high levels", "less", "total", "mass", "imigration", "mass migration", "official", "huge", "right", "strongest", "clearest", "easiest", "estimated", "lowest", "surest", "trickiest", "unrestricted", "hopeful", "housing", "arriving", "massive", "particular", "very", "dramatic", "passionate", "direct", "quick", "complete", "certain", "controverse", "near", "actu", "illeg", "below", "long", "work abroad", "politic", "immediate respond", "immediate", "clear", "absurd", "big", "disastrous", "diverse", "easy", "hard", "awkward", "easy", "effective", "great", "impossible", "minimum", "negative", "embarrass", "medical", "radical", "rude", "attractive", "strong", "tough", "uncontrol", "weak", "large", "proper policy", "proper border control", "proper control", "high", "few briton", "high migrant demand", "high level", "less", "total", "mass", "imigration", "mass migration", "official", "huge", "right", "strong", "clear", "easy", "estimate", "low", "sure", "tricky", "unrestricted", "hopeful", "house", "arrive", "massive") |> 
  unique() 

vp <- c("show", "stop illegal immigrants", "stop migrants", "says", "say", "said", "squat", "stow", "stowaway", "coming", "born", "work", "go", "think", "left", "allow", "warn", "warned", "live", "trying", "stagnate", "dwindle", "trafficking", "traffick", "collapse", "flee", "cost", "added", "stop", "migrants", "show", "stop illegal immigrant", "stop migrant", "say", "say", "say", "squat", "stow", "stowaway", "coming", "born", "work", "go", "think", "left", "allow", "warn", "warn", "live", "try", "stagnate", "dwindle", "traffic", "traffick", "collapse", "flee", "cost", "add", "stop", "migrant") |> 
  unique()


EM <- c("should", "would", "must", "need", "will", "can", "can't", "shouldn't", "might","may","must", "have to","could","ought to")


NP.1 <- c("poorer EU countries", "poorer member states", "poorer EU member", "European economies", "eurozone", "euro", "economy", "Economic", "welfare", "housing", "Euro", "recession", "single market", "dwindle", "cost", "poor EU country", "poor member state", "poor EU member", "European economy", "eurozone", "euro", "economy", "Economic", "welfare", "house", "Euro", "recession", "single market", "dwindle", "cost", "poor", "EU", "country", "states", "member", "European", "Europe")  |> 
  unique()

NP.2 <- c("control", "borders", "border", "wave", "waves", "surge", "increase", "uncontrolled", "immediately blocked", "minimum", "mass migration", "unrestricted", "weak", "student visa", "student visas", "proper border controls", "proper controls", "highest", "high migrant demand", "high levels", "visa system", "mass", "visa", "demand", "level", "levels", "control", "border", "border", "wave", "wave", "surge", "increase", "uncontrol", "immediately block", "minimum", "mass migration", "unrestricted", "weak", "student visa", "student visa", "proper border control", "proper control", "high", "high migrant demand", "high level", "visa system", "mass", "visa", "demand", "level") |> 
  unique()
```

Now we create a list with our vectors


```r
dic.list <- list(adj.1, adj.2, adj.3, MC.1, MC.2, MC.3, vp, EM, NP.1, NP.2)
```

Then we name such a list

```r
names(dic.list) <- c("adj.1", "adj.2", "adj.3", "MC.1", "MC.2", "MC.3", "vp", "EM", "NP.1", "NP.2")
```

Finally, we create the dictionary

```r
dic.brexit <- dictionary(dic.list)
```

## Creating the corpus

Before we apply the dictionary, we will create a corpus like we did in **02_Sentiment_pre_processing_network**. However, we will not lemmatise the corpus. 


```r
# one by one
TS.Corpus <- corpus(TS.df, text_field = 'Content')
DS.Corpus <- corpus(DS.df, text_field = 'Content')
TT.Corpus <- corpus(TT.df, text_field = 'Content')

#General
News.df <- rbind(TT.df,TS.df, DS.df)
News.Corpus <- corpus(News.df, text_field = 'Content')

#tokens
TS.tokens  <- tokens(TS.Corpus,
                     what = "word",
                     remove_punct = TRUE,
                     remove_symbols = TRUE,
                     remove_numbers = TRUE,
                     remove_url = TRUE,
                     split_hyphens = FALSE,
                     include_docvars = TRUE,
                     padding = FALSE,
                     verbose = quanteda_options("verbose")
)

DS.tokens <- tokens(DS.Corpus,
                    what = "word",
                    remove_punct = TRUE,
                    remove_symbols = TRUE,
                    remove_numbers = TRUE,
                    remove_url = TRUE,
                    split_hyphens = FALSE,
                    include_docvars = TRUE,
                    padding = FALSE,
                    verbose = quanteda_options("verbose")
)
TT.tokens <- tokens(TT.Corpus,
                    what = "word",
                    remove_punct = TRUE,
                    remove_symbols = TRUE,
                    remove_numbers = TRUE,
                    remove_url = TRUE,
                    split_hyphens = FALSE,
                    include_docvars = TRUE,
                    padding = FALSE,
                    verbose = quanteda_options("verbose")
) 
News.tokens <- News.Corpus |>
  tokens(what = "word",
         remove_punct = TRUE,
         remove_symbols = TRUE,
         remove_numbers = TRUE,
         remove_url = TRUE,
         split_hyphens = FALSE,
         include_docvars = TRUE,
         padding = FALSE,
         verbose = quanteda_options("verbose")
  )
```

## Counting the occurences

Now let us do the actual counting

```r
News.counting <- dfm(News.tokens, dictionary = dic.brexit)
DS.counting <- dfm(DS.tokens, dictionary = dic.brexit)
TS.counting <- dfm(TS.tokens, dictionary = dic.brexit)
TT.counting <- dfm(TT.tokens, dictionary = dic.brexit)
```

Saving as data frame for latter use

```r
DS.counting <- convert(DS.counting, to = "data.frame")
TS.counting <- convert(TS.counting, to = "data.frame")
TT.counting <- convert(TT.counting, to = "data.frame")
News.counting <- convert(News.counting, to = "data.frame")
```


### Normalising and preparing the analysis

Now we are going to add a total column and use the name of the documents to name de rows

```r
News.counting$Total <- rowSums(News.counting[,2:10])
rownames(News.counting) <- News.counting$doc_id
```

Now we normalise and round the data


```r
News.Cal  <- News.counting |>
  mutate_at(
    vars(-matches(c("Total", "doc_id"))),
    ~ .x * 100 / Total) |>
  mutate_at(
    vars(-matches(c("Total", "doc_id"))),
    ~ round(.x, 2)
  )
```




























