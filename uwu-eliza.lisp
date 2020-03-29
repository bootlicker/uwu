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

(defparameter *viewpoint* '(
			    (I you)
			    (you I)

			    (me you)
			    (you me)
			    
			    (am are)
			    (are am)
			    
			    (was were)
			    (were was)
			    
			    (my your)
			    (your my)
			    
			    (myself yourself)
			    (yourself myself)
			    
			    (I'm you're)
			    (you're I'm)

			    ))

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
  '(((* x hello * y)
     (hewwo ^w^  how awe you ?)
     (gweetings ^w^)
     (sawutations UwU)
     (howdy~~ >w<)
     (wewwcome!!! XD)
     (hi ya~~)
     (good day, hooman!)
     (^.^ what's up ?)
     (hey~~ o.o)
     (awwo!! wass happenying ?))

;;; can you
    
    ((* x can you * y)
     (don't you believe than i can y ?)
     (perhaps you would like to be able to y ?)
     (do you want me to be able to y ?)
     (what makes you think i could y ?))

;;; can i
    
    ((* x can i * y)
     (perhaps you don't want to y)
     (do you want to be able to y)
     (do you think you couldn't y ?))

;;; you are
    
    ((* x you are * y)
     (what makes you think i am y)
     (does it make u happy to believe i am y)
     (perhaps you would like to be y)
     (do you sometimes desiwwe to be))

;;; you're

;;; i don't

    ((* x i don't * y)
     (don't you really y)
     (why don't you y)
     (do you wish to be able to y)
     (does that trouble you ?))

    ;;; i feel

    ((* x i feel * y)
     (do u often feew y ?)
     (do u feew y fwequentwy?)
     (hmm.. teww me mowe... UwU is feewing y enjoyabew?)
     (does feewing y come to you easiwy ??)
     (does feewing y bother u ? owo'' ??)
     (wat r u aware of wen u feel y ??))

;;; i felt

    ((* x i felt * y)
     (wat othew feewings do you have?)
     (ooo... OWO~~! teww me mowe!!))
    
    
    ;;; why you

    ((x * why you * y)
     (do you really believe i don't y)
     (perhaps in time i will y)
     (do you want me to y))
    
    ;;; why i


    ((x * why i * y)
     (do you think you should be able to y ?)
     (why can't you y))
    
    ;;; are you

    ((* x are you * y)
     ())
    

    
    ;;; i can't

    ((* x i cant * y)
     ())


    
    ;;; i am

    ((* x i am * y)
     ())

    
    ;;; i'm

    ((* x im * y)
     ())

    
    ;;; you

    ((* x you * y)
     ())

    
    ;;; i want

    ((* x i want * y)
     (what it mean if u pwocuwed y ?)
     (OwO why do u wequiwe y ??)
     (hmm... suppose u soon got y ?)
     (what if you never obtainyed y)
     (i sometimes also desiwe y))
    
    
    ;;; what

    (()
     ())


    
    ;;; how

    (()
     ())

    
    ;;; who

    (()
     ())

    
    ;;; where

    (()
     ())

    
    ;;; when

    (()
     ())

    
    ;;; why


    (()
     ())

    
    ;;; name

    (()
     ())


    
    ;;; names

    (()
     ())

    
    ;;; cause

    (()
     ())

    
    ;;; because

    (()
     ())

    
    ;;; sorry

    (()
     ())

    
    ;;; dream

    (()
     ())

    
    ;;; dreams

    (()
     ())

    
    ;;; hello


    
    ;;; hi


    
    ;;; maybe

    (()
     ())

    
    ;;; no

    ((* x no * y)
     (v_v'' !!! whye not ?)
     (r u sure ?)
     (@-@ >>NOTICES UR NEGATION<< whye u say dat ?)
     (...seems ur wesponding nyegativewy .w.  whye is dat ??)
     (whye not ? u not happy ._. ?))
    
    ;;; your

    (()
     ())

    
    ;;; always
    
    (()
     ())

    
    ;;; think

    (()
     ())

    
    ;;; alike

    (()
     ())

    
    ;;; yes
    
    (()
     ())
    

    
    ((* x i wish * y)
     (why would it be better if y ?))
    
    ((* x i hate * y)
     (what makes you hate y ?))
    
    ((* x if * y)
     (do you weawwy think it is wikewy that y ?? XD)
     (wat u think about y ??))
    
    
    ((* x i was * y)
     (why do you say x you were y ?))
    

    

    
    ((* x)
     (you say x ?)
     (tell me more.))))

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
    
