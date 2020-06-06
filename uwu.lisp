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

(defparameter *happiness* 75)

;;; This variable is the amount of hunger that the pet is experiencing.
;;; When the value reaches 100, the pet is absolutely famished. When it reaches this value,
;;; the happiness of your pet starts to decrease.

(defparameter *hunger* 0)

;;; This is the variable that increases when you play with your pet.
;;; When you do interesting things with your pet, it increases this value, and when it
;;; reaches 100, it's fully tweakin' out happy, man!! This will positively affect
;;; your pet's happiness! The happiness variable will start to count upwards!

(defparameter *entertainment* 100)

#| new comments needed |#

(defparameter *keypress* nil)
(defparameter *frame-counter* 0)
(defparameter *movement* 0)
(defparameter *rng-move* 0)
(defparameter *state* 'normal)
(defparameter *pet-appearance* uwu-gfx)

;;; 'normal 'birb 'cat 'cool-dude

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
       "(~ ;◎_◎)~"
       "~(◎_◎； ~)"
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
     (comprehend-input *keypress*)
     (process-state)))



#|

<><><><><><><><><><><><>
  INITIALISE THE GAME
<><><><><><><><><><><><>

|#

(defun uwu-init ()

  (defun idle-state ()
    (clear-emacs-buffer)
    (draw-screen-idle *hunger* *entertainment*))
  
  
  (setq *idle-state* (make-timer #'idle-state :name 'idle-state))

  ;; Set the initial appearance of the uwu-pet :3
  
  (schedule-timer *idle-state* 1 :repeat-interval 1)

  ;; Initialise the hunger variable

  (setq *increase-hunger* (make-timer #'increase-hunger :name 'increase-hunger))

  (schedule-timer *increase-hunger* 5 :repeat-interval 5)


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
	((equal 'toy key-input) (setf *entertainment* (+ *entertainment* 10)))
		))

(defun process-state ()

  (cond

    ((and
      (> *happiness* 90)
      (equal 'normal *state))
     (setf *pet-appearance* birb-face))
        
  ((and
    (> *happiness* 80)
    (equal 'normal *state*))
   (setf *pet-appearance* owo-gfx))
    
  ((and
    (> *happiness* 50)
    (equal 'normal *state*))
   (setf *pet-appearance* uwu-gfx))
  
  ((and
    (> *happiness* 40)
    (equal 'normal *state*))
   (setf *pet-appearance* shocked-gfx))
  
  ((and
    (> *happiness* 20)
    (equal 'normal *state*))
   (setf *pet-appearance* run-away-gfx))))
  
(defun increase-hunger ()
  (setf *hunger* (+ *hunger* 1))
  )

(defun feed ()
  (unschedule-timer idle-state
  (setf *hunger* 0)
  )




    

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
