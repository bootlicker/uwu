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

			    (I'll you'll)
			    (you'll I'll)

			    (yours mine)
			    (mine yours)

			    (I'd you'd)
			    (you'd I'd)


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

    ;; how are you

    ((* x how are you * y)
     (*** PERFORMING SELF-DIAGNOSTIC *** i appear to be functioning
     within operating parameters!! ^_^) 
     (i am quite gewd~)
     (fine~! how are you??))
    
    ;;; yes
    
    ((* x yes * y)
     (youw seem positive ^.^)
     (are youw suwe ?)
     (i see !!)
     (i undewstand uwu))

    ;;; no

    ((* x no * y)
     (v_v'' !!! whye not ?)
     (BZZZT. NEGATION DETECTED. REASON NOT DECERNIBLE. BZZT. >.o sowwy
     bout dat! y u negate ?)
     (@-@ >>NOTICES UR NEGATION<< whye u say dat ?)
     (...seems ur wesponding nyegativewy .w.  whye is dat ??)
     (whye not ? u not happy ._. ?))

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
     (what makes you think i am y ?)
     (does it make u happy to believe i am y ?)
     (perhaps you would like to be y ?)
     (do you sometimes desire to be y ?))

;;; you're

    ((* x you are * y)
     (what makes you think i am y ?)
     (does it make u happy to believe i am y ?)
     (perhaps you would like to be y ?)
     (do you sometimes desiwwe to be y ?))

;;; i don't

    ((* x i don't * y)
     (don't you really y ?)
     (why don't you y ?)
     (do you wish to be able to y ?)
     (does that trouble you ?))

    ;;; i feel

    ((* x feel * y)
     (do you often feel y ?)
     (do you feel y frequently?)
     (hmm.. tell me more... UwU is feeling y enjoyable?)
     (does feeling y come to you easily ??)
     (does feeling y bother you ? owo'' ??)
     (what are you aware of when you feel y ??))

    ;;; i felt
    
    ((* x i felt * y)
     (what other feelings do you have?)
     (ooo... OWO~~! tell me more!!))
    
    ;;; why you

    ((* x why you * y)
     (do you really believe i don't y)
     (perhaps in time i will y)
     (do you want me to y))
    
    ;;; why i

    ((* x why i * y)
     (do you think you should be able to y ?)
     (why can't you y))
    
    ;;; are you

    ((are you * y)
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
     (do you enjoy being y ?)
     (why do you think you are y ?))
    
    ;;; you

    ((* x you * y)
     (OwO oh yeah??)
     (oh i y)
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
     (why do you ask ??)
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
     (how do you suppose ?)
     (have you tried answering that yourself ? what did you come up with ? ^.^)
     (what are you really asking ??))

    #|
    
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

    |#

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
     (dont apologise -- iss kay-o ^w^)
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
     (good day hooman!)
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

    

    ;;; i wish
    
    ((* x i wish * y)
     (why would it be better if y ?))


    ;;; i hate

    
    ((* x i hate * y)
     (what makes you hate y ?)
     (you say you hate y ! why is that?)
     (really? you hate y ?))


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
     (UwU)  ;;; doesn't push conversation onwards
     (can you elaborate on that?)
     (dat is quite intewesting!)
     (does dat suggest anything to you ??))


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
    
#|
 next step:

> stop the repetition of responses

 - collect number of times particular response given
 - pick the response least used

> allow user to input new keys and responses

|#
