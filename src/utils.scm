(define-module (utils)
  #:export (lnr float->int))

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
