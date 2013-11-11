(require 'key-chord)

(key-chord-define-global "jj" 'ace-jump-word-mode)
(key-chord-define-global "jl" 'ace-jump-line-mode)
(key-chord-define-global "jk" 'ace-jump-char-mode)
(key-chord-define-global "JJ" 'switch-to-prev-buffer)
(key-chord-define-global "KK" 'switch-to-next-buffer)
(key-chord-define-global "uu" 'undo-tree-visualize)

(key-chord-mode +1)

(provide 'key_chord_setup)
