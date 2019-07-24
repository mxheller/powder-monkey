#!/bin/bash

declare -a IMPLS=(corpus/impls/*)
declare -a TESTS=(corpus/predicates/*)

# Before doing a full run, it's a good idea to verify that student
# submissions are in a runnable state.
# Verify implementations by making sure they can be compiled.
# Verify test suites by making sure they can be run against (though
# not necessarily actually pass) one of the wheats.
# <TODO>

# Queue all pairwise matchups of impls and tests
for IMPL in ${IMPLS[@]} ; do
  for TEST in ${TESTS[@]};  do
    echo "$(realpath "$IMPL")"  \
         "$(realpath "$TEST")" \
	 "$(realpath "result")/$(basename "$IMPL")_$(basename "$TEST")"
  done
done | ~/Documents/powder-monkey/evaluate/evaluate-many.sh "pred_prehook.sh"
