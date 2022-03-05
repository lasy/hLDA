
import sys
import tomotopy as tp
import numpy as np

def fit_hLDA(input_file, depth = 4, gamma = 0.1, alpha = 0.1, eta = 0.1, min_df = 0, rm_top = 0, print_all = False, print_summary = False):

    cps = tp.utils.Corpus(tokenizer=tp.utils.SimpleTokenizer(stemmer=None))
    cps.process(open(input_file, encoding='utf-8'))

    '''
    np.random.seed(42)
    ridcs = np.random.permutation(len(cps))
    test_idcs = ridcs[:20]
    train_idcs = ridcs[20:]

    test_cps = cps[test_idcs]
    train_cps = cps[train_idcs]
    '''

    mdl = tp.HLDAModel(tw=tp.TermWeight.ONE, min_df=min_df, depth=depth, rm_top=rm_top, corpus=cps, gamma = gamma, alpha = alpha, eta = eta)
    mdl.train(0)
    if print_summary: print('Num docs:', len(mdl.docs), ', Vocab size:', len(mdl.used_vocabs), ', Num words:', mdl.num_words)
    if print_summary: print('Removed top words:', mdl.removed_top_words)
    if print_summary: print('Training...')
    for _ in range(0, 1000, 10):
        mdl.train(7)
        mdl.train(3, freeze_topics=True)
        if print_all: print('Iteration: {:05}\tll per word: {:.5f}\tNum. of topics: {}'.format(mdl.global_step, mdl.ll_per_word, mdl.live_k))

    for _ in range(0, 100, 10):
        mdl.train(10, freeze_topics=True)
        if print_all: print('Iteration: {:05}\tll per word: {:.5f}\tNum. of topics: {}'.format(mdl.global_step, mdl.ll_per_word, mdl.live_k))

    
    if print_summary: mdl.summary()
    return mdl
   
