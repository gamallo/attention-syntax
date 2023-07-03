# Attention Heads and Syntactic Dependencies

## Requirements

* Perl, Python3 and Bash interpreters
* Python libraries: `pytorch_pretrained_bert` and `transformers`

## How to use

* Compare a syntactic analysis stored in `./dep/gold` against the highest values of attention heads:

```
sh syntax.sh
```

* The highest values of attention heads per layer given a sentence is computed with the following script:

```
sh attention.sh "a nena que xoga no parque é alta"
```

