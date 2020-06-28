;;; Here we load the libraries that we need in order to make drawing
;;; the screen possible. This library I am using is a foreign function
;;; interface (FFI) to the UNIX ncurses terminal library. It enables
;;; us to have non-blocking input into the terminal, so that we can
;;; press whatever key we want, to interrupt the execution of the
;;; code. This provides for a more seamless experience.

(ql:quickload :croatoan)
(require :croatoan)

#|

************
* GRAPHICS *
************

|#

(setf uwu-gfx
      (list
       "( u w u )"
       "(u w u )"
       "( u w u)"
       "(> u w u)>"
       "<(u w u <)"
       ))

(setf owo-gfx
      (list
       "( o w o )"
       "(o w o )"
       "( o w o)"
       "(> o w o)>"
       "<(o w o <)"
       ))

(setf birb-face
      (list
       "( o v o )"
       "(o v o )"
       "( o v o)"
       "(> o v v)>"
       "<(o v o <)"
       ))

(setf uwu-mouth-gfx
      (list
       "( . o . )"
       "( . - . )"
       ))

(setf magic-friendship-gfx
      (list
       "(ﾉ◕ヮ◕)ﾉ*"
       "(/◕ヮ◕)/ :"
       "(-◕ヮ◕)-  ・"
       "(/◕ヮ◕)/   ﾟ"
       "(ﾉ◕ヮ◕)ﾉ    ✧"
       ))

(setf cool-dude-gfx
      (list
       "(⌐■_■¬)"
       "(■_■¬ )"
       "( ⌐■_■)"
       "(>⌐■_■)>"
       "<(■_■¬<)"
       ))

(setf cat-gfx
      (list
       "( *Φ ω Φ* )"
       "(*Φ ω Φ* )"
       "( *Φ ω Φ*)"
       "(∿*Φ ω Φ*)∿"
       "∿(*Φ ω Φ*∿)"
       ))

(setf horrified-gfx
      (list
       "( ﾟ Д ﾟ )"
       "(ﾟ Д ﾟ )"
       "( ﾟ Д ﾟ)"
       "(> ﾟ Д ﾟ)>"
       "<(ﾟ Д ﾟ <)"
       ))

(setf random-gfx
      (list
       "~( ° ○ ° )~"
       "(° ○ ° )"
       "( ° ○ °)"
       "(∿ °○°)∿"
       "∿(°○° ∿)"
       ))

(setf shocked-gfx
      (list
       "( ;◎ _ ◎；)"
       "(◎ _ ◎； )"
       "( ;◎ _ ◎)"
       "(~~ ;◎_◎)~~"
       "~~(◎_◎； ~~)"
       ))

(setf run-away-gfx
      (list
       "( ┳ _ ┳ )"
       "(┳━ _ ┳━)"
       "(━┳ _ ━┳)"
       "(_ ━┳ _ ━┳)_"
       "_(┳━ _ ┳━ _)"
       ))

(setf smart-gfx
      (list
       "( o _| o )"
       "(o/_o )"
       "( o_\o)"
       "(∋ o_\o)∋"
       "∈(o/_o ∈)"
       ))

;;; The following are kaomoji pet graphics that I still need to implement. u_u


#|

(・・。)ゞ
 	Σ(； ･`д･´)

(･_･)

(●´⌓`●)

(ᗒᗣᗕ)՞

(┳Д┳)

.·´¯`(>▂<)´¯`·.

( u_\u)
( ´◡‿\◡`)
(✿^‿^)

(｡•̀◡-)✧

(⊙▂⊙)

(✖╭╮✖)

（・∀・）

|#


;;; ******************************************************************************
;;; * DEFINITION OF THE VARIABLES                                                *
;;; ******************************************************************************

;;; Here we define the global variables. Each of the variables which
;;; keep track of your pet's state range from 0 to 100. Some variable
;;; states you need to be as close to 0 as you can, and some you want
;;; to be as close to 100 as you can.

;;; So, for instance, 100 hunger represents a fully negative affect on
;;; your pet's state, whereas for happiness and entertainment, 100 is
;;; a /good/ thing, and you want that!

;;; This one below ranges from 0 to 100. It counts up or down, but
;;; when it reaches zero, the pet is fully upset, and at maximum
;;; displeasure, and is the opposite of happy with you.

(defparameter *happiness* 75)

;;; This variable is the amount of hunger that the pet is
;;; experiencing.  When the value reaches 100, the pet is absolutely
;;; famished. When it reaches this value, the happiness of your pet
;;; starts to decrease.

(defparameter *hunger* 0)

;;; This is the variable that increases when you play with your pet.
;;; When you do interesting things with your pet, it increases this
;;; value, and when it reaches 100, it's fully tweakin' out happy,
;;; man!! This will positively affect your pet's happiness! The
;;; happiness variable will start to count upwards!

(defparameter *entertainment* 100)

;;; This global variable below keeps track of the state of the
;;; keyboard. When a key is pressed, the value is stored in to this
;;; variable.

(defparameter *keypress* nil)

;;; This variable below is the frame counter. It keeps track of which
;;; frame of pet animation we are in. There are, at the moment, 5
;;; different frames of animation, which are the pet facing: forwards,
;;; left, right, and looking left and right.

(defparameter *frame-counter* 0)

;;; This variable below keeps track of the previous position of the
;;; pet as it moves left and right, back and forwards across the
;;; screen.

(defparameter *movement* 0)

;;; This variable below stores the value of where the pet is going to
;;; move _next_. It is compared to the variable *movement* above, in
;;; order to work out which way the pet is facing as it
;;; moves. According to common sense, if someone was going to move
;;; left, they would, of course, start facing left, etc.

(defparameter *rng-move* 0)

;;; The code for this next variable, below, has not been implemented
;;; yet. It keeps track of whether your pet is in 'normal' mode, or
;;; one of the 'special' modes. Normal mode for your pet just has
;;; basic animations, but 'special' mode allows your pet to look
;;; 'cool', 'smart', or like a cat, etc.

(defparameter *state* 'normal)

;;; This variable keeps track of the list of animation frames that
;;; display what emotion and mode your pet is in, uwu.

(defparameter *pet-appearance* uwu-gfx)

;;; ******************************************************************************
;;; *                                   GAME LOGICK                              *
;;; ******************************************************************************

;;; A lot of the data structure that I have constructed here for the
;;; operation of the game is derived from what I understand the Atari
;;; 2600 to require. This is because it's the only game programming I
;;; have ever done. I think what this means is that this game is not
;;; really following proper functional programming.

;;; We will be mutating quite a bit of state, but not a /lot/ of
;;; state, because I tend to only need very small amounts of RAM in
;;; order to program - the least number of state mutated works best
;;; for Atari 2600, for very good reason.

;;; ****************************************************************

;;; This is a simple utility function that enables me to clear the
;;; screen so that a new frame of animation can be drawn.

(defun clear-emacs-buffer ()
  (swank:eval-in-emacs
   '(progn
         (run-at-time 0 nil 'slime-repl-clear-buffer)
         nil)))

;;; <><><><><><><><><><><>
;;;       MAIN LOOP
;;; <><><><><><><><><><><>

;;; The main game loop!
;;; Here it is below:

(defun main-loop ()

  (uwu-init)
  
  (loop
     (read-keys)
     (comprehend-input *keypress*)
     (process-state)))

;;; As you can see above, the main loop initialises the game once, and
;;; then zips through a tight loop, performing the following: (1)
;;; Reading user input from the keyboard; then (2) Processing the
;;; keypress from the user into a command to feed into (3) the pet's
;;; internal happiness, nutritional, and recreational state.


#|

<><><><><><><><><><><><>
  INITIALISE THE GAME
<><><><><><><><><><><><>

|#

(defun uwu-init ()

;;; This, below, is a simple little function that (i) clears the
;;; screen, and then (ii) draws the screen. Here it is executed for
;;; the first time, under the init function.
  
  (defun idle-state ()
    (clear-emacs-buffer)
    (draw-screen-idle *hunger* *entertainment*))

;;; Now, this, immediately below, is a fairly complex line. Here we
;;; are, evaluating from right to left: (i) creating a timer object
;;; out of the idle-state function, which we are giving the same name
;;; as the original function; then (ii) storing that object into
;;; memory as a variable.
  
  (setq *idle-state* (make-timer #'idle-state :name 'idle-state))

;;; And we did that because then we can schedule and unschedule the
;;; execution of the idle-state function using the 'schedule-timer'
;;; and 'unschedule-timer' functions. If we wanted the idle-state
;;; function to continue running forever, uninterrupted, then we would
;;; not have to bother separating out the above expression from the
;;; one below.
  
  (schedule-timer *idle-state* 1 :repeat-interval 1)

  ;; Initialise the hunger variable

  (setq *increase-hunger* (make-timer #'increase-hunger :name 'increase-hunger))

  (schedule-timer *increase-hunger* 5 :repeat-interval 5))



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

Write the comments for the keypressing function here.

|#
  
#|
<><><><><><><>
  GAME LOGIC
<><><><><><><>
|#

(defun comprehend-input (key-input)
  (cond ((equal 'feed key-input) (feed))
	((equal 'toy key-input) (setf *enterainment* (+ *entertainment* 10)))
		))

(defun process-state ()

  (cond
    
    ((and
      (> *hunger* 90)
      (equal 'normal *state*))
     (setf *pet-appearance* birb-face))
        
  ((and
    (> *hunger* 80)
    (equal 'normal *state*))
   (setf *pet-appearance* owo-gfx))
    
  ((and
    (> *hunger* 50)
    (equal 'normal *state*))
   (setf *pet-appearance* uwu-gfx))
  
  ((and
    (> *hunger* 40)
    (equal 'normal *state*))
   (setf *pet-appearance* shocked-gfx))
  
  ((and
    (> *hunger* 20)
    (equal 'normal *state*))
   (setf *pet-appearance* run-away-gfx))))
  
(defun increase-hunger ()
  (setf *hunger* (+ *hunger* 5))
  )

(defun feed ()
  (setf *hunger* 0))




    

#|
<><><><><><><><><><><>
  DRAWING THE SCREEN
<><><><><><><><><><><>
|#

(defun draw-screen-idle (hunger entertainment)

 
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
		    (nth *rng-move* *pet-appearance*))) #\return)
    (print *hunger*)
    (print *movement*)
    ))


#|
(setq *timer* (make-timer #'print-hello :name 'idle-state))
(schedule-timer *timer* 1 :repeat-interval 1)
(unschedule-timer *timer*)
|#
