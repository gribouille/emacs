C-x r : undo tree -> C-z

C-<prior>: contract region
C-<next>: expand region
C-S-s : helm swoop
C-c b : google this
<f8>  : neotree


ivy
projectile
company
flycheck

;; Package: give key candidates after a delay
(use-package guide-key
  :defer t
  :diminish guide-key-mode
  :config
  (progn
  (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-c"))
  (guide-key-mode 1)))  ; Enable guide-key-mode


http://www.meteocity.com/france/plage/paimpol_p22162/
;; Package: shortcuts cheatsheet

(use-package cheatsheet
  :config
  (cheatsheet-add-group 'Basics
    '(:key "C-x C-c" :description "close Emacs (kill-emacs to kill daemon)")
    '(:key "C-x C-f" :description "find files (open, or :e)")
    '(:key "C-x C-s" :description "save buffer (or :w)")
    '(:key "C-x k"   :description "save buffers"))
  (cheatsheet-add-group 'Macros
    '(:key "C-x C-(" :description "start record")
    '(:key "C-x C-)" :description "stop record")
    '(:key "C-x C-e" :description "execute"))
  (cheatsheet-add-group 'Windows
    '(:key "C-x C-0" :description "close split"))
  )

TODO: origami
