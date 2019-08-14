# Data Druid Predicate Runner

## Usage

**This procedure must be performed on a department machine as it makes use of the grid to run jobs**

### Installing CLI Pyret

```bash
git clone https://github.com/brownplt/pyret-lang
cd pyret-lang
npm install
make
cd ..
```

### Running predicates

**Note:** make sure to clear out `corpus/impls/` and `result/` between runs!

1. Pull student submissions for the assignment you want to regrade from the database into `corpus/impls/` by executing:
    `python3 pull-submissions.py <Assignment ID> <Tool>(optional)`

2. Place a predicate file named `predicates.arr` in the `corpus` folder

3. Run the predicates against student submissions by executing `./rerun-preds.sh`

4. Update the database by executing `python3 update-rows.py`
