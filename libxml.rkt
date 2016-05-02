#lang scheme

(require scheme/foreign)

; FIXME: provide functions

(provide substitute-entities-default
         parse-file
         parse-memory
         free-doc
         cleanup-parser
         _doc-ptr)
         

(unsafe!)

(define lib (ffi-lib "libxml2" "2"))

(define-cpointer-type _doc-ptr)

(define substitute-entities-default
  (get-ffi-obj "xmlSubstituteEntitiesDefault" lib
               (_fun _int -> _int)))

(define parse-file
  (get-ffi-obj "xmlParseFile" lib
               (_fun _string/locale -> _doc-ptr)))


(define parse-memory
  (get-ffi-obj "xmlParseMemory" lib
               (_fun _string/locale _int -> _doc-ptr)))

(define free-doc
  (get-ffi-obj "xmlFreeDoc" lib
               (_fun _doc-ptr -> _void)))

(define cleanup-parser
  (get-ffi-obj "xmlCleanupParser" lib
               (_fun -> _void)))
