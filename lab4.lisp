(defun my-sort (sorted lst key test)
  (if lst
      (my-sort (merge 'list sorted (list (car lst)) test :key key) (cdr lst) key test)
      sorted))

(defun sort-start (lst &key (key #'identity) (test #'<))
  (when lst
    (my-sort (list (car lst)) (cdr lst) key test)))

(defun rpropagation-reducer (&key (comparator #'<))    ;ключові параметри reduce з використанням цієї функції: :from-end t :initial-value nil
  (let ((best nil))  
    (lambda (left right)
      (if (null right)
          (progn (setf best left)
                 (list left))
          (if (funcall comparator left best)
              (progn (setf best left)       
                     (cons left right))
              (cons best right))))))

(defun check-function (name func expected &rest args)
  (let ((result (apply func args)))
    (format t "Result ~a: ~a~%" name result)
    (format t "~:[FAILED~;passed~]... ~a~%" (equal result expected) name)))

(defun test1 ()
  (check-function "Test1" 'sort-start '(-3 -1 0 2) '(-3 2 -1 0))
  (check-function "Test2" 'sort-start '(0 -1 2 -3) '(-3 2 -1 0) :key #'abs)
  (check-function "Test3" 'sort-start '(-3 2 -1 0) '(0 -1 2 -3) :key #'abs :test #'>))


(defun test2 ()
  (check-function "Test1" 'reduce '(1 1 1 2 3) (rpropagation-reducer) '(3 2 1 2 3) :from-end t :initial-value nil)
  (check-function "Test2" 'reduce '(1 1 2 2) (rpropagation-reducer) '(3 1 4 2) :from-end t :initial-value nil)
  (check-function "Test3" 'reduce '(3 3 3) (rpropagation-reducer :comparator #'>) '(1 2 3) :from-end t :initial-value nil))
