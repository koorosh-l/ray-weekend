(define-module (hittables)
  #:use-module (vec3)
  #:use-module (utils)
  #:use-module (srfi srfi-9)
  #:export (hit-record hit-point hit-normal hit-t))

(define-record-type <hit-record>
  (hit-record point normal t front-face)
  hit-record?
  (point      get-point      set-point!)
  (normal     get-normal     set-normal!)
  (front-face get-front-face set-front-face!)
  (t get-t set-t))

(define hittable            cons)
(define hittable-colide-func car)
(define hittable-object      cdr)

(define (hit object ray tmin tmax) ;;-> hrec
  (define hrec (make-hit-record))
  ((hittable-colide-func object) object hrec)
  hrec)

(define (hit! object ray tmin tmax hrec)
  ((hittable-colide-func object) object hrec))
