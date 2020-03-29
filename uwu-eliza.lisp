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
  '(

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

    ((* x you are * y)
     (what makes you think i am y)
     (does it make u happy to believe i am y)
     (perhaps you would like to be y)
     (do you sometimes desiwwe to be))

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
     (are you interested in whether or not i am y ?)
     (would you prefer if i were not y ?)
     (perhaps you dream that i am y ?))
    
    ;;; i can't

    ((* x i cant * y)
     (how do you know you cant y ?)
     (have you tried?)
     (perhaps you can now y ))
    
    ;;; i am

    ((* x i am * y)
     (did you wanna talk to me because you are y ?)
     (how long have you been y ?)
     (do you wweckon its normal to be y ?)
     (do you enjoy being y ?))
    
    ;;; i'm

    ((* x im * y)
     (did you wanna talk to me because you are y ?)
     (how long have you been y ?)
     (do you wweckon its normal to be y ?)
     (do you enjoy being y ?))
        
    ;;; you

    ((* x you * y)
     (OwO oh yeah??)
     (oh, i y)
     (are you wweawwy talking about me ? >w<)
     (awwe we discussing u or me? XD))
    
    ;;; i want

    ((* x i want * y)
     (what it mean if u pwocuwed y ?)
     (OwO why do u wequiwe y ??)
     (hmm... suppose u soon got y ?)
     (what if you never obtainyed y)
     (i sometimes also desiwe y))
    
    
    ;;; what

    ((* x what * y)
     (y do u awwsk ??)
     (does that interest you ?)
     (what answer would please you the most ?)
     (what do you think ?)
     (is this on your mind often ?)
     (what do you really want to know ?)
     (have you asked anyone else about this ?)
     (have you asked this before ?)
     (what else comes to mind when you ask that ?)
     (are you asking me ? ^_^))
    
    ;;; how

    ((* x how * y)
     ())

    
    ;;; who

    ((* x who * y)
     ())

    
    ;;; where

    ((* x where * y)
     ())

    
    ;;; when

    ((* x when * y)
     ())

    
    ;;; why


    ((* x why * y)
     ())

    ;;; cause

    ((* x cause * y)
     (is that the real reason ?)
     (do any other reasons come to mind ?)
     (does that reason explain anything else ?)
     (what other reasons might there be ?))

    
    ;;; because

    ((* x because * y)
     (is that the real reason ?)
     (do any other reasons come to mind ?)
     (does that reason explain anything else ?)
     (what other reasons might there be ?))
    
    ;;; sorry

    ((* x sorry * y)
     (dont apologise, iss kay-o ^w^)
     (apologies are not necessary !!)
     (you say sowwee... what makes you feel the need to apologise ?))

    
    ;;; dream

    ((* x dream * y)
     (what does that dream suggest to you ?)
     (do you often dream ?)
     (what appears in your dreams ?)
     (are you made upset by your dwweams? ?))
   
    ;;; dreams

    ((* x dreams * y)
     ())

    
    ;;; hello

    ((* x hello * y)
     (hewwo ^w^  how awwe you ?)
     (gweetings ^w^)
     (sawutations UwU)
     (howdy~~ >w<)
     (wewwcome!!! XD)
     (hi ya~~)
     (good day, hooman!)
     (^.^ what's up ?)
     (hey~~ o.o)
     (awwo!! wass happenying ?))
    
    ;;; hi


    
    ;;; maybe

    ((* x maybe * y)
     (you dont seem quite certain)
     (why are you uncertain ?)
     (you are not sure)
     (dont you know ???))
    
    ;;; no

    ((* x no * y)
     (v_v'' !!! whye not ?)
     (r u sure ?)
     (@-@ >>NOTICES UR NEGATION<< whye u say dat ?)
     (...seems ur wesponding nyegativewy .w.  whye is dat ??)
     (whye not ? u not happy ._. ?))
    
    ;;; your

    ((* x your * y)
     (are you concerned about my y ?)
     (what about your own y ?))

    
    ;;; always
    
    ((* x always * y)
     (can you think of a specific example ?)
     (when ?)
     (what are you thinking of ?)
     (really ?? always ??))

    
    ;;; think

    ((* x think * y)
     (do you really think so ?)
     (but you are not sure you y ?)
     (do you doubt you y ?))

    
    ;;; alike

    ((* x alike * y)
     (in what way ?)
     (what resemblance do you see ?)
     (what other connections do you see ?)
     (how ?))

    
    ;;; yes
    
    ((* x yes * y)
     (you seem positive ^.^)
     (are you sure ?)
     (i see !!)
     (i understand))

    ;;; i wish
    
    ((* x i wish * y)
     (why would it be better if y ?))


    ;;; i hate

    
    ((* x i hate * y)
     (what makes you hate y ?))


    ;;; if

    
    ((* x if * y)
     (do you weawwy think it is wikewy that y ?? XD)
     (wat u think about y ??))


    ;;; i was
    
    ((* x i was * y)
     (why do you say x you were y ?))


    ;;; misc

    
    ((* x)
     (you say x ?)
     (tell me more.)
     (i see!! ^w^)
     (i don't understand you fuwwy !!)
     (you don't say !!)
     (UwU)
     (can you elaborate on that?)
     (that is quite interesting!)
     (does that suggest anything to you ??)
     
     )
    ))

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
    
