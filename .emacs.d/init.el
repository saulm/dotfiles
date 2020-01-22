;;Package Management

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))

;;Appeareance
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(set-mouse-color "white") 
(setq inhibit-startup-message t)
(setq-default indent-tabs-mode nil)
;;Ido Mode enabled by default
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1) 

(add-to-list 'load-path "~/.emacs.d/elpa/neotree-0.2.1/") 
(require 'neotree)
(global-set-key (kbd "M-s") 'neotree-toggle)

;;Ruby
(add-to-list 'load-path "~/.emacs.d/elpa/ruby-tools-0.1.2/") 
(require 'ruby-tools)

;;File Search
(add-to-list 'load-path "~/.emacs.d/elpa/ag-0.44/") 
(require 'ag)
(global-set-key (kbd "C-h") 'ag-project)
;;Html edition
(add-to-list 'load-path "~/.emacs.d/elpa/web-mode-9/") 
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(require 'ruby-mode)
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))

;;Global Navigation

(global-set-key (kbd "M-<left>")  'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<up>")    'windmove-up)
(global-set-key (kbd "M-<down>")  'windmove-down)

(add-to-list 'load-path "~/.emacs.d/elpa/editorconfig-20150101.1704/") 
(require 'editorconfig)
(load "editorconfig")


(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-safe-themes
   (quote
    ("83faf27892c7119f6016e3609f346d3dae3516dede8fd8a5940373d98f615b4e" "e0c66085db350558f90f676e5a51c825cb1e0622020eeda6c573b07cb8d44be5" default)))
 '(describe-char-unidata-list
   (quote
    (name old-name general-category canonical-combining-class bidi-class decomposition decimal-digit-value digit-value numeric-value mirrored iso-10646-comment uppercase lowercase titlecase)))
 '(js2-basic-offset 2)
 '(package-selected-packages
   (quote
    (aggressive-indent tide rjsx-mode labburn-theme ws-butler web-mode ruby-tools rspec-mode neotree markdown-mode haml-mode flymake-haml editorconfig ag))))

(add-to-list 'load-path "~/.emacs.d/elpa/haml-mode-20150508.2011/")
(require 'haml-mode)

(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.haml\\'" . haml-mode))

(show-paren-mode 1)

(add-to-list 'load-path "~/.emacs.d/elpa/ws-butler-20150126.759/")
(require 'ws-butler)
(add-hook 'ruby-mode-hook 'ws-butler-mode)

(setq column-number-mode t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(add-to-list 'load-path "~/.emacs.d/xresources-theme.el")
(when (display-graphic-p)
  (load-theme 'xresources)
)

(add-to-list 'default-frame-alist '(font . "Hack"))
(set-face-attribute 'default nil
            :family "Hack")

(global-linum-mode t)

;;Replace all freakin' ^M chars in the current buffer
(fset 'replace-ctrlms
   [escape ?< escape ?% ?\C-q ?\C-m return ?\C-q ?\C-j return ?!])
(global-set-key "\C-cm" 'replace-ctrlms)

(add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2)))
(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

(defun xah-open-file-at-cursor ()
  "Open the file path under cursor.
If there is text selection, uses the text selection for path.
If the path starts with “http://”, open the URL in browser.
Input path can be {relative, full path, URL}.
Path may have a trailing “:‹n›” that indicates line number. If so, jump to that line number.
If path does not have a file extension, automatically try with “.el” for elisp files.
This command is similar to `find-file-at-point' but without prompting for confirmation.

URL `http://ergoemacs.org/emacs/emacs_open_file_path_fast.html'
Version 2019-01-16"
  (interactive)
  (let* (($inputStr (if (use-region-p)
                        (buffer-substring-no-properties (region-beginning) (region-end))
                      (let ($p0 $p1 $p2
                                ;; chars that are likely to be delimiters of file path or url, e.g. whitespace, comma. The colon is a problem. cuz it's in url, but not in file name. Don't want to use just space as delimiter because path or url are often in brackets or quotes as in markdown or html
                                ($pathStops "^  \t\n\"`'‘’“”|[]{}「」<>〔〕〈〉《》【】〖〗«»‹›❮❯❬❭〘〙·。\\"))
                        (setq $p0 (point))
                        (skip-chars-backward $pathStops)
                        (setq $p1 (point))
                        (goto-char $p0)
                        (skip-chars-forward $pathStops)
                        (setq $p2 (point))
                        (goto-char $p0)
                        (buffer-substring-no-properties $p1 $p2))))
         ($path
          (replace-regexp-in-string
           "^file:///" "/"
           (replace-regexp-in-string
            ":\\'" "" $inputStr))))
    (if (string-match-p "\\`https?://" $path)
        (if (fboundp 'xahsite-url-to-filepath)
            (let (($x (xahsite-url-to-filepath $path)))
              (if (string-match "^http" $x )
                  (browse-url $x)
                (find-file $x)))
          (progn (browse-url $path)))
      (if ; not starting “http://”
          (string-match "^\\`\\(.+?\\):\\([0-9]+\\)\\'" $path)
          (let (
                ($fpath (match-string 1 $path))
                ($line-num (string-to-number (match-string 2 $path))))
            (if (file-exists-p $fpath)
                (progn
                  (find-file $fpath)
                  (goto-char 1)
                  (forward-line (1- $line-num)))
              (when (y-or-n-p (format "file no exist: %s. Create?" $fpath))
                (find-file $fpath))))
        (if (file-exists-p $path)
            (progn ; open f.ts instead of f.js
              (let (($ext (file-name-extension $path))
                    ($fnamecore (file-name-sans-extension $path)))
                (if (and (string-equal $ext "js")
                         (file-exists-p (concat $fnamecore ".ts")))
                    (find-file (concat $fnamecore ".ts"))
                  (find-file $path))))
          (if (file-exists-p (concat $path ".el"))
              (find-file (concat $path ".el"))
            (when (y-or-n-p (format "file no exist: %s. Create?" $path))
              (find-file $path ))))))))


(global-set-key (kbd "C-<tab>")  'xah-open-file-at-cursor)
