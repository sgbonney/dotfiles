(setq warning-minimum-level :emergency)

(setq inhibit-startup-screen t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

(setq overriding-text-conversion-style nil
      touch-screen-display-keyboard t)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(global-visual-line-mode 1)

(use-package package
  :config
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/"))
  (package-initialize))

(use-package use-package
  :custom
  (use-package-always-ensure t)
  (package-native-compile t)
  (warning-minimum-level :emergency))

(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))
(require 'vc-use-package)

(with-eval-after-load 'org
  (add-to-list 'org-modules 'org-habit t))

(global-set-key (kbd "<volume-up>") 'nov-scroll-down)
(global-set-key (kbd "<volume-down>") 'nov-scroll-up)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-crp" 'eradio-play)
(global-set-key "\C-crs" 'eradio-stop)
(global-set-key "\C-crt" 'eradio-toggle)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-custom-commands
   '(("H" "Habits"
      ((agenda ""
	       ((org-agenda-span 'day)))
       (todo "H" nil))
      nil)))
 '(org-babel-load-languages '((emacs-lisp . t) (plantuml . t) (python . t) (shell . t)))
 '(org-log-into-drawer t)
 '(org-refile-allow-creating-parent-nodes 'confirm)
 '(org-refile-targets '((org-agenda-files :tag . ":maxlevel . 2")))
 '(org-refile-use-outline-path 'file)
 '(safe-local-variable-values '((org-duration-format . h:mm) (org-log-done . time))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq org-agenda-files nil)

(defun refresh-org-agenda-files ()
  "Refresh the list of Org agenda files."
  (interactive)
  (setq org-agenda-files
        (directory-files-recursively
         "~/Documents"
         ".*_agenda.*\\.org$"))
  (message "Org agenda files refreshed."))

(refresh-org-agenda-files)

(setq org-todo-keywords
      '((sequence "ACTIVITY(a)" "NEXT(n)" "PROJECT(p)" "SOMEDAY(s)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))

(setq org-agenda-prefix-format '((agenda . " %i %?-12t% s")
				 (timeline . "  % s")
				 (todo . " %i %-12:c")
				 (tags . " %i %-12:c")
				 (search . " %i %-12:c")))

(setq org-capture-templates
      '(("i" "Inbox" entry
         (file+headline "~/Documents/system/inbox.org" "Inbox")
         "* I %<%Y%m%d%H%M%S>\n %?\n")
        ("f" "Fuel" entry
         (file+headline "~/Documents/system/fuel.org" "Fuel")
         "* %?\n:PROPERTIES:\n:CUSTOM_ID: my-task-id\n:END:\n  %i\n  %a")
        ("h" "HPC hours" entry
         (file "~/Documents/system/hpc_hours.org")
         "* %^{Tax year (YY/YY)}w%^{Pay cycle (WW)}\n\n** ACTIVITY Work at HPC\nSCHEDULED: <%<%Y-%m-%d %a 18:30>>--<%<%Y-%m-%d %a 06:00>>\n\n%?# Amend SCHEDULED end date then use C-c C-x c
(org-clone-subtree-with-time-shift)"
	 :prepend t)
	("b" "Add book to read" entry
	 (file+headline "~/Documents/books-test.org" "Books to read")
	 (file "~/Documents/tpl-book.org")
	 :empty-lines-after 2)))

(use-package modus-themes
  :custom
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs t)
  (modus-themes-mixed-fonts t)
  (modus-themes-to-toggle
   '(modus-operandi-tinted modus-vivendi-tinted))
  :init
  (load-theme 'modus-vivendi-tinted :no-confirm))

(use-package god-mode
  :init
  (setq god-mode-enable-function-key-translation nil)
  :bind
  (("C-." . god-local-mode)
   ("C-x C-1" . delete-other-windows)
   ("C-x C-2" . split-window-below)
   ("C-x C-3" . split-window-right)
   ("C-x C-0" . delete-window)
   :map god-local-mode-map
   ("z" . repeat)
   ("[" . backward-paragraph)
   ("]" . forward-paragraph))
  :config
  (defun my-god-mode-update-cursor ()
    (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar))
    (if (or god-local-mode)
	(blink-cursor-mode -1)
      (blink-cursor-mode 1)))

  (add-hook 'post-command-hook #'my-god-mode-update-cursor)

  (defun my-god-mode-update-mode-line ()
    (cond
     (god-local-mode
      (set-face-attribute 'mode-line nil
                          :foreground "#604000"
                          :background "#fff29a")
      (set-face-attribute 'mode-line-inactive nil
                          :foreground "#3f3000"
                          :background "#fff3da"))
     (t
      (set-face-attribute 'mode-line nil
  			  :foreground "#0a0a0a"
  			  :background "#d7d7d7")
      (set-face-attribute 'mode-line-inactive nil
  			  :foreground "#404148"
  			  :background "#efefef"))))

  (add-hook 'post-command-hook #'my-god-mode-update-mode-line))

(use-package key-chord
  :init
  (key-chord-mode 1)
  :config
  (key-chord-define-global ".." 'god-local-mode))

(use-package devil
  :init
  (global-devil-mode)
  :config
  (setq devil-all-keys-repeatable t))

(use-package org
  :bind (:map org-mode-map
              ("C-'" . nil)
	      ("C-," . nil)))

(use-package avy)
(global-set-key (kbd "C-:") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g s") 'avy-goto-char-timer)
(global-set-key (kbd "M-g f") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)

(use-package hide-mode-line
  :config
  (add-hook 'completion-list-mode-hook #'hide-mode-line-mode)
  (add-hook 'nov-mode-hook #'hide-mode-line-mode))

(use-package org-web-tools)

(use-package magit)

(use-package yasnippet
  :config
  (use-package yasnippet-snippets)
  (yas-global-mode t)
  (setq yas-snippet-dirs
        '("~/Documents/system/templates/snippets/"))
  (yas-reload-all))

(use-package el-patch)

(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :after vertico
  :bind
  (:map minibuffer-local-map
   ("M-A" . marginalia-cycle))
  :config
  (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult)

(use-package denote
  :config
  (setq denote-directory "~/Documents")
  (add-hook 'dired-mode-hook 'denote-dired-mode)
  (require 'denote-journal-extras)
  (setq denote-journal-extras-title-format 'day-date-month-year))

;; type '<m' followed by TAB
(require 'org-tempo)
(add-to-list 'org-structure-template-alist
	     '("m" . "src emacs-lisp"))

(use-package consult-notes
  :commands (consult-notes
             consult-notes-search-in-all-notes
             ;; if using org-roam 
             consult-notes-org-roam-find-node
             consult-notes-org-roam-find-node-relation)
  :config
;  (setq consult-notes-file-dir-sources
  ;; Set org-roam integration, denote integration, or org-heading integration e.g.:
;	("Denote Notes"  ?d ,(denote-directory))
;        ("Books"  ?b "~/Ebooks")))
;  (setq consult-notes-org-headings-files '("~/path/to/file1.org"
;                                           "~/path/to/file2.org"))
;  (consult-notes-org-headings-mode)
  (when (locate-library "denote")
    (consult-notes-denote-mode))
;  ;; search only for text files in denote dir
;  (setq consult-notes-denote-files-function (function denote-directory-text-only-files))
  :bind (("C-c n f" . consult-notes)))

(use-package dictionary
  :bind
  ("M-#" . dictionary-lookup-definition))

;;(use-package emacs
  ;;:bind
  ;;([remap capitalize-word] . capitalize-dwim)
  ;;([remap downcase-word] . downcase-dwim)
  ;;([remap upcase-word] . upcase-dwim))

(use-package biblio)

(use-package citar
  :defer t
  :custom
  (citar-bibliography '("~/Documents/system/books.bib"))
  (citar-library-paths '("~/Audiobooks"
			 "~/Ebooks"))
  :config
  (setq citar-templates
      '((main . "${title:48}     ${author editor:30%sn}     ${date year issued:4}")
        (suffix . "          ${=key= id:15}    ${=type=:12}    ${tags keywords:*}")
        (preview . "${author editor:%etal} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
        (note . "Notes on ${author editor:%etal}, ${title}")))
  :bind
  (("C-c w b o" . citar-open)))

(use-package citar-denote
  :custom
  (citar-open-always-create-notes t)
  :init
  (citar-denote-mode)
  :bind
  (("C-c w b c" . citar-create-note)
   ("C-c w b n" . citar-denote-open-note)
   ("C-c w b x" . citar-denote-nocite)
   :map org-mode-map
   ("C-c w b k" . citar-denote-add-citekey)
   ("C-c w b K" . citar-denote-remove-citekey)
   ("C-c w b d" . citar-denote-dwim)
   ("C-c w b e" . citar-denote-open-reference-entry)))

(use-package eradio
  :init
  (setq eradio-player '("mpv" "--no-video" "--no-terminal"))
  :config
  (setq eradio-channels
        (with-temp-buffer
          (insert-file-contents "~/Documents/system/radio_stations.org")
          (goto-char (point-min))
          (let (channels)
            (while (re-search-forward "^\\*\\* \\(.*\\)$" nil t)
              (let ((station-name (match-string 1))
                    (url (save-excursion
                           (re-search-forward ":URL: \\(.*\\)$")
                           (match-string 1))))
                (push (cons station-name url) channels)))
            (nreverse channels)))
  ))

(use-package elfeed-tube
  :ensure t
  :after elfeed
  :demand t
  :config
  ;; (setq elfeed-tube-auto-save-p nil) ; default value
  ;; (setq elfeed-tube-auto-fetch-p t)  ; default value
  (elfeed-tube-setup)

  :bind (:map elfeed-show-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)
         :map elfeed-search-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)))

(use-package titlecase
  :defer t)

(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("j" "journal" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-%<%Y_%m_%d>_journal.org" "#+title: %<%Y-%m-%d> journal\n#+date: %U\n")
      :unnarrowed t)
     ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
      :unnarrowed t)
     ("g" "diagram" plain (file "~/Documents/system/templates/org_roam/plantuml_digraph_template.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}_diagram.org" "#+title: ${title} diagram\n")
      :unnarrowed t)
     ("t" "quote" plain (file "~/Documents/system/templates/org_roam/quote_template.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)))
  :bind (("C-c n l" . org-roam-buffer-toggle)
;;         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i"   . completion-at-point))
  :config
  (org-roam-setup))
(setq org-roam-node-display-template
      (concat "${title:*} "
              (propertize "${tags:10}" 'face 'org-tag)))

(use-package ob-yaml
  :vc (ob-yaml :url "https://github.com/llhotka/ob-yaml"
		       :branch "main"))

(use-package nov
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  :hook ((nov-mode . (lambda ()
                       (display-line-numbers-mode -1)))  ; Disable line numbers in nov mode
         (nov-mode-hook . (lambda ()
                            (make-local-variable 'my-line-numbers-enabled)
                            (setq my-line-numbers-enabled nil))))
  :config
  (display-line-numbers-mode 0))

;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))
(setq org-plantuml-jar-path
      (expand-file-name "~/plantuml.jar"))

(use-package f)

(use-package org-multi-clock
  :vc (org-multi-clock :url "https://gitlab.com/OlMon/org-multi-clock"
		       :branch "master"))

(defun my/extract-pins-from-org ()
  "Extract pins from the specified Org file and display them in a temporary buffer."
  (interactive)
  (let ((org-file-path "~/Documents/system/pin_boards/.pin_board_org_html.org"))  ;; Specify your Org file path here
    (if (file-exists-p org-file-path)
        (progn
          (org-babel-load-file org-file-path)
          (message "Pins extracted successfully."))
      (error "Org file not found: %s" org-file-path))))

(defun search-youtube-from-org ()
  "Search for the song in the current Org mode heading on YouTube."
  (interactive)
  (when (org-at-heading-p)
    (let* ((title (org-get-heading t t t t))
           (artist (or (org-entry-get (point) "ARTIST") "Unknown Artist"))
           (query (concat title " " artist))
           (encoded-query (url-hexify-string query))
           (url (concat "https://www.youtube.com/results?search_query=" encoded-query)))
      (browse-url url)
      (message "Searching for: %s" query))))

(defun org-fetch-xcweather-forecast ()
  "Fetch XCWeather forecast for the postcode found in the Org heading at point."
  (interactive)
  (when (org-at-heading-p)
    (let* ((heading (org-get-heading t t t t))
           (postcode (org-entry-get (point) "POSTCODE")))
      (if postcode
          (progn
            (setq postcode (downcase postcode))  ;; Make postcode lowercase
            (let ((url (concat "https://www.xcweather.co.uk/forecast/" (replace-regexp-in-string " " "_" postcode))))
              (message "Fetching XCWeather forecast for postcode: %s" postcode)
              (browse-url url)))  ;; Open the URL in the browser
        (message "No postcode found in the properties.")))))

;; org-roam-filter-entries.el

;;; 0. Variables
;;  --------------------------------------------------
(defcustom org-roam-filter-by-entries '("4-archives")
  "Entries (tags or directories) to be excluded for Org-roam node filtering."
  :type '(repeat string)
  :group 'org-roam)
;;  ---

;;; 1. Helper Functions
;;  --------------------------------------------------

;; Helper function to filter org-roam-node by entries (tags or directories).
(defun custom/org-roam-node--filter-by-entries (node &optional included-entries excluded-entries)
  "Filter org-roam-node by entries (tags or directories)."
  (let* ((entries (append (org-roam-node-tags node)
                          (butlast (f-split (f-relative (org-roam-node-file node) org-roam-directory)))))
         (included (and included-entries (not (seq-some (lambda (entry) (member entry entries)) included-entries))))
         (excluded (and excluded-entries (seq-some (lambda (entry) (member entry entries)) excluded-entries))))
    (if (or included excluded)
        nil t)))

;; Helper function to filter org-roam-node to show only nodes with entries in `org-roam-filter-by-entries`.
(defun custom/org-roam-node--filter-excluded (node)
  "Filter org-roam-node to show only nodes with entries in `org-roam-filter-by-entries`."
  (custom/org-roam-node--filter-by-entries node nil org-roam-filter-by-entries))
;;  ---

;;; 2. Find Functions
;;  --------------------------------------------------

;; Modded org-roam-node-find which filters nodes using entries (tags or directories).
(defun custom/org-roam-node-find ()
  "Show Org-roam nodes, filtering by entries (tags or directories)."
  (interactive)
  (org-roam-node-find nil nil
                      (lambda (node) (custom/org-roam-node--filter-by-entries node nil org-roam-filter-by-entries))))

;; Show only Org-roam nodes that match entries in `org-roam-filter-by-entries`.
(defun custom/org-roam-node-find-only ()
  "Show only Org-roam nodes that match entries in `org-roam-filter-by-entries`."
  (interactive)
  (org-roam-node-find nil nil (lambda (node) (not (custom/org-roam-node--filter-excluded node)))))

(defun custom/org-roam-node-find-entry (&optional new-entries)
  "Show only Org-roam nodes matching the specified entries interactively.
If NEW-ENTRIES are provided, use them as the entries to match by (seperate entries by ,).
Otherwise, prompt the user to select from existing entries."
  (interactive)
  (if new-entries
      (let ((org-roam-filter-by-entries new-entries))
        (custom/org-roam-node-find-only))
    (let ((selected-entries (completing-read-multiple "Select entries to filter by (seperate by ,): " org-roam-filter-by-entries)))
      (let ((org-roam-filter-by-entries selected-entries))
        (custom/org-roam-node-find-only)))))

;; Perform find actions on Org-roam nodes based on the prefix argument.
(defun custom/org-roam-node-find-actions (arg)
  "Perform find actions on Org-roam nodes.

With no prefix argument, this function invokes `org-roam-node-find`,
to find nodes from the unfiltered list

With a prefix argument of C-u 1, it calls `custom/org-roam-node-find`,
to find Org-roam nodes from a filtered list excluding entries specified in `org-roam-filter-by-entries`

With a prefix argument of C-u 2, it calls `custom/org-roam-node-find-only`,
to find only nodes that match entries specified in `org-roam-filter-by-entries`.

With a prefix argument of C-u 3, it calls `custom/org-roam-node-find-entry`
allowing the user to interactively choose entries or specify on-the-fly new ones (seperated by ,) and to find nodes matching the entries.
"
  (interactive "P")
  (let ((numeric-arg (prefix-numeric-value arg)))
    (cond
     ((null arg) (org-roam-node-find))
     ((= numeric-arg 1) (custom/org-roam-node-find))
     ((= numeric-arg 2) (custom/org-roam-node-find-only))
     ((= numeric-arg 3) (custom/org-roam-node-find-entry))
     (t (custom/org-roam-node-find)))))
;;  ---

;;; 3. Input Functions
;;  --------------------------------------------------

;; Modded org-roam-node-insert which filters nodes using entries (tags or directories).
(defun custom/org-roam-node-insert ()
  "Insert Org-roam node, filtering by entries (tags or directories)."
  (interactive)
  (org-roam-node-insert
   (lambda (node) (custom/org-roam-node--filter-by-entries node nil org-roam-filter-by-entries))))

;; Show only Org-roam nodes that have entries in `org-roam-filter-by-entries`.
(defun custom/org-roam-node-insert-only ()
  "Insert Org-roam node, showing only nodes that match entries in `org-roam-filter-by-entries`."
  (interactive)
  (org-roam-node-insert (lambda (node) (not (custom/org-roam-node--filter-excluded node)))))

(defun custom/org-roam-node-insert-entry (&optional new-entries)
  "Insert Org-roam node, showing only nodes matching the specified entries interactively.
If NEW-ENTRIES are provided, use them as the entries to match by (seperate entries by ,).
Otherwise, prompt the user to select from existing entries."
  (interactive)
  (if new-entries
      (let ((org-roam-filter-by-entries new-entries))
        (custom/org-roam-node-insert-only))
    (let ((selected-entries (completing-read-multiple "Select entries to filter by (seperate by ,): " org-roam-filter-by-entries)))
      (let ((org-roam-filter-by-entries selected-entries))
        (custom/org-roam-node-insert-only)))))

;; Perform actions on Org-roam nodes during insertion based on the prefix argument.
(defun custom/org-roam-node-insert-actions (arg)
  "Perform insert actions on Org-roam nodes.

With no prefix argument, this function invokes `org-roam-node-insert`,
to insert nodes from the unfiltered list

With a prefix argument of C-u 1, it calls `custom/org-roam-node-insert`,
to insert Org-roam nodes from a filtered list excluding entries specified in `org-roam-filter-by-entries`

With a prefix argument of C-u 2, it calls `custom/org-roam-node-insert-only`,
to insert only nodes that match entries specified in `org-roam-filter-by-entries`.

With a prefix argument of C-u 3, it calls `custom/org-roam-node-insert-entry`
allowing the user to interactively choose entries or specify on-the-fly new ones (seperated by ,) and to insert from nodes matching the entries.
"
  (interactive "P")
  (let ((numeric-arg (prefix-numeric-value arg)))
    (cond
     ((null arg) (org-roam-node-insert))
     ((= numeric-arg 1) (custom/org-roam-node-insert))
     ((= numeric-arg 2) (custom/org-roam-node-insert-only))
     ((= numeric-arg 3) (custom/org-roam-node-insert-entry)) 
     (t (custom/org-roam-node-insert)))))
;;  ---

;; Key bindings
(global-set-key (kbd "C-c f a") #'custom/org-roam-node-find-actions)
(global-set-key (kbd "C-c f i") #'custom/org-roam-node-insert-actions)
(global-set-key (kbd "C-c f f") #'custom/org-roam-node-find)

(provide 'org-roam-filter-entries)
