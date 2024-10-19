(define-module (vec3)
  #:export (vec3 vref vset!
		 ix3 v3-bin-do! v3-bin-do
		 v3-add v3-add! vscale vscale! neg neg!
		 dot cross <-))

(define-inlinable (vec3 a b c) (f64vector a b c))
(define-inlinable (vref v ix) (f64vector-ref v ix))
(define-inlinable (vset! v ix f) (f64vector-set! v ix f))

(define-syntax ix3
  (syntax-rules ()
    [(_ ix body ...)
     (begin
       (define ix 0)
       body ...
       (set! ix 1)
       body ...
       (set! ix 2)
       body ...)]))

(define (vcopy v)
  (when (f64vector? v)
    (f64vector (vref v 0) (vref v 1) (vref v 2))))

(define-syntax v3-bin-do!
  (syntax-rules ()
    [(_ op v1 v2 v3)
     (ix3 i
	  (vset! v1 i (op (vref v2 i)
			  (vref v3 i))))]))
(define-syntax v3-bin-do
  (syntax-rules ()
    [(_ op v1 v2)
     (let ([ret (vec3 0 0 0)])
       (ix3 i
	    (vset! ret i (op (vref v1 i)
			     (vref v2 i))))
       ret)]))

(define-inlinable (v3-add! v1 v2 v3) (v3-bin-do! + v1 v2 v3))
(define-inlinable (v3-add v1 v2) (v3-bin-do + v1 v2))

(define-inlinable (vscale! v s) (ix3 i (vset! v i (* s (vref v i)))))
(define-inlinable (vscale v s)
  (let ([ret (vcopy v)])
    (vscale! ret s)
    ret))

(define-inlinable (dot v1 v2)
  (+ (* (vref v1 0)
	(vref v2 0))
     (* (vref v1 1)
	(vref v2 1))
     (* (vref v1 2)
	(vref v2 2))))

(define-inlinable (cross u v )
  (vec3 (- (* (vref u 1)
	      (vref v 2))
	   (* (vref u 2)
	      (vref v 1)))
	(- (* (vref u 2)
	      (vref v 0))
	   (* (vref u 0)
	      (vref v 2)))
	(- (* (vref u 0)
	      (vref v 1))
	   (* (vref u 1)
	      (vref v 0)))))
(define-inlinable (neg! v) (vscale! v -1))
(define-inlinable (neg v) (vscale v -1))
(define-inlinable (<- v1 v2)
  (vset! v1 0 (vref v1 0))
  (vset! v1 1 (vref v1 1))
  (vset! v1 2 (vref v1 2)))
