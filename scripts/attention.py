import torch
import sys
import re
from pytorch_pretrained_bert import BertTokenizer, BertModel, BertForMaskedLM
from transformers import RobertaConfig, RobertaModel, RobertaTokenizer, BertTokenizer, BertModel, BertForMaskedLM, AutoTokenizer, AutoModel
#from sklearn.metrics.pairwise import cosine_similarity

import logging
#logging.basicConfig(level=logging.INFO)


# Load pre-trained model tokenizer (vocabulary)
#tokenizer = RobertaTokenizer.from_pretrained('roberta-base')
#tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
#tokenizer = AutoTokenizer.from_pretrained('neuralmind/bert-large-portuguese-cased')
tokenizer = AutoTokenizer.from_pretrained('marcosgg/bert-small-gl-cased', output_attentions =True)

# Load pre-trained model (weights)
#model = RobertaModel.from_pretrained('roberta-base', output_hidden_states=True)
#model = BertModel.from_pretrained('bert-base-uncased', output_hidden_states=True)
#model = AutoModel.from_pretrained('neuralmind/bert-large-portuguese-cased', output_hidden_states = True)
model = AutoModel.from_pretrained('marcosgg/bert-small-gl-cased', output_attentions = True)


sent1 = sys.argv[1]

marked_text = "[CLS] " + sent1 + " [SEP]"
tokenized_text = tokenizer.tokenize(marked_text)
indexed_tokens = tokenizer.convert_tokens_to_ids(tokenized_text)

segments_ids = [1] * len(tokenized_text)
torch.set_printoptions(threshold=10_000)
tokens_tensor = torch.tensor([indexed_tokens])
segments_tensors = torch.tensor([segments_ids])


# Predict hidden states features for each layer
with torch.no_grad():
  encoded_layers = model(tokens_tensor, segments_tensors)
print (encoded_layers)
