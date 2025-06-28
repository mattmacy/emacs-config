;; =============================================================================
;; ORG-MODE GTD CONFIGURATION
;; =============================================================================

;; Basic org-mode setup
(require 'org)
(require 'org-agenda)

;; GTD directories
(setq org-directory "~/org/")
(setq org-agenda-files '("~/org/gtd/"
			 "~/org/gtd/projects"))


;; Create GTD directories if they don't exist
(unless (file-directory-p "~/org/gtd")
  (make-directory "~/org/gtd" t))

;; Basic GTD file structure
(setq org-default-notes-file "~/org/gtd/inbox.org")

;; TODO keywords
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "HOLD(h@/!)" 
                  "|" "DONE(d!)" "CANCELLED(c@/!)")))

;; TODO keyword faces (colors)
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "red" :weight bold))
        ("NEXT" . (:foreground "blue" :weight bold))
        ("WAITING" . (:foreground "orange" :weight bold))
        ("HOLD" . (:foreground "magenta" :weight bold))
        ("DONE" . (:foreground "forest green" :weight bold))
        ("CANCELLED" . (:foreground "forest green" :weight bold))))

;; Tags for GTD contexts
(setq org-tag-alist '((:startgroup)
                      ("@computer" . ?c)
                      ("@phone" . ?p)
                      ("@research" . ?r)
                      ("@errands" . ?e)
                      ("@home" . ?h)
                      ("@office" . ?o)
                      (:endgroup)
                      (:startgroup)
                      ("project" . ?P)
                      ("waiting" . ?w)
                      ("someday" . ?s)
                      (:endgroup)))

;; Agenda views
(setq org-agenda-custom-commands
      '(("n" "Next Actions" todo "NEXT")
        ("w" "Waiting For" todo "WAITING")
        ("p" "Projects" tags "+project")
        ("s" "Someday Maybe" tags "+someday")
        ("c" "Contexts"
         ((tags-todo "@computer")
          (tags-todo "@phone")
          (tags-todo "@research")
          (tags-todo "@errands")))
	("d" "Recent Accomplishments"
	 ((agenda "" ((org-agenda-span 'week)
		      (org-agenda-start-day "-7d")        ; Start 6 days ago
		      (org-agenda-show-log t)
		      (org-agenda-log-mode-items '(closed))
		      (org-agenda-overriding-header "This Week's Completed Items")))
	  (agenda "" ((org-agenda-span 'day)
		      (org-agenda-show-log t) 
		      (org-agenda-log-mode-items '(closed))
		      (org-agenda-overriding-header "Today's Completed Items")))))
        ("r" "Review"
         ((agenda "" ((org-agenda-span 'day)))
          (todo "NEXT")
          (todo "WAITING")))))

;; Capture templates
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd/inbox.org" "Inbox")
         "* TODO %?\n  CREATED: %U")
        ("n" "Next Action" entry (file+headline "~/org/gtd/inbox.org" "Inbox")
         "* NEXT %? :next:\n  CREATED: %U")
        ("p" "Project" entry (file+headline "~/org/gtd/projects.org" "Projects")
         "* %? :project:\n  CREATED: %U\n** Outcome\n** Next Actions")
        ("w" "Waiting" entry (file+headline "~/org/gtd/inbox.org" "Inbox")
         "* WAITING %? :waiting:\n  CREATED: %U")
	("d" "Daily Review" entry 
         (file+olp+datetree "~/org/gtd/reviews.org")
         "* Daily Review %U\n** Accomplished\n- %?\n** Learned\n- \n** Tomorrow's Focus\n- ")
        
        ("w" "Weekly Review" entry
         (file+olp+datetree "~/org/gtd/reviews.org")
         "* Weekly Review %U\n** Major Accomplishments\n- %?\n** Key Learnings\n- \n** Next Week's Priorities\n- \n** Challenges & Solutions\n- ")
        ("s" "Someday" entry (file+headline "~/org/gtd/someday.org" "Someday Maybe")
         "* SOMEDAY %? :someday:\n  CREATED: %U")))

;; Key bindings
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)

;; Agenda settings
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-show-all-dates t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-start-with-log-mode t)


(setq org-agenda-custom-commands
      (append org-agenda-custom-commands
              '(("a" "Accomplishments Review"
                 ((agenda "" ((org-agenda-span 'day)
                             (org-agenda-show-log t)
                             (org-agenda-log-mode-items '(closed))))
                  (agenda "" ((org-agenda-span 'week)
                             (org-agenda-show-log t)
                             (org-agenda-log-mode-items '(closed))))))
                
                ("A" "This Week's Done Items" 
                 ((agenda "" ((org-agenda-span 'week)
                             (org-agenda-show-log t)
                             (org-agenda-log-mode-items '(closed))
                             (org-agenda-skip-function 
                              '(org-agenda-skip-entry-if 'nottodo 'done)))))))))
;; Better logging of accomplishments
(setq org-log-done 'time)
(setq org-log-into-drawer t)  ; Keep logs tidy in a drawer

;; Track when items were closed and notes about completion
(setq org-log-done 'note)  ; Prompts for a note when marking DONE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; =============================================================================
;; ORG-ROAM + GTD INTEGRATION
;; =============================================================================

;; Install org-roam if not already installed
(unless (package-installed-p 'org-roam)
  (package-install 'org-roam))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/org/roam/")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture))
  :config
  (org-roam-setup))

;; Create roam directory if it doesn't exist
(unless (file-directory-p "~/org/roam")
  (make-directory "~/org/roam" t))

;; GTD + Roam capture templates
(setq org-roam-capture-templates
      '(("d" "default" plain
         "* Overview\n\n* Details\n\n* Related\n\n"
         :target (file+head "${slug}.org" "#+title: ${title}\n#+date: %U\n")
         :unnarrowed t)
        
        ("p" "project" plain
         "* Outcome\n%?\n* Success Criteria\n\n* Next Actions\n** TODO \n\n* Resources\n\n* Notes\n\n"
         :target (file+head "projects/${slug}.org" 
                            "#+title: ${title}\n#+date: %U\n#+filetags: :project:\n")
         :unnarrowed t)

        ("a" "accomplishment" plain
         "* What I Did\n%?\n\n* Impact\n\n* Skills Used\n\n* What I Learned\n\n* Related Projects\n\n"
         :target (file+head "daily/%<%Y-%m-%d>-accomplishments.org"
                            "#+title: %<%Y-%m-%d> Accomplishments\n#+date: %U\n#+filetags: :accomplishment:\n")
         :unnarrowed t)
        
        ("f" "reflection" plain
         "* This Week's Wins\n%?\n\n* Challenges Overcome\n\n* Key Insights\n\n* Growth Areas\n\n* Next Week's Focus\n\n"
         :target (file+head "weekly/%<%Y-W%U>-reflection.org"
                            "#+title: Week %<%U, %Y> Reflection\n#+date: %U\n#+filetags: :reflection:\n")
         :unnarrowed t)

        ("r" "reference" plain
         "* Summary\n\n* Key Points\n%?\n\n* Applications\n\n* Related\n\n"
         :target (file+head "references/${slug}.org"
                           "#+title: ${title}\n#+date: %U\n#+filetags: :reference:\n")
         :unnarrowed t)))

;; Link GTD projects to roam notes
(defun my/org-roam-project-finalize-hook ()
  "Adds the captured project file to `org-agenda-files' if the
capture was not aborted."
  (remove-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)
  (unless org-note-abort
    (with-current-buffer (org-capture-get :buffer)
      (add-to-list 'org-agenda-files (buffer-file-name)))))

(defun my/org-roam-find-project ()
  "Find and open an org-roam project."
  (interactive)
  (add-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)
  (org-roam-capture- :templates
                     '(("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
                        :if-new (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
                                               "#+title: ${title}\n#+category: ${title}\n#+filetags: Project")
                        :unnarrowed t))))

;; Key binding for project creation
(global-set-key (kbd "C-c n p") 'my/org-roam-find-project)
