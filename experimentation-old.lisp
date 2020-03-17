(loop while (not terminal-keypress:read-event)
   (setq keypress (terminal-keypress:read-event))
   (princ keypress)
(when (eq nil (terminal-keypress::keypress-character keypress) (return 'key-not-pressed))
  ))

(defun keypress-test ()
(setq keypress nil)
(loop
   (setq keypress (terminal-keypress:read-event))
   ))
)

(let ((keypress (terminal-keypress:read-event)))
(loop))

(defun keypress-test2 ()
(loop 
   (sleep 0.2)
   (print 'no-keypress)
   (when (eq (read-char-no-hang) (not nil)) (return 'keypress))
   )
)
   
(defun keypress-test3 ()
(loop until (eq (read-char-no-hang *terminal-io*) (not nil)) do
   (print 'no-keypress)
     )
(print 'keypress)
)

(defun keypress-test4 ()
(loop until (eq (terminal-keypress:read-event) (not nil)) do
   (print 'no-keypress)
     )
(print 'keypress)
)

(defun keypress-test5 ()
(loop while (eq (terminal-keypress:read-event) nil) do
   (print 'no-keypress)
     )
(print 'keypress)
)

(defun keypress-test6 ()
(when (eq (terminal-keypress:read-event) nil) (print 'no-keypress)
      ))

(defun keypress-test7 ()
  (loop
     (when (eq (read-char-no-hang) (not nil)) (print 'keypress))
     )
  )

(defun keypress-test45 ()
(loop
   (print 'no-keypress)
   (when (eq (terminal-keypress:read-event) (not nil) ) (print 'keypress) ))

)

(defun keypress8 ()
  (read-char-no-hang)
  (read-char-no-hang)
  (read-char-no-hang)
  (read-char-no-hang)
  (princ 'no-key-press)
  )
