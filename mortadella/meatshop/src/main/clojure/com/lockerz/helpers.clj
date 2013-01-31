(ns com.lockerz)

(use 'hiccup.core 'hiccup.form)

(def handlebars
  (.getBean application-context "handlebars"))

(defn register-helper 
  "Register a function as a Handlebars helper."
  [hname hfn]
  (.registerHelper
    handlebars
    (last (clojure.string/split (str hname) #"/"))
    (com.lockerz.common.template.handlebars.ClojureHelper. hfn)))

(defmacro defhelper 
  "Defines a function and registers it as a Handlebars helper."
  [hname & body]
  `(do
     (defn ~hname ~@body)
     (register-helper '~hname ~hname)
     ~hname))

(defmacro defhtmlhelper 
  "Defines a function that renders the supplied Hiccup datastructure
  and registers it as a Handlebars helper."
  [hname doc args & body]
  (if (string? doc)
    `(do
      (defn ~hname ~doc ~args 
        (com.github.jknack.handlebars.Handlebars$SafeString. (html ~@body)))
      (register-helper '~hname ~hname)
      ~hname)
    `(do
      (defn ~hname ~doc 
        (com.github.jknack.handlebars.Handlebars$SafeString. (html ~args ~@body)))
      (register-helper '~hname ~hname)
      ~hname)))

(defhtmlhelper link_to
  "Wrap a URL in an anchor tag."
  [text url & [attrs]]
  [:a (assoc attrs :href url) text])

(defhtmlhelper checkbox
  "Wrap a checkbox in a label element for Bootstrap."
  [name label & [attrs]]
  [:label.checkbox
   (check-box (or attrs {}) name)
   label])

(defhtmlhelper password-group
  "A password field control group for Bootstrap forms."
  [name label & [attrs]]
  (let [input-id (or (and attrs (attrs :id)) name)
        attrs (merge {:placeholder label} attrs)]
    [:div.control-group
     [:label.control-label {:for input-id} label]
     [:div.controls
      (password-field (or attrs {}) name)]]))

(defhtmlhelper text-group
  "A text field control group for Bootstrap forms."
  [name label & [attrs]]
  (let [input-id (or (and attrs (attrs :id)) name)
        attrs (merge {:placeholder label} attrs)]
    [:div.control-group
     [:label.control-label {:for input-id} label]
     [:div.controls
      (text-field (or attrs {}) name)]]))
      
(defhtmlhelper checkbox-group
  "A checkbox control group for Bootstrap forms."
  [name label & [attrs]]
  (let [input-id (or (and attrs (attrs :id)) name)]
    [:div.control-group
     [:div.controls
      [:label.checkbox
       (check-box (or attrs {}) name)
       label]]]))
