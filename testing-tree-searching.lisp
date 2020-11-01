
;;; Search for possible evolutions given current skill level.

(setf *skill-smart* 100)
(setf *skill-creative* 0)
(setf *skill-social* 50)

;;; determine the next evolution based on the skill category with the highest points

(defun evolution-priority (smart creative social)
  (setf sort-list (list smart creative social))
    (sort sort-list #'>)
    (print sort-list)
    (cond ((equal (car sort-list) *skill-smart*) (setf *skill-search* 'smart))	   	   	   
	   ((equal (car sort-list) *skill-creative*)(setf *skill-search* 'creative))	    	   
	   ((equal (car sort-list) *skill-social*)(setf *skill-search* 'social))))

(setf care-search 'lawful)

(list 'normie 'active 'funny 'loud)

;;; extract the row of data that corresponds to the skill category that is inputted

(defun possible-evolutions-lawful (highest-skill)
  (setf n 0)
  (setf species (list 'normie 'active 'funny 'loud))
  (setf table-position nil)
  (setf table-skill-value nil)
  (loop
     
     (setf table-position
	   (append table-position
		   (cons (nth n species) nil)))				  
     
     (setf table-skill-value
	   (append table-skill-value	   
		   (cdr (assoc 'min-skill				 
				 (cdr (assoc 'data
					     (cdr (assoc (nth n species)
							 (cdr (assoc highest-skill
								     (cdr (assoc 'lawful *adult-data*))))))))))))
     
     (incf n)
     (when (> n 3) (return (cons table-skill-value (list table-position))))))

;;; This is how you can extract a single table cell from the above function

(append
 (list
  (nth 0 (car (possible-evolutions-lawful 'social)))
  (nth 0 (cadr (possible-evolutions-lawful 'social)))))

;;; storing some old code here
;;; this is a scratch section.

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

;;; This function below will stop the drawing of the animations of the
;;; pet in its idle state, and instead draw the game's main menu,
;;; where you will have the ability to perform more complex
;;; interactions with the pet.

;;; The timers that change the pet's internal state will continue
;;; running in the background, so the game is not paused.

(defun draw-screen-menu ()

  (unschedule-timer *idle-state*)
  (clear-emacs-buffer)

  (croatoan:with-screen (scr :input-echoing nil
			     :input-buffering nil
			     :input-blocking 100
			     :cursor-visible nil
			     :enable-colors nil
			     )

;;; menu items and corresponding key input here
    
  ))
