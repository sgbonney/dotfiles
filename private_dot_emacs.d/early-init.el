(defun setup-environment-paths ()
  (cond
   ((string-equal system-type "gnu/linux")
    (setenv "PATH" (concat "/home/linuxbrew/.linuxbrew/bin:" (getenv "PATH")))
    (add-to-list 'exec-path "/home/linuxbrew/.linuxbrew/bin"))

   ((string-equal system-type "android")
    (let ((termux-bin "/data/data/com.termux/files/usr/bin")
          (ssh-sock "/data/data/com.termux/files/home/.ssh/ssh-agent.sock"))
      (setenv "PATH" (format "%s:%s" termux-bin (getenv "PATH")))
      (add-to-list 'exec-path termux-bin)
      (setenv "SSH_AUTH_SOCK" ssh-sock)))))

(setup-environment-paths)
