;; =============================================================================
;; ORG-MODE GTD CONFIGURATION
;; =============================================================================

;; Basic org-mode setup
(require 'org)
(require 'org-agenda)

;; GTD directories
(setq org-directory "~/org/")

;; Create GTD directories if they don't exist
(unless (file-directory-p "~/org/gtd")
  (make-directory "~/org/gtd" t))
(unless (file-directory-p "~/org/gtd/projects")
  (make-directory "~/org/gtd/projects" t))

;; Set agenda files to include all org files in gtd directory and projects subdirectory
(setq org-agenda-files (append (directory-files-recursively "~/org/gtd/" "\\.org$")))

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

;; Agenda views - CONSOLIDATED (no duplicates)
(setq org-agenda-custom-commands
      '(("n" "Next Actions" todo "NEXT")
        ("w" "Waiting For" todo "WAITING")
        ("s" "Someday Maybe" tags "+someday")
        ("c" "Contexts"
         ((tags-todo "@computer")
          (tags-todo "@phone")
          (tags-todo "@research")
          (tags-todo "@errands")))
        ("d" "Recent Accomplishments"
         ((agenda "" ((org-agenda-span 'day)
                     (org-agenda-show-log t)
                     (org-agenda-log-mode-items '(closed))
                     (org-agenda-overriding-header "Today's Completed Items")))
          (agenda "" ((org-agenda-span 'week)
                     (org-agenda-start-day "-6d")
                     (org-agenda-show-log t)
                     (org-agenda-log-mode-items '(closed))
                     (org-agenda-overriding-header "This Week's Completed Items")))))
        ("p" "Projects"
         ((tags "+project" ((org-agenda-overriding-header "Project Headers")))
          (todo "TODO" ((org-agenda-overriding-header "Project TODOs")))
          (todo "NEXT" ((org-agenda-overriding-header "Project NEXT Actions")))
          (todo "WAITING" ((org-agenda-overriding-header "Project WAITING Items")))))
        ("r" "Review"
         ((agenda "" ((org-agenda-span 'day)))
          (todo "NEXT")
          (todo "TODO")
          (todo "WAITING")))))

;; Capture templates - FIXED (no duplicate keys)
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
        ("W" "Weekly Review" entry  ; Changed from "w" to "W" to avoid conflict
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

;; Better logging of accomplishments
(setq org-log-done 'time)
(setq org-log-into-drawer t)  ; Keep logs tidy in a drawer

;; Track when items were closed and notes about completion
;; Note: This conflicts with org-log-done 'time above, choose one:
;; (setq org-log-done 'note)  ; Prompts for a note when marking DONE

;; =============================================================================
;; INTERVIEW PREP TIME MANAGEMENT EXTENSION
;; =============================================================================
;; Add to your existing org-mode GTD configuration

;; Add interview prep to agenda files
(add-to-list 'org-agenda-files "~/org/gtd/interview-prep/")

;; Interview prep specific tags (extends your existing tags)
(setq org-tag-alist 
      (append org-tag-alist
              '((:startgroup)
                ("@system_design" . ?d)
                ("@coding" . ?k) 
                ("@behavioral" . ?b)
                ("@applications" . ?a)
                (:endgroup)
                (:startgroup)
                ("anthropic" . ?A)
                ("roblox" . ?R)
                ("high_comp" . ?H)
                (:endgroup))))

;; Interview prep capture templates (extends your existing templates)
(setq org-capture-templates
      (append org-capture-templates
              '(("i" "Interview Prep")
                ("is" "Study Session" entry 
                 (file+headline "~/org/gtd/interview-prep/tasks.org" "Study Sessions")
                 "* NEXT %^{Topic} :%^{@system_design|@coding|@behavioral}:\n  SCHEDULED: %^t\n  :PROPERTIES:\n  :EFFORT: %^{Duration|1:00|2:00|3:00}\n  :CATEGORY: interview_prep\n  :OBSIDIAN_NOTES: %^{Obsidian Link}\n  :END:\n  %?")
                
                ("ir" "Interview Prep Weekly Review" entry
                 (file+olp+datetree "~/org/gtd/interview-prep/reviews.org")
                 "* Interview Prep Weekly Review - Week %^{Week} (%U)\n** Time Summary (Target: 12 hours)\n*** System Design: __ / 6 hours\n*** Coding: __ / 3 hours\n*** Behavioral: __ / 3 hours\n** Focus This Week:\n- %?\n** Accomplishments:\n- \n** Challenges:\n- \n** Next Week Plan:\n- \n** Application Updates:\n- ")

                ("ia" "Application Task" entry
                 (file+headline "~/org/gtd/interview-prep/applications.org" "Applications")
                 "* TODO %^{Task} - %^{Company}\n  DEADLINE: %^t\n  :PROPERTIES:\n  :COMPANY: %\\2\n  :STATUS: %^{not_applied|applied|phone_screen|onsite|offer|rejected}\n  :END:\n  %?"))))

;; Interview prep agenda views (extends your existing agenda commands)
(setq org-agenda-custom-commands
      (append org-agenda-custom-commands
              '(("I" "Interview Prep Dashboard"
                 ((agenda "" ((org-agenda-files '("~/org/gtd/interview-prep/"))
                             (org-agenda-span 'week)
                             (org-agenda-overriding-header "This Week's Interview Prep")))
                  (todo "NEXT" ((org-agenda-files '("~/org/gtd/interview-prep/"))
                               (org-agenda-overriding-header "Next Study Sessions")))
                  (tags-todo "@system_design|@coding|@behavioral"
                            ((org-agenda-files '("~/org/gtd/interview-prep/"))
                             (org-agenda-overriding-header "Study Tasks by Category")))))
                
                ("T" "Time Tracking Summary" 
                 ((agenda "" ((org-agenda-files '("~/org/gtd/interview-prep/"))
                             (org-agenda-span 'week)
                             (org-agenda-clockreport-mode t)
                             (org-agenda-overriding-header "Interview Prep Time This Week"))))))))

;; Helper function for time tracking
(defun interview-prep-weekly-summary ()
  "Show weekly time summary for interview prep"
  (interactive)
  (let ((org-agenda-files '("~/org/gtd/interview-prep/")))
    (org-clock-sum)
    (message "Interview prep time this week: %s" 
             (org-duration-from-minutes org-clock-file-total-minutes))))

;; Quick access to interview prep dashboard
(global-set-key (kbd "C-c i") (lambda () (interactive) (org-agenda nil "I")))
