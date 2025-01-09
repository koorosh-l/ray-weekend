(define-module (camera)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-9)
  #:use-module (ray)
  #:use-module (vec3)
  #:use-module (scene)
  #:use-module (image)
  #:use-module (utils)
  #:use-module (collider)
  #:use-module (hittables)
  #:export (make-cam cam-render!))

(define-record-type <cam>
  (-make-cam position direction aspect-ratio vp-height
	     ;; img-height
	     focal-length)
  cam?
  (position	get-position	 set-position!)
  (direction	get-direction	 set-direction!)
  (aspect-ratio get-aspect-ratio set-aspect-ratio!)
  (vp-height	get-vp-height	 set-vp-height!)
  ;; (img-height	get-img-height	 set-img-height!)
  (focal-length get-focal-length set-focal-length!))

(define* (make-cam pos dir #:key (aspect-ratio 16/9) (vp-height 2.) (focal-length 1.))
  (isit? "not a vec3" vec3? pos dir)
  (-make-cam pos dir aspect-ratio vp-height focal-length))

(define (cam-render! cam scene img)
  (match-let* ([($ <cam> camera-center _ _ vp-height focal-length) cam]
      [(height width) (array-dimensions img)]
      [vp-width (* vp-height (/ width height))]
      [vp-u (vec3 vp-width 0 0)]
      [vp-v (vec3 0 (- vp-height) 0)]
      [pixel-du (vscale vp-u (/ 1 width))]
      [pixel-dv (vscale vp-v (/ 1 height))]
      [vp-upper-left (v3-add camera-center
			     (v3-add (neg (vec3 0 0 focal-length))
				     (v3-add (vscale vp-u -.5)
					     (vscale vp-v -.5))))]
      [pixel00-loc (v3-add vp-upper-left
			   (vscale (v3-add pixel-du pixel-dv) .5))]
      [pcenter (vec3 0 0 0)]
      [ray-dir (vec3 0 0 0)]
      [intm0   (vec3 0 0 0)]
      [intm1   (vec3 0 0 0)]
      [hrec    (make-hit-record)])
    (image-do img j i
	      (<- intm0 pixel-du)
	      (<- intm1 pixel-dv)
	      (vscale! intm0 i)
	      (vscale! intm1 j)
	      (v3-add! intm0 intm0 intm1)
	      (v3-add! pcenter pixel00-loc intm0)
	      (<- intm0 camera-center)
	      (neg! intm0)
	      (v3-add! ray-dir pcenter intm0)
	      (color-set! img j i
			  (collide hrec (ray camera-center ray-dir) scene 0)))))
