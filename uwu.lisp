(ql:quickload :croatoan)
(require :croatoan)

;;; ******************************************************************************
;;; * DEFINITION OF THE VARIABLES                                                *
;;; ******************************************************************************

;;; Here we define the global variables. Each of the variables which keep track of your
;;; pet's state range from 0 to 100. Because we like the metric system. Obviously.
;;; Some variable states you need to be as close to 0 as you can, and some you want
;;; to be as close to 100 as you can.

;;; So, for instance, 100 represents a fully negative affect on your pet's state,
;;; whereas for happiness and entertainment, 100 is a /good/ thing, and you want that!

;;; This one below ranges from 0 to 100. When you reach 100, the emoticon makes the UWU face!!
;;; It counts up or down, but when it reaches zero, the pet is fully upset, and at maximum
;;; displeasure, and is the opposite of happy with you.

(setf *happiness* 100)

;;; This variable is the amount of hunger that the pet is experiencing.
;;; When the value reaches 100, the pet is absolutely famished. When it reaches this value,
;;; the happiness of your pet starts to decrease.

(setf *hunger* 0)

;;; This is the variable that increases when you play with your pet.
;;; When you do interesting things with your pet, it increases this value, and when it
;;; reaches 100, it's fully tweakin' out happy, man!! This will positively affect
;;; your pet's happiness! The happiness variable will start to count upwards!

(setf *entertainment* 100)

;;; These two variables pass values into different parts of the machinery of the game's logic.
;;; *keypress* passes the value of the key you press, that gets picked up by the library
;;; we call that scans the keyboard input.
;;;
;;; *screen-contents*, however, passes the output that the game logic prepares to a function
;;; which then draws the contents of that variable to the screen :-) 

(defparameter *keypress* nil)
(defparameter *frame-counter* 0)
(defparameter *movement* 0)
(defparameter *rng-move* 0)


#|

************
* GRAPHICS *
************

|#

(defun clear-emacs-buffer ()
  (swank:eval-in-emacs
   '(progn
         (run-at-time 0 nil 'slime-repl-clear-buffer)
         nil)))

(setf uwu-gfx
      (list
       "( u w u )"
       "(u w u )"
       "( u w u)"
       "(> u w u)>"
       "<(u w u <)"
       ))


(setf uwu-mouth-gfx
      (list
       "( . o . )"
       "( . - . )"
       ))

#|

(・・。)ゞ
 	Σ(； ･`д･´)


|#



;;; ******************************************************************************
;;; *                             GAME LOGICK                                    *
;;; ******************************************************************************

;;; A lot of the data structure that I have constructed here for the operation
;;; of the game is derived from what I understand the Atari 2600 to require. This
;;; is because it's the only game programming I have ever done. I think what this
;;; means is that this game is not really following proper functional programming.

;;; We will be mutating quite a bit of state, but not a /lot/ of state, because I
;;; tend to only need very small amounts of RAM in order to program - the least
;;; number of state mutated works best for Atari 2600, for very good reason.


;;; <><><><><><><><><><><>
;;;       MAIN LOOP
;;; <><><><><><><><><><><>

;;; The main game loop!
;;; Here it is below:

(defun main-loop ()

  (uwu-init)
   
  (loop
     (read-keys)
     (game-logic *keypress*)
     ))

#|

<><><><><><><><><><><><>
  INITIALISE THE GAME
<><><><><><><><><><><><>

|#

(defun uwu-init ()

  ;; Initialise the hunger variable  

  (schedule-timer (make-timer (lambda () (increase-hunger)))
		  5 :repeat-interval 5)





  (schedule-timer (make-timer (lambda ()

				(clear-emacs-buffer)
				(draw-screen *hunger* *entertainment*)))
		  1 :repeat-interval 1)

  
  

  )


;;; I imagine this little loop will whizz along very quickly, so that pressing
;;; a key will trigger game events seamlessly. All animation will occur by causing
;;; the *screen-contents* variable to be updated a lot slower than the very fast
;;; pace at which the computer is executing all of the code for the game logic.

;;; As you can see, we first read from the keyboard, which sets the *keypress*
;;; variable, which is then an argument for the main game logic function.
;;; This, function, 'game-logic' will also be composed of modules, much like the
;;; way the main loop has three.

;;; Then, out of game-logic is set *screen-contents*, which is an argument for
;;; 'draw-screen', which will draw whatever is inside that variable.

;;; Then the loop starts all over again! 

;;; <><><><><><><><><><><><><>
;;;    READING USER INPUT
;;; <><><><><><><><><><><><><>

(defun read-keys ()
  (croatoan:with-screen (scr :input-echoing nil
			     :input-buffering nil
			     :input-blocking 100
			     :cursor-visible nil
			     :enable-colors nil
			     )
    
    (croatoan:event-case (scr event)

      (#\f
       (setf *keypress* 'feed)
       (return-from croatoan:event-case))

      (#\t
       (setf *keypress* 'toy)
       (return-from croatoan:event-case))
      
      ((nil)
       (setf *keypress* nil)
       (return-from croatoan:event-case))

      (otherwise
       (setf *keypress* nil)
       (return-from croatoan:event-case))

      )))

#|

This function reads the user input from they keyboard, and stores it in a global
variable, for the next function in the main game loop to take and then set the game
state properly.

The first line of this function stores the output of the function call 'read-event'
in the package/library that we load in order to make this game work.
The output that we store is an /object structure/ that is defined inside the package.

The second line extracts a single /attribute/ from this object, the symbol for the
character that you have presed - say, #\t if you press 't'.

We're going to pass this escaped symbol to the game logic function, in order to tell
it that we have selected some key, so we can navigate menus or interact with the pet!

I am worried, however. I think that this function will not continue execution if no
key press is made. So below is a whole bunch of testing of functions to see if I
can create one which will continue execution without a newline character.

|#
  
#|
<><><><><><><>
  GAME LOGIC
<><><><><><><>
|#

(defun game-logic (key-input)
  (cond ((equal 'feed key-input) (feed))
	((equal 'toy key-input) (setf *enterainment* (+ *entertainment* 10)))
		))

(defun increase-hunger ()
  (setf *hunger* (+ *hunger* 10))
  )

(defun feed ()
  (setf *hunger* 0)
  )

#|
<><><><><><><><><><><>
  DRAWING THE SCREEN
<><><><><><><><><><><>
|#

(defun draw-screen (hunger entertainment)

 
  (croatoan:with-screen (scr :input-echoing nil
			     :input-buffering nil
			     :input-blocking 100
			     :cursor-visible nil
			     :enable-colors nil
			     )
    (setf *rng-move* (random 5))
    (cond ((and (= 3 *rng-move*) (> *movement* 0)) (decf *movement*))
	  ((and (= 4 *rng-move*) (< *movement* 9)) (incf *movement*)))
    (format t
	    (apply #'concatenate 'string
		   (list
		    (subseq "         " *movement*)
		    (nth *rng-move* uwu-gfx))) #\return)
    (print *hunger*)
    (print *movement*)
    ))

#|

(fifth a)
(format nil "The value is: ~a" "foo")
(list "a" "b")
(print (list "a" "ab"))
(format t (car (list "a" "ab")))

CL-USER 5 > (defun foo ()
              (format t "hello")
              (format t "world")
              (values))
FOO

CL-USER 6 > (foo)
helloworld   ; <- printed by two FORMAT statements
             ; <- no return value -> nothing printed by the REPL


(apply #'concatenate 'string (list "a" "b" "c"))

|#
  

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

