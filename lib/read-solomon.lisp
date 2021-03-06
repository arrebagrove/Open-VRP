;;; Interface to read in testcases from files
;;; (Solomon style: http://neo.lcc.uma.es/radi-aeb/WebVRP/index.html?/Problem_Instances/CVRPTWInstances.html)
;;; ---
(in-package :open-vrp.util)

(defun couple-lists (list1 list2)
  "Given a list of x and y-coords, return a list of pairs usable. Used for node-coords or time-windows."
  (loop for x in list1 and y in list2 collect (cons x y)))
		       
(defun load-solomon-vrp-file (file)
  "Load testcase from file, which should be Solomon style."
  (with-open-file (in file)
    (let ((name (read in))
	  (fleet-size (progn (dotimes (n 3) (read in)) (read in)))
	  (capacities (read in)))
      (dotimes (n 12) (read in))
      (loop
	 while (read in nil)
	 collect (read in) into x-coords
	 collect (read in) into y-coords
	 collect (read in) into demands
	 collect (read in) into min-times
	 collect (read in) into max-times
	 collect (read in) into service-duration
	 finally
	   (return
	     (define-problem name fleet-size
	       :node-coords-list (couple-lists x-coords y-coords)
	       :demands demands
	       :capacities (make-list fleet-size :initial-element capacities)
	       :time-windows-list (couple-lists min-times max-times)
	       :durations service-duration))))))