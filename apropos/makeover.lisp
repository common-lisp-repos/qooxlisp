﻿(in-package :qooxlisp)

(defmd apropos-makeover (apropos-variant)
  :syms-filtered (c? (symbol-info-filtered (^syms-unfiltered)
                       (value (fm-other :type-filter))
                       (value (fm-other :exported-only))))
  :kids (c? (the-kids
             (vbox (:spacing 6) 
               (:add '(:left 0 :top 0 :width "100%" :height "100%")
                 :padding 6)
               (search-panel self)
               (hbox (:spacing 6)()
                 (makeover-pkg-filter self)
                 (vbox (:spacing 6 :align-x "center")()
                   (type-filter self)
                   (checkbox :exported-only "Exported Only")))
               (symbols-found self)))))

(defun makeover-pkg-filter (self)
  (checkgroupbox (:spacing 2)(:md-name :selected-pkg-p
                               :add '(:flex 1)
                               :allow-grow-y :js-false
                               :legend "Search One Package"
                               :value (c-in nil)) ;; becomes state of check-box!
    (selectbox :selected-pkg (:add '(:flex 1)
                               :enabled t
                               :onchangeselection (lambda (self req)
                                                        (let ((nv (req-val req "value")))
                                                          (setf (^value) (find-package nv)))))
      (b-if syms nil #+xxx (syms-filtered (u^ apropos-variant))
        (loop with pkgs
            for symi in syms
            do (pushnew (symbol-info-pkg symi) pkgs)
            finally (return (loop for pkg in pkgs
                                collecting
                                  (make-kid 'qx-list-item
                                    :model (package-name pkg)
                                    :label (package-name pkg)))))
        (loop for pkg in (subseq (list-all-packages) 0 #+testing  5)
            collecting
              (make-kid 'qx-list-item
                :model (package-name pkg)
                :label (package-name pkg)))))))


