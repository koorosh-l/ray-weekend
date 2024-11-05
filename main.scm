#! /bin/sh
# -*- mode: scheme; coding: utf-8 -*-
exec guile -L ./src -e main -s "$0" "$@"
!#

(use-modules (vec3)
	     (ray)
	     (image)
	     (utils)
	     (ice-9 match))

(define (grad-pixel x d) (inexact->exact (floor (* 255.999 (/ (* x 1.0) (1- d))))))

(define-inlinable (ray-color ray)
  (if (sphere-colide ray (vec3 0 0 -1) .5)
      (color 255 0 0 0)
      (begin
	(let ([a (* .5 (1+ (vy (unit-vector (dir ray)))))]
	      [c (vec3 1 1 1)])
	  (vscale! c (- 1 a))
	  (v3-add! c (vscale (vec3 .5 .7 1.) a) c)
	  (vec3->color c)))))

(define (main args)
  (define width 100)
  (define file)

  (match args
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
  (image-do img j i
	    (let* ([pcenter (v3-add pixel00-loc (v3-add (vscale pixel-du i) (vscale pixel-dv j)))]
		   [ray-dir (v3-add pcenter (neg camera-center))]
		   [r (ray camera-center ray-dir)])
	      (color-set! img j i
			  (ray-color r))))
  (call-with-output-file file
    (lambda (port) (write-image img port))))
