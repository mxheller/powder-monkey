#!/bin/bash

:>stdout.log
:>stderr.log

# 1 or $PRED_PREHOOK     (optional) script to run after copying each $TEST to $OUTPUT
# 2 or $IMPL_PREHOOK     (optional) script to run after copying each $IMPL to $OUTPUT

PRED_PREHOOK="$(realpath "${1:-$PRED_PREHOOK}" || echo "")"
IMPL_PREHOOK="$(realpath "${1:-$IMPL_PREHOOK}" || echo "")"
PYRET="$(realpath "$(dirname "${BASH_SOURCE[0]}")/pyret-lang")"
RUNNER="$(dirname "${BASH_SOURCE[0]}")/runner.js"

# Delete queued jobs if script exits
function qkill(){ qdel -u $USER >>stdout.log 2>>stderr.log ; }
trap "qkill" EXIT ERR

function queue-test(){
  IMPL="$1"
  TEST="$2"
  OUTPUT="$3"
  job_name="$(basename $OUTPUT)"

  qsub -terse                   \
       -cwd                     \
       -notify                  \
       -l h_rt=00:10:00         \
       -o 'stdout.log'          \
       -e 'stderr.log'          \
       -N "$(basename $OUTPUT)" \
       -v IMPL="$IMPL"          \
       -v TEST="$TEST"          \
       -v OUTPUT="$OUTPUT"      \
       -v PYRET="$PYRET"        \
       -v RUNNER="$RUNNER"      \
       -v PRED_PREHOOK="$PRED_PREHOOK"    \
       -v IMPL_PREHOOK="$IMPL_PREHOOK"    \
       "$(dirname "${BASH_SOURCE[0]}")/evaluate.sh" || exit 1
}

function jobs-remaining(){
  qstat | tail -n+4 | wc -l
}

function join(){
  stage="$1"
  job_list="$2"
  qsub -cwd                  \
       -sync y               \
       -l test               \
       -hold_jid "$job_list" \
       -o '/dev/null'        \
       -e '/dev/null'        \
       -N "join"             \
       "$(dirname "${BASH_SOURCE[0]}")/join.sh" >stdout.txt &
  # Show progress indicator
  pid=$! ; trap "kill $pid 2> /dev/null; qkill" EXIT ERR ; sleep 1; echo ""
  while kill -0 $pid 2> /dev/null; do
    echo -e "\e[1A\e[K[$stage] $(jobs-remaining) jobs remaining"
  done; trap 'qkill' EXIT ERR
}

job_list=""
job_counter=0;

while read -r IMPL TEST OUTPUT ; do
    let job_counter++
    job_id="$(queue-test "$IMPL" "$TEST" "$OUTPUT")"; job_list="$job_id,$job_list"
    echo -e "\e[1A\e[K[EVALUATING] Queueing job $job_counter."
done; join "EVALUATING" "$job_list"
