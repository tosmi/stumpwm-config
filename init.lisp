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
(setf *message-window-gravity* :center)
(setf *input-window-gravity* :center)

(setf *mouse-focus-policy* :sloppy) ;; :click, :ignore, :sloppy

(set-win-bg-color "black")
(set-focus-color "red")
(set-unfocus-color "grey")

(toggle-mode-line (current-screen) (current-head))

(defcommand ssh-to-host (host) ((:string "Host: "))
	    "Run ssh to connect to a remote host."
	    (run-shell-command (format nil "xterm -e ssh ~a" host)))

(defcommand firefox () ()
	    "Start firefox unless it is already running, in which case focus it."
	    (run-or-raise "firefox" '(:class "Firefox")))

(defun global-window-names ()
  "Returns a list of the names of all the windows in the current screen."
  (let ((groups (sort-groups (current-screen)))
	(windows nil))
    (dolist (group groups)
      (dolist (window (group-windows group))
	;; Don't include the current window in the list
	(when (not (eq window (current-window)))
	  (setq windows (cons (window-name window) windows)))))
    windows))

(defun my-window-in-group (query group)
  "Returns a window matching QUERY in GROUP."
  (let ((match nil)
	(end nil)
	(name nil))
    (dolist (window (group-windows group))
      (setq name (window-name window)
	    end (min (length name) (length query)))
      ;; Never match the current window
      (when (and (string-equal name query :end1 end :end2 end)
		 (not (eq window (current-window))))
	(setq match window)
	(return)))
    match))

(define-stumpwm-type :my-global-window-names (input prompt)
  (or (argument-pop input)
      (completing-read (current-screen) prompt (my-global-window-names))))

(defcommand global-windowlist () (:rest)
  "Like select, but for all groups not just the current one."
  (let ((window-list (global-window-names)))
    (if (null window-list)
	(message "No Managed Windows")
	(let ((window (select-window-from-menu window-list nil)))
	  (message window-list)))))


    ;; (dolist (group (screen-groups (current-screen)))
    ;;   (setq window (my-window-in-group query group))
    ;;   (when window
    ;; 	(switch-to-group group)
    ;; 	(frame-raise-window group (window-frame window) window)
    ;; 	(return)))))

(define-key *root-map* (kbd "C-l") "exec xlock")
(define-key *root-map* (kbd "c") "exec xterm -ls")
(define-key *root-map* (kbd "C-s") "ssh-to-host")
(define-key *root-map* (kbd "C-f") "firefox")
(define-key *root-map* (kbd "RET") "fullscreen")

(define-key *root-map* (kbd "w") "windowlist")
(define-key *root-map* (kbd "W") "grouplist")
(define-key *root-map* (kbd "\"") "windows")
