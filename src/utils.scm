(define-module (utils)
  #:export (lnr float->int isit?))

(define-inlinable (float->int x) (inexact->exact (floor x)))

(define-syntax-rule (lnr exp ...)
  (let ([e (begin exp ...)])
    (format (current-error-port) "----------~a ~a\n" (current-source-location) e)
    e))

(define-public (do-time thunk n)
  (let loop ([n n])
    (cond
     [(zero? n) #t]
     [else (thunk) (loop (1- n))])))

(define-syntax isit?
  (syntax-rules ()
    [(_ msg pred? obj)
     (when (not (pred? obj))
       (error (format (current-error-port)
		      "~a ~a" (current-source-location) msg)
	      'obj 'pred?))]
    [(_ msg pred? obj obj* ...)
     (begin (isit? msg pred? obj)
	    (isit? msg pred? obj* ...))]))
