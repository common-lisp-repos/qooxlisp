(in-package :qooxlisp)

(defmd apropos-session-kt (apropos-session)
  :selected-pkg-p (c? (value (fm-other :selected-pkg-p)))
  :kids (c? (the-kids
             (vbox (:spacing 6) 
               (:add '(:left 0 :top 0 :width "100%" :height "100%")
                 :padding 6)
               (search-panel-kt self)
               (hbox (:spacing 6)()
                 (pkg-filter-kt self)
                 (vbox (:spacing 6 :align-x "center")()
                   (type-filter-kt self)
                   (checkbox :exported-only "Exported Only")))
               (symbols-found self)))))

(defun search-panel-kt (self)
  (hbox (:align-y 'middle :spacing 12)
    (:allow-grow-y :js-false
      :padding 4)
    (lbl "Search for:")
    (textfield :symbol-string ;; WARNING -- new and untested
      :add '(:flex 1)
      :allow-grow-x t
      :onchangevalue (lambda (self req)
                       (let ((sympart (req-val req "value")))
                         (setf (sym-seg (u^ qxl-session)) sympart))))))

(defun pkg-filter-kt (self)
  (checkgroupbox (:spacing 2)(:md-name :selected-pkg-p
                               :add '(:flex 1)
                               :allow-grow-y :js-false
                               :legend "Search One Package"
                               :value (c-in nil)) ;; becomes state of check-box!
    (selectbox :selected-pkg (:add '(:flex 1)
                               :enabled (c? (value (fm-other :selected-pkg-p))))
      (b-if syms (syms-unfiltered (u^ qxl-session))
        (loop with pkgs
            for symi in syms
            do (pushnew (symbol-info-pkg symi) pkgs)
            finally (return (loop for pkg in pkgs
                                collecting
                                  (make-kid 'qx-list-item
                                    :model (package-name pkg)
                                    :label (package-name pkg)))))
        (loop for pkg in (subseq (list-all-packages) 0 5)
            collecting
              (make-kid 'qx-list-item
                :model (package-name pkg)
                :label (package-name pkg)))))))

(defun type-filter-kt (self)
  (groupbox ()(:legend "Show")
    (radiobuttongroup :type-filter (:value (c-in "all"))
      (qx-grid :spacing-x 12 :spacing-y 6)
      (radiobutton "all" "All"
        :add '(:row 0 :column 0))
      (radiobutton "var" "Variables"
        :add '(:row 0 :column 1))
      (radiobutton "fn" "Functions"
        :add '(:row 1 :column 0))
      (radiobutton "class" "Classes"
        :add '(:row 1 :column 1)))))
