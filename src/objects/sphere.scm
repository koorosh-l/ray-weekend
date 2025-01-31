(define-module (objects sphere)
  #:use-module (ray)
  #:use-module (vec3)
  #:use-module (utils)
  #:use-module (image)
  #:use-module (hittables))

(define-public (sphere-collider center radius shader)
  (let ([center center]
	[radius radius]
	[oc (vec3 0 0 0 )])
    (hittable (lambda (ray hrec)
		(let ([hpoint  (get-point  hrec)]
		      [hnormal (get-normal hrec)])
		  (<- oc (origin ray))
		  (vscale! oc -1)
		  (v3-add! oc center oc)
		  (define d (dir ray))
		  (define a (vlen2 d))
		  (define h (dot d oc))
		  (define c (- (vlen2 oc) (* radius radius)))
		  (define disc (- (* h h) (* a c)))
		  (if (< disc 0)
		      (set-t! hrec 0)
		      (set-t! hrec (- h (/ (sqrt disc) a))))
		  (<- hpoint (ray-at ray (get-t hrec)))
		  (define v (vcopy center))
		  (v3-add! v hpoint (neg v))
		  (unit-vector! v)
		  (<- hnormal v)
		  hnormal
		  hrec))
	      shader)))
