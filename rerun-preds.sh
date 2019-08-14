#!/bin/bash

declare -a IMPLS=(corpus/impls/*)
declare -a PREDS=corpus/predicates.arr

# Queue all implementations
for IMPL in ${IMPLS[@]} ; do
    echo "$(realpath "$IMPL")"  \
         "$(realpath "$PREDS")" \
	       "$(realpath "result")/$(basename "$IMPL")"
done | ~/Documents/powder-monkey/evaluate-many.sh "pred_prehook.sh"
