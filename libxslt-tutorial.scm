#! /usr/bin/env mzscheme

#lang scheme

(require (prefix-in xml: "libxml.scm"))
(require (prefix-in xslt: "libxslt.scm"))

(define doc-in-mem "<?xml version=\"1.0\" ?><persons>  <person username=\"JS1\">    <name>John</name>    <family-name>Smith</family-name>  </person>  <person username=\"MI1\">    <name>Morka</name>    <family-name>Ismincius</family-name>  </person></persons>")
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
         (doc (xml:parse-memory doc-in-mem (string-length doc-in-mem)))
         (res (xslt:apply-stylesheet cur doc #f)))
    ;(xslt:save-result-to-filename "output.xml" res cur 0)
    (let-values (((r1 r2 r3) (xslt:save-result-to-string res cur)))
      (display
        (format "r1: ~s, r2: ~a, r3: ~s\n" r1 r2 r3)))

    (xslt:free-stylesheet cur)
    (xml:free-doc res)
    (xml:free-doc doc))

  (xslt:cleanup-globals)
  (xml:cleanup-parser))
  
(apply main (vector->list (current-command-line-arguments)))
