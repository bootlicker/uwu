#|

(defun uwu-happy-animation ()
  (setq loopcounter 10)
  (loop
   (setq loopcounter (- loopcounter 1))
     (princ "uwu")
     (sleep 1)
     (clear-emacs-buffer)
     (princ " uwu")
     (sleep 1)
     (clear-emacs-buffer)
     (princ "  uwu")
     (sleep 1)
     (clear-emacs-buffer)
     (princ " uwu")
     (sleep 1)
     (clear-emacs-buffer)
     (when (< loopcounter 0) (return 'uwu))
     )
  )

(defun uwu-eat-animation ()
  (princ "(;-;)    *")
  (sleep 0.4)
  (clear-emacs-buffer)
  (princ "(;-;)   *")
  (sleep 0.4)
  (clear-emacs-buffer)
  (princ "(;-;)  *")
  (sleep 0.4)
  (clear-emacs-buffer)
  (princ "(;-;) *")
  (sleep 0.4)
  (clear-emacs-buffer)
  (princ "(;-;)*")
  (sleep 0.4)
  (clear-emacs-buffer)
  (setq loopeat 4)
  (loop
     (setq loopeat (- loopeat 1))
     (princ "(-v-)")
     (sleep 0.4)
     (clear-emacs-buffer)
     (princ "(-o-)")
     (sleep 0.4)
     (clear-emacs-buffer)
     (when (< loopeat 0) (return 'uwu))
     )
  )


|#
