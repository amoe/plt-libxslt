#! /usr/bin/env mzscheme
#lang scheme

(require scheme/foreign)

(require (prefix-in xslt: "libxslt.rkt")
         (prefix-in xml: "libxml.rkt"))

; FIXME: add parameter passing

(define (read-file path)
  (apply string-append
         (let ((p (open-input-file path)))
           (let loop ()
             (let ((datum (read-line p)))
               (if (eof-object? datum)
                   '()
                   (cons datum (loop))))))))

(define (main . args)
  (xml:substitute-entities-default 1)

  (let* ((cur (xslt:parse-stylesheet-file "test.xsl"))
         (doc (xml:parse-file "test.xml"))
         (res (xslt:apply-stylesheet cur
                                     doc
                                     (param-list->cvector '("foo" "'baz'")))))
    (xslt:save-result-to-filename "output.xml" res cur 0)
    (xslt:free-stylesheet cur)
    (xml:free-doc res)
    (xml:free-doc doc))

  (xslt:cleanup-globals)
  (xml:cleanup-parser))

(define (param-list->cvector pl)
  (cvector-ptr (list->cvector (append pl '(#f)) _string)))

;; (define (param-list->cvector pl)
;;   (let* ((len (length pl))
;;          (cv  (make-cvector _string (+ len 1))))
;;     ; Now loop over the indices and fill in all of them till the end, except for the last
;;     ; in which fill in #f and return cvector-ptr cv.
;;     (let loop ((i 0) (l pl))
;;       (cond
;;         ((= i len)
;;           (cvector-set! cv len #f)
;;           (cvector-ptr cv))
;;         (else
;;           (cvector-set! cv i (car l))
;;           (loop (+ i 1) (cdr l)))))))

  ;; (cvector-ptr
  ;;  (list->cvector
  ;;   (map (lambda (lst) (list->cvector lst _string)) pl)
  ;;   _cvector)))
 
(apply main (vector->list (current-command-line-arguments)))
