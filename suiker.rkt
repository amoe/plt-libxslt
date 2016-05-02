#lang scheme

(require (prefix-in xslt: "libxslt.rkt"))
(require (prefix-in xml: "libxml.rkt"))

(provide xsltproc xsltproc-2 xsltproc-3)

(define *null-document*
  (let ((stub-xml "<?xml version=\"1.0\"?><root/>"))
    (xml:parse-memory stub-xml (string-length stub-xml))))

(define (xsltproc path)
  (let* ((cur (xslt:parse-stylesheet-file (if (path? path)
                                              (path->string path)
                                              path)))
         (res (xslt:apply-stylesheet cur *null-document* #f)))
    (let-values (((r1 r2 r3) (xslt:save-result-to-string res cur)))
      (xslt:free-stylesheet cur)
      (xml:free-doc res)
      r2)))
    

(define (xsltproc-2 stylesheet xml-file)
  (let* ((cur (xslt:parse-stylesheet-file (if (path? stylesheet)
                                              (path->string stylesheet)
                                              stylesheet)))
         (doc (xml:parse-file xml-file))
         (res (xslt:apply-stylesheet cur doc #f)))
    (let-values (((r1 r2 r3) (xslt:save-result-to-string res cur)))
      (xslt:free-stylesheet cur)
      (xml:free-doc res)
      (xml:free-doc doc)
      r2)))
    
(define (xsltproc-3 stylesheet xml-data)
  (let* ((cur (xslt:parse-stylesheet-file (if (path? stylesheet)
                                              (path->string stylesheet)
                                              stylesheet)))
         (doc (xml:parse-memory xml-data (string-length xml-data)))
         (res (xslt:apply-stylesheet cur doc #f)))
    (let-values (((r1 r2 r3) (xslt:save-result-to-string res cur)))
      (xslt:free-stylesheet cur)
      (xml:free-doc res)
      (xml:free-doc doc)
      r2)))
    
;; (define (xsltproc path)
;;   (let* ((cur (xslt:parse-stylesheet-file "test.xsl"))
;;          (doc (xml:parse-memory doc-in-mem (string-length doc-in-mem)))
;;          (res (xslt:apply-stylesheet cur doc #f)))
;;     ;(xslt:save-result-to-filename "output.xml" res cur 0)
;;     (let-values (((r1 r2 r3) (xslt:save-result-to-string res cur)))
;;       (display
;;         (format "r1: ~s, r2: ~a, r3: ~s\n" r1 r2 r3)))

;;     (xslt:free-stylesheet cur)
;;     (xml:free-doc res)
;;     (xml:free-doc doc))

;;   (xslt:cleanup-globals)
;;   (xml:cleanup-parser))
  
