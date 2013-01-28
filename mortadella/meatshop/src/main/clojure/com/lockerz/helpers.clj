(ns com.lockerz)

(use 'hiccup.core)

(def handlebars
  (.getBean application-context "handlebars"))

(defmacro defhelper [hname & body]
  `(do
    (defn ~hname ~@body)
    (.registerHelper
      handlebars
      (last (clojure.string/split (str '~hname) #"/"))
      (com.lockerz.common.template.handlebars.ClojureHelper. ~hname))
    ~hname))

(defhelper link_to [text url & [attrs]]
  (html [:a (assoc attrs :href url) text]))

