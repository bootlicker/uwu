(require 'terminal-keypress)

; Here we define the global variables. Each of the variables which keep track of your
; pet's state range from 0 to 100. Because we like the metric system. Obviously.
; Some variable states you need to be as close to 0 as you can, and some you want
; to be as close to 100 as you can.

; So, for instance, 100 represents a fully negative affect on your pet's state,
; whereas for happiness and entertainment, 100 is a /good/ thing, and you want that!

; This one below ranges from 0 to 100. When you reach 100, the emoticon makes the UWU face!!
; It counts up or down, but when it reaches zero, the pet is fully upset, and at maximum
; displeasure, and is the opposite of happy with you.

(setq *happiness* 100)

; This variable is the amount of hunger that the pet is experiencing.
; When the value reaches 100, the pet is absolutely famished. When it reaches this value,
; the happiness of your pet starts to decrease.

(setq *hunger* 0)

; This is the variable that increases when you play with your pet.
; When you do interesting things with your pet, it increases this value, and when it
; reaches 100, it's fully tweakin' out happy, man!! This will positively affect
; your pet's happiness! The happiness variable will start to count upwards!

(setq *entertainment* 100)

; These two variables pass values into different parts of the machinery of the game's logic.
; *keypress* passes the value of the key you press, that gets picked up by the library
; we call that scans the keyboard input.
;
; *screen-contents*, however, passes the output that the game logic prepares to a function
; which then draws the contents of that variable to the screen :-) 

(defparameter *keypress*)
(defparameter *screen-contents*)


; So the 


(defun main-loop ()
  (loop
     (read-keys)
     (game-logic *keypress*)
     (draw-screen *screen-contents*)
     )
  )

(defun read-keys ()
  (setq keyboard-output (terminal-keypress:read-event))
  (setq *keypress* (terminal-keypress::keypress-character keyboard-output))
  )



(defun increase-hunger ()
  (setq *hunger* (+ *hunger* 10))
  (print *hunger*)
  )

(defun feed ()
  (setq *hunger* 0)
  (uwu-eat-animation)
  )




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
