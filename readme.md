<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 4</b><br/>
"Функції вищого порядку та замикання"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент</b>: Іващук Дмитро Сергійович</p>
<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання
Завдання складається з двох частин:
1. Переписати функціональну реалізацію алгоритму сортування з лабораторної
роботи 3 з такими змінами:
    * використати функції вищого порядку для роботи з послідовностями (де це доречно);
    * додати до інтерфейсу функції (та використання в реалізації) два ключових параметра: key та test , що працюють аналогічно до того, як працюють параметри з такими назвами в функціях, що працюють з послідовностями. При цьому key має виконатись мінімальну кількість разів.
3. Реалізувати функцію, що створює замикання, яке працює згідно із завданням за
варіантом (див. п 4.1.2). Використання псевдо-функцій не забороняється, але, за
можливості, має бути мінімізоване.

## Варіант першої частини 6
Алгоритм сортування вставкою №1 (з лінійним пошуком зліва) за незменшенням.

## Лістинг реалізації першої частини завдання
```lisp
(defun my-sort (sorted lst key test)
  (if lst
      (my-sort (merge 'list sorted (list (car lst)) test :key key) (cdr lst) key test)
      sorted))

(defun sort-start (lst &key (key #'identity) (test #'<))
  (when lst
    (my-sort (list (car lst)) (cdr lst) key test)))
```
### Тестові набори та утиліти першої частини
```lisp
(defun check-function (name func expected &rest args)
  (let ((result (apply func args)))
    (format t "Result ~a: ~a~%" name result)
    (format t "~:[FAILED~;passed~]... ~a~%" (equal result expected) name)))

(defun test1 ()
  (check-function "Test1" 'sort-start '(-3 -1 0 2) '(-3 2 -1 0))
  (check-function "Test2" 'sort-start '(0 -1 2 -3) '(-3 2 -1 0) :key #'abs)
  (check-function "Test3" 'sort-start '(-3 2 -1 0) '(0 -1 2 -3) :key #'abs :test #'>))
```
### Тестування першої частини
```lisp
CL-USER> (test1)
Result Test1: (-3 -1 0 2)
passed... Test1
Result Test2: (0 -1 2 -3)
passed... Test2
Result Test3: (-3 2 -1 0)
passed... Test3
NIL
```
## Варіант другої частини 6

Написати функцію ```rpropagation-reducer``` , яка має один ключовий параметр — функцію
```comparator``` . ```rpropagation-reducer``` має повернути функцію, яка при застосуванні в
якості першого аргумента ```reduce``` робить наступне: при обході списку з кінця, якщо
елемент списку-аргумента ```reduce``` не "кращий" за попередній (той, що "справа") згідно з
```comparator``` , тоді він заміняється на значення попереднього, тобто "кращого", елемента.
Якщо ж він "кращий" за попередній елемент згідно ```comparator``` , тоді заміна не
відбувається. Функція ```comparator``` за замовчуванням має значення ```#'<``` . Обмеження,
які накладаються на використання функції-результату ```rpropagation-reducer``` при
передачі у ```reduce``` визначаються розробником (тобто, наприклад, необхідно чітко
визначити, якими мають бути значення ключових параметрів функції ```reduce``` ```from-end```
та ```initial-value``` ).
```lisp
CL-USER> (reduce (rpropagation-reducer)
'(3 2 1 2 3)
:from-end ...
:initial-value ...)
(1 1 1 2 3)
CL-USER> (reduce (rpropagation-reducer)
'(3 1 4 2)
:from-end ...
:initial-value ...)
(1 1 2 2)
CL-USER> (reduce (rpropagation-reducer :comparator #'>)
'(1 2 3)
:from-end ...
:initial-value ...)
(3 3 3)
```

## Лістинг функції з використанням деструктивного підходу
```lisp
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
```
### Тестові набори та утиліти
```lisp
(defun test2 ()
  (check-function "Test1" 'reduce '(1 1 1 2 3) (rpropagation-reducer) '(3 2 1 2 3) :from-end t :initial-value nil)
  (check-function "Test2" 'reduce '(1 1 2 2) (rpropagation-reducer) '(3 1 4 2) :from-end t :initial-value nil)
  (check-function "Test3" 'reduce '(3 3 3) (rpropagation-reducer :comparator #'>) '(1 2 3) :from-end t :initial-value nil))
```
### Тестування
```lisp
CL-USER> (test2)
Result Test1: (1 1 1 2 3)
passed... Test1
Result Test2: (1 1 2 2)
passed... Test2
Result Test3: (3 3 3)
passed... Test3
NIL
```
