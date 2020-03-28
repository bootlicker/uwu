; Eliza chatbot

(defun match (pat in)
  (if (null pat) 
      (null in)
    (if (eq (first pat) '*)
        (wildcard pat in)
      (if (eq (first pat) (first in))
          (match (rest pat) (rest in))
        nil))))

(defparameter *bindings* nil)

(defun wildcard (pat in)
  (if (match (rest (rest pat)) in)
      (progn (setf *bindings*
                   (bind (first (rest pat)) nil *bindings*)) t)
   (if (null in)
       nil 
     (if (match pat (rest in))
         (progn (setf *bindings* 
                      (bind (first (rest pat)) (first in) *bindings*)) t)
       nil))))

(defun bind (var value bindings)
  (if (null bindings) 
      (list (if value (list var value) (list var)))
    (let* ((key (first (first bindings)))
           (values (rest (first bindings)))
           (new (swap value)))
      (if (eq var key)
          (cons (cons key (cons new values)) (rest bindings))
        (cons (first bindings) (bind var new (rest bindings)))))))

(defun lookup (key alist)
  (if (null alist) nil
    (if (eq (first (first alist)) key)
        (first alist)
      (lookup key (rest alist)))))

(defparameter *viewpoint* '((I you) (you I) (me you) (am are) (was were) (my your)))

(defun swap (value)
  (let* ((a (lookup value *viewpoint*)))
    (if a (first (rest a)) value)))

(defun subs (list)
  (if (null list)
      nil
    (let* ((a (lookup (first list) *bindings*)))
      (if a
          (append (rest a) (subs (rest list)))
        (cons (first list) (subs (rest list)))))))

(defparameter *rules*
  '(((* x hello * y) (hello. how can I help ?))
    ((* x i want * y) (what would it mean if you got y ?) (why do you want y ?))
    ((* x i wish * y) (why would it be better if y ?))
    ((* x i hate * y) (what makes you hate y ?))
    ((* x if * y)
     (do you really think it is likely that y)
     (what do you think about y))
    ((* x no * y) (why not?))
    ((* x i was * y) (why do you say x you were y ?))
    ((* x i feel * y) (do you often feel y ?))
    ((* x i felt * y) (what other feelings do you have?))
    ((* x) (you say x ?) (tell me more.))))

(defun random-elt (list)
  (nth (random (length list)) list))

(defun eliza ()
  (loop
   (princ "} ")
   (let* ((line (read-line))
          (input (read-from-string (concatenate 'string "(" line ")"))))
     (when (string= line "bye") (return))
     (setq *bindings* nil)
     (format t "~{~(~a ~)~}~%"
             (dolist (r *rules*)
               (when (match (first r) input)
                 (return 
                  (subs (random-elt (rest r))))))))))
    