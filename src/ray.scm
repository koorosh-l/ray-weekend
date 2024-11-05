(define-module (ray)
  #:use-module (vec3))

(define-public ray cons)
(define-public dir cdr)
(define-public origin car)

(define-inlinable (ray-at ray t)
  (define ret (vscale (dir ray) t))
  (v3-add! ret (origin ray) ret)
  ret)

(define (sphere-colide ray sph-origin sph-diameter) ;;return t
  1)
