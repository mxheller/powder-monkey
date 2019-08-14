provide *
provide-types *

import error-display as ED
import srcloc as S

data Predicate:
  | pred(
      f :: (Any -> Boolean),
      hint :: String)
end

fun pred-typed<T>(
    type-checker :: (Any -> Boolean),
    f :: (T -> Boolean),
    hint :: String)
  -> Predicate:
  pred({(x): type-checker(x) and f(x)}, hint)
end