#! /bin/sh
# -*- mode: scheme; coding: utf-8 -*-
exec guile -L ./src -s "$0" "$@"
!#
(define help-msg "./main.scm output width\n")
(use-modules (vec3)
	     (ray)
	     (image)
	     (utils)
	     (hittables)
	     (objects sphere)
	     (objects backdrop)
	     (shader simple)
	     (camera)
	     (ice-9 match))

;;them objects boyyyyyyy
(define sphere-origin (vec3 0. 0. -1.))
(define sphere-radius .5)
(define earth (sphere-collider (vec3 0 -100.5 -1) 90 (constant-color (color 255 255 0 0))))
;; order  of objects matters alot for now dot dot dot
(define bd (backdrop-collider))
(define objz `(,bd
	       ,(sphere-collider sphere-origin sphere-radius normal-shader)
	       ))
;;defaults
(define aspect-ratio (/ 16. 9.))
(define width 400)
(define file "out")
(match (command-line)
  [(name)         (display help-msg)]
  [(name ofile)   (set! file ofile)]
  [(name ofile w) (set! file ofile) (set! width (string->number w))])

(define height (float->int (/ width aspect-ratio)))
(define img (make-image height width))
(define cam (make-cam (vec3 0 0 0) (vec3 0 0 -1)))

(cam-render! cam objz img)
(call-with-output-file file
  (lambda (port) (write-image img port)))
