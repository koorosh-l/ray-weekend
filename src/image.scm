(define-module (image)
  #:use-module (ice-9 threads)
  #:use-module (ice-9 control)
  #:use-module ((srfi srfi-1) #:select (fold unfold))
  #:export (make-image color-at color-set! color
		       red blue green alpha
		       image-do write-image
		       para-image-do))

(define-public RED_MASK   #xff000000)
(define-public GREEN_MASK #x00ff0000)
(define-public BLUE_MASK  #x0000ff00)
(define-public ALPHA_MASK #X000000ff)

(define-public RED_SHIFT   24)
(define-public GREEN_SHIFT 16)
(define-public BLUE_SHIFT  8)
(define-public ALPHA_SHIFT 0)

(define-inlinable (make-image h w)
  (make-typed-array 'u32 0 h w))

(define-inlinable (color-at img i j) (array-ref img i j))
(define-inlinable (color-set! img i j cl) (array-set! img cl i j))
(define-inlinable (color r g b a)
  (+ (ash r RED_SHIFT)
     (ash g GREEN_SHIFT)
     (ash b  BLUE_SHIFT)
     (ash a ALPHA_SHIFT)))

(define-inlinable (red cl)
  (ash (logand cl RED_MASK)
       (- RED_SHIFT)))
(define-inlinable (green cl)
  (ash (logand cl GREEN_MASK)
       (- GREEN_SHIFT)))
(define-inlinable (blue cl)
  (ash (logand cl BLUE_MASK)
       (- BLUE_SHIFT)))
(define-inlinable (alpha cl)
  (ash (logand cl ALPHA_MASK)
       (- ALPHA_SHIFT)))

(define-syntax-rule (image-do img i j body ...)
  (begin
    (define i 0)
    (define j 0)
    (define x (car  (array-dimensions img)))
    (define y (cadr (array-dimensions img)))
    (while (< i x)
      (while (< j y)
	body ...
	(set! j (1+ j)))
      (set! j 0)
      (set! i (1+ i)))
    #t))


(define-inlinable (div-img img nproc)
  (define l (array-length img))
  (define n nproc)
  (define step (floor-quotient l n))
  (define rem  (floor-remainder l n))
  (define res (unfold (lambda (i) (>= i n))
		      (lambda (i) `(,(+ rem (* i step))
			       ,(+ rem (* (1+ i) step) -1)))
		      1+ (if (zero? rem) 0 1)))
  (map (lambda (i)
	 (make-shared-array img list
			    i
			    (cadr (array-dimensions img))))
       (if (zero? rem)
	   res
	   (cons `(0 ,rem) res))))
(define-syntax-rule (para-image-do nproc img i j body ...)
  (begin
    (par-for-each (lambda (a)
		    (image-do a
			      img i j body ...))
		  (div-img img nproc))
    #t))

(define (write-image img port)
  (define x (car  (array-dimensions img)))
  (define y (cadr (array-dimensions img)))
  (format port "P3\n~a ~a\n255\n" y x)
  (image-do img i j
	    (let ([c (color-at img i j)])
	      (format port "~a ~a ~a\n" (red c) (green c) (blue c)))))
