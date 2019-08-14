# Data Druid Predicate Runner

## Usage

**This procedure must be performed on a department machine as it makes use of the grid to run jobs**

1. Pull student submissions for the assignment you want to regrade from the database by executing:
    `python3 pull-submissions.py <Assignment ID> <Tool>(optional)`

2. Place a predicate file named `predicates.arr` in the `corpus` folder

3. Run the predicates against student submissions by executing `./rerun-preds.sh`

4. Update the database by executing `python3 update-rows.py`