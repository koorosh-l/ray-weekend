(define-module (hittables)
  #:use-module (vec3)
  #:use-module (utils)
  #:use-module (ray)
  #:use-module (srfi srfi-9)
  #:use-module (ice-9 control)
  #:use-module (ice-9 match)
  #:export (hit-record hit-point hit-normal hit-t
		       <hit-record>
		       make-hit-record
		       hittable hittable-collide-func hittable-object
		       get-point set-point!
		       get-normal set-normal!
		       get-front-face set-front-face!
		       get-t set-t! get-obj set-obj!
		       hit hit! hit?
		       find-cols! shade))

(define-record-type <hit-record>
  (hit-record point normal t obj)
  hit-record?
  (point      get-point      _set-point!)
  (normal     get-normal     _set-normal!)
  ;; (front-face get-front-face _set-front-face!)
  (t get-t set-t!)
  (obj get-obj set-obj!)) ;; pointer optimize later

(define-public make-hit-record
  (case-lambda
    [() (hit-record (vec3 0 0 0)
		    (vec3 0 0 0)
		    0 #f)]
    [(point normal t obj)
     (isit? "not a vector" vec3? point normal)
     (isit? "not an f64" inexact? t)
     (hit-record point normal t obj)]))

(define (set-point! hrec px py pz)
  (let ([p (get-point hrec)])
    (vset! p 0 px)
    (vset! p 1 py)
    (vset! p 2 pz)))
(define (set-normal! hrec px py pz)
  (let ([p (get-normal hrec)])
    (vset! p 0 px)
    (vset! p 1 py)
    (vset! p 2 pz)))

(define-inlinable (hittable collider shader) (cons collider shader))
(define-public hittable-collide-func car)
(define-public hittable-shader       cdr)

(define-public (shade hrec)
  (match-let* ([($ <hit-record> point normal t obj) hrec])
    ((hittable-shader obj) hrec)))


(define-inlinable (hit! ray obj hrec)
  ((hittable-collide-func obj) ray hrec)
  (set-obj! hrec obj))

(define (hit? hrec) (not (zero? (get-t hrec))))

(define (find-cols! ray objz hrec) ;; to be minfied with eu-dist
  (define tmp (make-hit-record))
  (hit! ray (car objz) hrec)

  (define (smaller h1 h2)
    (if (< (get-t h1) (get-t h2)) h1 h2))

  (define obj (cdr (car (filter (lambda (o)
				  (not (zero? (car o))))
				(sort (map (lambda (o)
					     (hit! ray o tmp)
					     (cons (get-t tmp) o))
					   objz)
				      (lambda (a b) (< (car a) (car b))))))))
  (hit! ray obj hrec))
