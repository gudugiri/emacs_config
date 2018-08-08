;;; python_setup.py --- python specific code -*- lexical-bindings: true -*-
;;; Commentary:
;;; Code:

(require 'flycheck)
(require 'python)
(require 'async)
(require 'kpi_utils)

(use-package company-jedi)
(use-package virtualenvwrapper)

(require 'virtualenvwrapper)


(defun sjoin (strings)
  "join strings with whitespace, skip nil"
  (string-join (cl-remove-if 'null strings) " "))


; Python checker
(add-hook 'python-mode-hook
          (lambda ()
            (flycheck-select-checker 'python-flake8)
            (flycheck-mode)))

(defvar py-test-name "")
(defvar py-chdir nil)
(defvar py-is-running-test nil)


(defun py-build-test-command ()
  (let* ((chdir (cond (py-chdir (sjoin (list "cd" py-chdir "&&")))))
         (cmd (sjoin (list chdir py-test-command py-test-params py-test-name))))
    cmd))

(defun run-py-test ()
  "Execute test and print result."
  (cond
   ((equal py-is-running-test t) (message "there is test in progress"))
   ((not (boundp 'py-project-root)) (message "there is no py-project-root"))
   ((not (boundp 'py-test-command)) (message "there is no py-test-command"))
   ((not (boundp 'py-test-params)) (message "there is no py-test-params"))
   ((not (string> py-test-name "")) (message "please select test first"))
   (t (let ((cmd (py-build-test-command)))
        (message "command: %s\n" cmd)
        (setq py-is-running-test t)
        (async-start
         `(lambda ()
            ,(async-inject-variables "cmd")
            (shell-command-to-string cmd))
         (lambda (result)
           (setq py-is-running-test nil)
           (message "ret is: %s" result)))))))


(defun get-path-pytest ()
  "In pytest format: path/to/file.py::function_name ."
  (let* ((curr_defun (python-info-current-defun))
         (curr_test (cond (curr_defun (replace-regexp-in-string "\\." "::" curr_defun))))
         (curr_base (cadr (split-string (buffer-file-name) py-project-root)))
         (test_path (cond
                     (curr_test
                      (concat curr_base "::" curr_test))
                     (t
                      (buffer-file-name)))))
    (message "Test path: %s" test_path)
    test_path))

(defun get-path-django-runner ()
  "In django format: path_to_module.with_dots.ClassName.test_name ."
  (let* ((curr_test (python-info-current-defun))
         (curr_file (replace-regexp-in-string ".py$" "" (buffer-file-name)))
         (curr_base (cadr (split-string curr_file py-project-root)))
         (with_dots (replace-regexp-in-string "/" "." curr_base))
         (test_path (concat with_dots "." curr_test)))
    test_path))

(defun get-py-test-path ()
  "Get test path, respect test runner syntax."
  (cond ((and (boundp 'py-test-runner)
              (equal py-test-runner 'pytest))
         (get-path-pytest))
        (t
         (get-path-django-runner))))

(defun assign-py-test ()
  "Assign test."
  (cond ((boundp 'py-project-root)
         (let ((test-path (get-py-test-path)))
           ; (message "!!TEST PATH: %s" test-path)
           (setq py-test-name test-path)))
        (t (message "Please set py-project-root"))))


(defun py-test-interactive (arg)
  "Set and run python test.  ARG - if need to set test."
  (interactive "P")
  (pcase arg
    ('(4) (assign-py-test)))
  (run-py-test))

(cl-defun py-test-setup-default (dir &key chdir (py-test-params ""))
  "Setup default values. Use it (py-test-setup-default (file-truename \".\")) ."
  (defvar py-test-runner 'pytest)
  (defvar py-test-command (concat dir "/venv/bin/py.test -n0"))
  (defvar py-test-params py-test-params)
  (defvar py-project-root (concat dir "/"))
  (setq py-chdir chdir))


(defun py/pprint-region (start end)
  (interactive "r")
  (shell-command-on-region start end
                           "python -c 'import sys; from pprint import pprint as pp; pp(eval(sys.stdin.read()))'"
                           '(4) '(4))
  (indent-for-tab-command))

(defun py/pprint ()
  (interactive)
  (set-mark-command nil)
  (forward-list)
  (py/pprint-region (region-beginning) (region-end)))


(defun py/verbose-toogle ()
  (interactive)
  (cond
   ((boundp 'py-test-params)
    (pcase py-test-params
      ("-vv" (setq py-test-params ""))
      ("" "-vv" (setq py-test-params "-vv"))))))


(defun py/get-ipython ()
  (file-truename (concat (projectile-project-root) "venv/bin/ipython")))

(cl-defun py/set-ipython (&optional (ipython-path "ipython"))
  (setq python-shell-interpreter ipython-path)
  (setq python-shell-interpreter-args "--simple-prompt -i"))

(defun py/setup-interpreter ()
  (cond
   ((and (projectile-project-p)
         (file-exists-p (py/get-ipython)))
    (py/set-ipython (py/get-ipython)))

   ((string= python-shell-interpreter "python")
    (py/set-ipython))))

(add-hook 'python-mode-hook
          #'(lambda ()
              ; (setq python-shell-interpreter "ipython")
              (define-key python-mode-map (kbd "C-o") 'py-test-interactive)
              (define-key python-mode-map (kbd "C-c .") 'goto-last-change)
              (py/setup-interpreter)
              ;(define-key python-mode-map (kbd "DEL") 'py-electric-backspace)
              ;(define-key python-mode-map (kbd "TAB") 'py-indent-line)
              ))


;;; this is pretty common case, should already be in some library



(defun not_pythonpath (s)
  (not (string-prefix-p "PYTHONPATH" s)))

(cl-defun pop-pythonpath (cmd &key (drop-pypath t))
  (print (format "Drop pypath: %s" drop-pypath))
  (cond
   (drop-pypath
    (let ((result nil)
          (old-env process-environment)
          (tmp-env (setq process-environment (seq-filter 'not_pythonpath process-environment))))
      (make-local-variable 'process-environment)
      (setq process-environment tmp-env)
      (print process-environment)
      (setq result (eval cmd))
      (setq process-environment old-env)
      result))
   (t (eval cmd))))


(cl-defun py/call-bin (command input-buffer output-buffer error-buffer &key (call-args '()) (drop-pypath t))
  "Call command on input-buffer

Send INPUT-BUFFER content to the process stdin.  Saving the
output to OUTPUT-BUFFER.  Saving process stderr to ERROR-BUFFER.
Return command process the exit code."
  (with-current-buffer input-buffer
    (let ((process (pop-pythonpath '(make-process :name "py/call-bin"
                                                  :command `(,command ,@call-args)
                                                  :buffer output-buffer
                                                  :stderr error-buffer
                                                  :noquery t
                                                  :sentinel (lambda (process event)))
                                   :drop-pypath drop-pypath)))

      (set-process-query-on-exit-flag (get-buffer-process error-buffer) nil)
      (set-process-sentinel (get-buffer-process error-buffer) (lambda (process event)))
      (save-restriction
        (widen)
        (process-send-region process (point-min) (point-max)))
      (process-send-eof process)
      (accept-process-output process nil nil t)
      (while (process-live-p process)
        (accept-process-output process nil nil t))
      (process-exit-status process))))

(cl-defun py/process-buffer (command &key (display 't) (call-args '("-")))
  "Show output, if COMMAND exit abnormally and DISPLAY is t."
  (interactive (list t))
  (let* ((original-buffer (current-buffer))
         (original-point (point))
         (original-window-pos (window-start))
         (tmpbuf (get-buffer-create (format "*py/process/%s*" command)))
         (errbuf (get-buffer-create (format "*py/process-error/%s*" command))))
    ;; This buffer can be left after previous black invocation.  It
    ;; can contain error message of the previous run.
    (dolist (buf (list tmpbuf errbuf))
      (with-current-buffer buf
        (erase-buffer)))
    (condition-case err
        (if (not (zerop (py/call-bin command original-buffer tmpbuf errbuf :call-args call-args)))
            (error "Black failed, see %s buffer for details" (buffer-name errbuf))
          (unless (eq (compare-buffer-substrings tmpbuf nil nil original-buffer nil nil) 0)
            (with-current-buffer tmpbuf
              (copy-to-buffer original-buffer (point-min) (point-max))))
          (mapc 'kill-buffer (list tmpbuf errbuf))
          (goto-char original-point)
          (set-window-start (selected-window) original-window-pos))
      (error (message "%s" (error-message-string err))
             (when display
               (pop-to-buffer errbuf))))))


(defun py/codestyle ()
  (interactive)
  (when (string-equal "python-mode" major-mode)
    (py/process-buffer "isort")
    (py/process-buffer "black")))

(provide 'python_setup)

;;; python_setup.el ends here
