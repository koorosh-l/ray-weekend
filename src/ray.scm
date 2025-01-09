(define-module (ray)
  #:use-module (utils)
  #:use-module (vec3)
  #:use-module (hittables)
  #:use-module (image)
  #:export (ray-at))

(define-public ray cons)
(define-public dir cdr)
(define-public origin car)

(define-inlinable (ray-at ray t)
  (define ret (vscale (dir ray) t))
  (v3-add! ret (origin ray) ret)
  ret)
(define-inlinable (sq a) (* a a))
;;unsafe for threads
(define oc (vec3 0 0 0))
