(define-module (ray)
  #:use-module (utils)
  #:use-module (vec3)
  #:export (ray-at sphere-colide))

(define-public ray cons)
(define-public dir cdr)
(define-public origin car)

(define-inlinable (ray-at ray t)
  (define ret (vscale (dir ray) t))
  (v3-add! ret (origin ray) ret)
  ret)
;; returns a cons cell or empty list if there is no intersection
(define-inlinable (sq a) (* a a))
;;unsafe for threads
(define oc (vec3 0 0 0))
(define-inlinable (sphere-colide ray center r)
  ;; (define oc (vcopy (origin ray)))
  (<- oc (origin ray))
  (vscale! oc -1)
  (v3-add! oc
	   center
	   oc)
  (define d (dir ray))
  (define a (vlen2 d))
  (define h (dot d oc))
  (define c (- (vlen2 oc) (* r r)))
  (define disc (- (* h h) (* a c)))
  (if (< disc 0)
      -1.0
      (- h (/ (sqrt disc) a))))
