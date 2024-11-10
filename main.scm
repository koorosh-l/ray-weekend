#! /bin/sh
# -*- mode: scheme; coding: utf-8 -*-
exec guile -L ./src -s "$0" "$@"
!#

(use-modules (vec3)
	     (ray)
	     (image)
	     (utils)
	     (ice-9 match))

(define (grad-pixel x d) (inexact->exact (floor (* 255.999 (/ (* x 1.0) (1- d))))))
(define sphere-origin (vec3 0 0 -1))
(define one (vec3 1 1 1))
(define sphere-radius .5)
;; order of objects matters alot
(define objects `(,(make-sphere sphere-origin sphere-radius)
		  ))

(define width 100)
(define file)

(match (command-line)
  [(name) (display "bad args")]
  [(name ofile) (set! file ofile)]
  [(name ofile w) (set! file ofile) (set! width (string->number w))])

(define aspect-ratio 16/9)
(define height (float->int (/ width aspect-ratio)))

(define vp-height 2.)
(define vp-width (* vp-height (/ width height)))

(define focal-length 1.0)

(define camera-center (vec3 0 0 0))

(define vp-u (vec3 vp-width 0 0))
(define vp-v (vec3 0 (- vp-height) 0))

(define pixel-du (vscale vp-u (/ 1 width)))
(define pixel-dv (vscale vp-v (/ 1 height)))
(define vp-upper-left
  (neg (v3-add (neg camera-center)
	       (v3-add (vec3 0 0 focal-length)
		       (v3-add (vscale vp-u .5)
			       (vscale vp-v .5))))))
(define pixel00-loc (v3-add vp-upper-left
			    (vscale (v3-add pixel-du pixel-dv) .5)))

(define img (make-image height width))
(define z (vec3 0 0 0))
(define pcenter (vec3 0 0 0))
(define ray-dir (vec3 0 0 0))
(define intm0 (vec3 0 0 0))
(define intm1 (vec3 0 0 0))

(image-do img j i
	  (<- pcenter z)
	  (<- intm0 pixel-du)
	  (<- intm1 pixel-dv)
	  (vscale! intm0 i)
	  (vscale! intm1 j)
	  (v3-add! intm0 intm0 intm1)
	  (v3-add! pcenter pixel00-loc intm0)
	  (<- intm0 camera-center)
	  (neg! intm0)
	  (v3-add! ray-dir pcenter intm0)
	  (color-set! img j i
		      (ray-color (ray camera-center ray-dir) objects)))

(call-with-output-file file
  (lambda (port) (write-image img port)))
