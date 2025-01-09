(define-module (scene)
  #:use-module (vec3)
  #:export (empty-scene scene))

;;boundig volume hirearchy later
(define (empty-scene vmin vmax depth)
  depth) 

(define (add-to-scene! scn obj)
  scn)

(define (scene . objz)
  objz)

(define-public (find-subvolume ray scn)
  scn)
