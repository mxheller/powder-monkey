provide *
include file("playground.arr")
include tables
import lists as L

#|
 ballot = 
   table:
   candidate :: String,
   party :: String
 end

 vote-record = 
   table: 
   choice1 :: String,
   choice2 :: String
 end
|#


## PROVIDED TABLE FOR STUDENTS
ballot2 = 
  table: candidate :: String, party :: String
    row: "Alice", "Party A"
    row: "Bob", "Party B"
    row: "Carol", "Party C"
    row: "Denise", "Party D"
  end

ballot-candidates = list-to-set(ballot2.column("candidate"))

fun type-checker(x :: Any) -> Boolean:
  type-checkers = [list: is-string, is-string]
  is-table(x) and
  (x.column-names() == [list: "choice1", "choice2"])
end

general-hint = "no need"

# HELPERS FOR PREDICATES 

fun count<T>(elt :: T, l :: List<T>):
  cases (List) l:
    | empty => 0
    | link(f, r) =>
      if (f == elt): 1 + count(elt, r)
      else: count(elt, r)
      end
  end
end

type Result = {String; Number}

fun tally(candidate :: String, vote-record :: Table) -> Number:
  count(candidate, vote-record.column("choice1"))
end

fun tally-pref(candidate :: String, vote-record :: Table) -> Number:
  first-choice-count = 3 * count(candidate, vote-record.column("choice1"))
  second-choice-count = count(candidate, vote-record.column("choice2"))
  first-choice-count + second-choice-count
end

fun generate-results(vote-record :: Table, tally-func :: (String, Table -> Number)) -> List<Result>:
  candidates = vote-record.column("choice1") + vote-record.column("choice2")
  L.distinct(candidates).map({(c): {c; tally-func(c, vote-record)}})
end

fun compute-places(results :: List<Result>) -> List<Set<String>>:
  distinct-votes = L.distinct(results.map({(r): r.{1}}))
  sorted-distinct-votes = distinct-votes.sort-by(_ > _, equal-always)
  sorted-distinct-votes.map(
    lam(votes):
      results-with-votes = results.filter({(r): r.{1} == votes})
      list-to-set(results-with-votes.map({(r): r.{0}}))
    end)
end

fun nth-place(
    vote-record :: Table,
    tally-func :: (String, Table -> Number),
    n :: Number)
  -> Option<Set<String>>:
  places = compute-places(generate-results(vote-record, tally-func))
  if places.length() > n:
    some(places.get(n))
  else:
    none
  end
end

fun write-in(candidate :: String) -> Boolean:
  not(ballot-candidates.member(candidate))
end

fun same-nth-place(vote-record :: Table, n :: Number) -> Option<Boolean>:
  cases (Option) nth-place(vote-record, tally, n):
    | some(w1) =>
      cases (Option) nth-place(vote-record, tally-pref, n):
        | some(w2) => some(w1 == w2)
        | none => none
      end
    | none => none
  end
end


# PREDICATES 

tally-method-hint = "How might the winner produced by the two tally methods compare?"

# the same winner is a ballot candidate
# winner would have been the same if no write ins allowed

pred-same-winner = pred(
  lam(t):
    cases (Option) same-nth-place(t, 0):
      | some(v) => v
      | none => false
    end
  end,
  tally-method-hint)

pred-2nd-place-same-winner = pred(
  lam(t):
    cases (Option) same-nth-place(t, 0):
      | some(same-1st) =>
        not(same-1st) and cases (Option) same-nth-place(t, 1):
          | some(same-2nd) => same-2nd
          | none => false
        end
      | none => false
    end
  end,
  "")

pred-diff-winner = pred(
  lam(t):
      cases (Option) same-nth-place(t, 0):
      | some(v) => not(v)
      | none => false
    end
  end,
  tally-method-hint)

pred-write-in = pred(
  lam(t):
    in-table = t.column("choice1") + t.column("choice2")
    L.any(write-in, in-table)
  end,
  "")

pred-write-in-same-winner = pred(
  lam(t):
    cases (Option) same-nth-place(t, 0):
      | some(same) => 
        cases (Option) nth-place(t, tally, 0):
          | some(candidates) => L.all(write-in, candidates.to-list())
          | none => false
        end
      | none => false
    end
  end,
  "")


## HINT CRITERIA FUNCTIONS

fun is-general-hint-eligible(
    stagnated-attempts :: Number,
    num-predicates :: Number,
    num-satisfied-predicates :: Number)
  -> Boolean:
  false
end

fun is-specific-hint-eligible(
    stagnated-attempts :: Number,
    num-predicates :: Number,
    num-satisfied-predicates :: Number)
  -> Boolean:
  false
end  
