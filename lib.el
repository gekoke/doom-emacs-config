(require 'json)

(setq advice-file "~/.config/doom/nix-advice.json")

(defun supports (feature)
  (let* ((json (json-read-file advice-file))
         (supported-features (cdar (seq-filter (lambda (kvp) (eq (car kvp) 'supportedFeatures)) json))))
    (seq-position supported-features feature)))

(defmacro if-supports! (symbol body)
  (declare (indent defun))
  (if (supports (symbol-name symbol))
      body
    nil))
