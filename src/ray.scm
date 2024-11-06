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
(define-inlinable (sphere-colide ray sph-origin sph-radius)
  (let* ([q (origin ray)]
	 [d (dir    ray)]
	 [c sph-origin]
	 [c-q (v3-add c (neg q))]
	 [r sph-radius]
	 [a (dot d d)]
	 [b (dot (vscale d -2) c-q)]
	 [c (- (dot c-q c-q) (* r r))]
	 [disc (- (* b b) (* 4 a c))])
    (if (< disc 0)
	-1.0
	(/ (+ (- b) (- (sqrt disc)))
	   (* 2 a)))))
