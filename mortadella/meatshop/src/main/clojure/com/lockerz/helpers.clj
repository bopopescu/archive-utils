(ns com.lockerz)

(use 'hiccup.core 'hiccup.form)

(def handlebars
  (.getBean application-context "handlebars"))

(defn register-helper [hname hfn]
  (.registerHelper
    handlebars
    (last (clojure.string/split (str hname) #"/"))
    (com.lockerz.common.template.handlebars.ClojureHelper. hfn)))

(defmacro defhelper [hname & body]
  `(do
     (defn ~hname ~@body)
     (register-helper '~hname ~hname)
     ~hname))

(defmacro defhtmlhelper [hname args & body]
  `(do
     (defn ~hname ~args
       (com.github.jknack.handlebars.Handlebars$SafeString. (html ~@body)))
     (register-helper '~hname ~hname)
     ~hname))

(defhtmlhelper link_to [text url & [attrs]]
  [:a (assoc attrs :href url) text])

(defhtmlhelper checkbox [name label & [attrs]]
  [:label.checkbox
   (check-box attrs name)
   label])

