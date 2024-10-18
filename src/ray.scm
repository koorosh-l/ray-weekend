(define-module (ray)
  #:use-module (vec3))

(define-public ray cons)
(define-public dir car)
(define-public origin cdr)

(define-inlinable (ray-at ray t)
  (define ret (vscale (dir ray) t))
  (v3-add! ret (origin ray) ret)
  ret)
