" add folding of tags, except for those that have no closing tag (must close 
" optional tags though, or the folding will be thrown off) 
syn region SynFold 
      \ start="<\%(param\)\@!\%(link\)\@!\%(isindex\)\@!\%(input\)\@!\%(hr\)\@!\%(frame\)\@!\%(col\)\@!\%(br\)\@!\%(basefont\)\@!\%(base\)\@!\%(area\)\@!\%(img\)\@!\%(meta\)\@!\z([a-z]\+\)\%(\_s[^>]*/\@![^>]\)*>" 
      \ end="</\z1>" 
      \ transparent fold keepend extend 
      \ containedin=ALLBUT,htmlComment 

