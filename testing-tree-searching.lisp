
;;; Search for possible evolutions given current skill level.

(setf *skill-smart* 100)
(setf *skill-creative* 0)
(setf *skill-social* 50)


(defun evolution-priority (smart creative social)
  (setf sort-list (list smart creative social))
    (sort sort-list #'>)
    (print sort-list)
    (cond ((equal (car sort-list) *skill-smart*) (setf skill-search 'smart))
	   	   	   
	   ((equal (car sort-list) *skill-creative*)(setf skill-search 'creative))
	    	   
	   ((equal (car sort-list) *skill-social*)(setf skill-search 'social))))

(setf care-search 'lawful)

(defun possible-evolutions-lawful (highest-skill)
  (setf table-skill-value
	(assoc 'min-skill
	       (cdr (assoc 'data			   
		     (cdr (assoc 'normie				 
				 (cdr (assoc 'smart
					     (cdr (assoc 'lawful *adult-data*))))))))))

  (eual 
