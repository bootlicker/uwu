;; load croatoan and swank
(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload '(:croatoan :swank)))

;; Defining a package is always a good idea
(defpackage #:uwu
  (:use #:cl)
  (:export #:main))

(in-package #:uwu)

;; The main screen, we need a global so that we can access it from
;; slime
(defparameter *scr* nil)

;; Main entry point, to be called from the terminal thread, it will
;; initialize the screen and enter the event loop
(defun main ()
  (croatoan:with-screen (scr
                         ;; Set input blocking to 100 ms. This _must_
                         ;; be set for swank to work, otherwise
                         ;; get-event will block and croatoan only
                         ;; polls the job queue when a key is pressed.
                         :input-blocking 100
                         ;; Do not override the swank debugger hook,
                         ;; as we want to enter the slime debugger in
                         ;; emacs when a error occurs.
                         :bind-debugger-hook nil
			 :enable-colors nil)
    ;; Set *scr* to the initilized scr so that we can access it form
    ;; the swank thread and then enter the event-loop.
    (croatoan:run-event-loop (setf *scr* scr))))

;; Initialize swank, setting dont-close will prevent the server from
;; shutting down in case slime disconnects. The default port is 4005,
;; one can specify a different one with :port.
(swank:create-server :dont-close t)

;; Initialize screen and enter the event loop
(main)
