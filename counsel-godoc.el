;;; counsel-godoc.el --- godoc with ivy interface -*- lexical-binding: t; -*-

;; Copyright (C) 2016 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-counsel-godoc
;; Package-Requires: ((emacs "24.1") (cl-lib "0.5") (swiper "0.4.0") (go-mode "1"))
;; Version: 0.01

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'go-mode)
(require 'cl-lib)
(require 'swiper)

(defun counsel-godoc--packages ()
  (cl-loop for package in (go-packages)
           unless (string-match-p "/Godeps/" package)
           collect (cons package package)))

(defun counsel-godoc--show-document (package)
  (let ((buf (get-buffer-create (format "*godoc %s*" package))))
    (with-current-buffer buf
      (view-mode -1)
      (erase-buffer)
      (unless (zerop (process-file "godoc" nil t nil package))
        (error "Faild: 'godoc %s'" package))
      (view-mode +1)
      (goto-char (point-min))
      (pop-to-buffer (current-buffer)))))

;;;###autoload
(defun counsel-godoc ()
  "Show document of installed go package"
  (interactive)
  (ivy-read "Bindings: " (counsel-godoc--packages)
            :action #'counsel-godoc--show-document
            :caller 'counsel-godoc))

(provide 'counsel-godoc)

;;; counsel-godoc.el ends here
