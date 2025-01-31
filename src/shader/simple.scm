(define-module (shader simple)
  #:use-module (vec3)
  #:use-module (hittables)
  #:use-module (image)
  #:export (normal-shader))

(define-inlinable (normal-shader hrec)
  (define res (vcopy (get-normal hrec)))
  (define one (vec3 1 1 1))
  (if (hit? hrec)
      (begin
	(v3-add! res res one)
	(vscale! res .5)
	(vec3->color res))
      (color 0 0 0 0)))

(define-public (constant-color color)
  (lambda (hrec) color))
