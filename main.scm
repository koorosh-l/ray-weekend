#! /bin/sh
# -*- mode: scheme; coding: utf-8 -*-
exec guile -L ./src -e main -s "$0" "$@"
!#

(use-modules (vec3)
	     (ray)
	     (image)
	     (ice-9 match))

(define (float->int x) (inexact->exact (floor x)))
(define (grad-pixel x d)
  (inexact->exact (floor (* 255.999 (/ (* x 1.0) (1- d))))))

(define (main args)
  (define width 100)
  (define file)

  (match args
    [(name) (display "bad args")]
    [(name ofile) (set! file ofile)]
    [(name ofile w) (set! file ofile) (set! width (string->number w))])

  (define aspect-ratio 9/16)
  (define height (float->int (* width aspect-ratio)))

  (define vp-height 2.)
  (define vp-width (* vp-height (/ width height)))

  (define focal-length 1.0)

  (define camera-center (vec3 0 0 0))

  (define vp-u (vec3 vp-width 0 0))
  (define vp-v (vec3 0 (- vp-height) 0))

  (define pixel-du (vscale vp-u (/ 1 width)))
  (define pixel-dv (vscale vp-v (/ 1 height)))

  (define vp-upper-left (neg (v3-add (neg camera-center)
				     (vec3 0 0 focal-length)
				     (vscale vp-u 1/2)
				     (vscale vp-v 1/2))))
  (define pixel00-loc (v3-add ))
  (define img (make-image height width))

  (image-do img j i
	    (color-set! img j i
			(color (grad-pixel i width)
			       (grad-pixel j height)
			       (grad-pixel j height)
			       0)))
  (call-with-output-file file
    (lambda (port) (write-image img port))))
