(define-module (collider)
  #:use-module (ray)
  #:use-module (vec3)
  #:use-module (scene)
  #:use-module (image)
  #:use-module (hittables)
  #:use-module (ice-9 match)
  #:use-module (utils)
  #:export (collide))

(define (blend c1 c2)
  (euclidean-quotient (+ c1 c2) 2))

(define (collide hrec ray scene count) ;; -> color
  (let ([objz (find-subvolume ray scene)])
    (find-cols! ray objz hrec)
    (cond
     [(zero? count) (shade hrec)]
     [else (blend (shade hrec)
		  (collide hrec ray scene (1- count)))])))
