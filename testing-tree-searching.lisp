
;;; Search for possible evolutions given current skill level.

(setf *skill-smart* 100)
(setf *skill-creative* 0)
(setf *skill-social* 50)


(defun evolution-priority (smart creative social)
  (setf sort-list (list smart creative social))
    (sort sort-list #'>)
    (print sort-list)
    (cond ((equal (car sort-list) *skill-smart*) (setf *skill-search* 'smart))
	   	   	   
	   ((equal (car sort-list) *skill-creative*)(setf *skill-search* 'creative))
	    	   
	   ((equal (car sort-list) *skill-social*)(setf *skill-search* 'social))))

(setf care-search 'lawful)

(list 'normie 'active 'funny 'loud)

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
	
	

  (eual 
