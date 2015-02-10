(in-package :stumpwm)

(add-to-load-path "~/.stumpwm.d/contrib/modeline/net")
(add-to-load-path "~/.stumpwm.d/contrib/modeline/cpu")
(add-to-load-path "~/.stumpwm.d/contrib/modeline/disk")
(add-to-load-path "~/.stumpwm.d/contrib/modeline/mem")

(load-module "net")
(load-module "cpu")
(load-module "disk")
(load-module "mem")

(when (string= "bluebook" (short-site-name))
  (add-to-load-path "~/.stumpwm.d/contrib/modeline/battery")
  (add-to-load-path "~/.stumpwm.d/contrib/modeline/wifi")
  (load-module "battery")
  (load-module "wifi"))

;;(add-to-load-path "~/.stumpwm.d/contrib/util/stumptray")
;;(load-module "stumptray")

(setf *screen-mode-line-format* "[%n] %W |  %l | %c | %t")
(setf *mode-line-position* :bottom)
(setf *window-border-style* :THIN)

(set-win-bg-color "black")
(set-focus-color "red")
(set-unfocus-color "grey")

(toggle-mode-line (current-screen) (current-head))

(define-key *root-map* (kbd "C-l") "exec xlock")
(define-key *root-map* (kbd "c") "exec xterm -ls")
(define-key *root-map* (kbd "C-s") "ssh-to-host")

(defcommand ssh-to-host (host)
  ((:string "Host: "))
  (run-shell-command (format nil "xterm -e ssh ~a" host)))
