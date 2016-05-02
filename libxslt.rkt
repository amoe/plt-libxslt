#lang scheme

; FFI wrapper for libxslt.  Development proceeded thus: we took
; Fleck's libxslt tutorial, implemented all libxml and libxslt
; functions and data types used in it.  Other functions are added as
; and when I need to use them.

(require scheme/foreign)
(require "libxml.rkt")    ; ???

(provide parse-stylesheet-file
         apply-stylesheet
         save-result-to-filename
         save-result-to-string
         free-stylesheet
         cleanup-globals
         parse-memory)
         

(unsafe!)

(define lib (ffi-lib "libxslt" "1"))


; XXX: Can't be just _char, since that would mean the C char...
(define-cpointer-type _stylesheet-ptr)
(define _xml-char _string/locale)


(define parse-stylesheet-file
  (get-ffi-obj "xsltParseStylesheetFile" lib
               (_fun _xml-char -> _stylesheet-ptr)))

; FIXME: 3rd parameter needs to be:
;   const char **params;
;   // A NULL terminated array of parameters name/values tuples
(define apply-stylesheet 
  (let ((ffi-priv (get-ffi-obj "xsltApplyStylesheet" lib
                               (_fun _stylesheet-ptr _doc-ptr _pointer -> _doc-ptr))))
    (lambda (style doc params)
      (ffi-priv style doc params))))


; FIXME: Should be save-result-to-file, but we can't handle FILE* yet
(define save-result-to-filename
  (get-ffi-obj "xsltSaveResultToFilename" lib
               (_fun _string/locale _doc-ptr _stylesheet-ptr _int
                     -> _int)))

(define free-stylesheet
  (get-ffi-obj "xsltFreeStylesheet" lib
               (_fun _stylesheet-ptr -> _void)))

(define cleanup-globals
  (get-ffi-obj "xsltCleanupGlobals" lib
               (_fun -> _void)))

(define save-result-to-string
  (get-ffi-obj "xsltSaveResultToString" lib
               (_fun (doc-txt-ptr : (_ptr o _string))
                     (doc-txt-len : (_ptr o _int))
                     _doc-ptr
                     _stylesheet-ptr
                     -> (i : _int)
                     -> (values i doc-txt-ptr doc-txt-len))))
