#! /bin/sh
# -*- mode: scheme; coding: utf-8 -*-
exec guile -L ./src -e main -s "$0" "$@"
!#

(use-modules (vec3)
	     (ray)
	     (image)
	     (ice-9 match))

(define (float->int x) (inexact->exact (floor x)))

(define (main args)
  (define aspect-ratio (float->int 16/9))
  (define width 100)
  (define height (float->int (* width aspect-ratio)))
  (define vp-height 2.)
  (define vp-width (* vp-height (/ width height)))
  (match args
    [(name) #t]
    [(name w) (set! width (string->number w))])
  )
