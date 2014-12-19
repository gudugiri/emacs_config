(eval-after-load 'python-mode
(font-lock-add-keywords
 'python-mode
 '(("\\(lambda\\)" (0 (progn ()
                            (compose-region (match-beginning 1)
                                            (match-end 1)
                                            ?λ)))))))

(add-hook 'emacs-lisp-mode-hook 'pretty-lambdas)
(defun pretty-lambdas ()
  (font-lock-add-keywords
   nil `(("(?\\(lambda\\>\\)"
          (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                    ,(make-char 'greek-iso8859-7 107))
                    nil))))))

(provide 'vis_cust)
