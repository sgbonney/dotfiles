#!/bin/bash

emacsclient -e '(restart-emacs)'
systemctl --user restart emacs.service
