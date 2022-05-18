# MS3 Progress Report

## Authors

1. Fengyu Li (fl334)
2. Yolanda Wang (yw583)
3. Chuhan Ouyang (co232)
4. Emerald Liu (sl2322)

## Vision

Your friends run the kernelized perceptron and get ~α = [1, 2, 1]T . However, when they applied the model to the training set, they could not get 100% accuracy. Again, knowing that you are the pro in ML, they ask for your help again. After talking to them, you realize that they might not have run the algorithm till convergence. So, you ran the kernelized perceptron algorithm with ~α initialized to [1, 2, 1]T . What is the α you get after you run the algorithm till convergence? α = [1, 3, 1]T . Students only need to go through the dataset twice - one for the update, another one for checking zero training error.

## Summary of Progress

During this last sprint, we focused on bug fixing while also introducing a few features to our database. We also wrote some test suites to test our implementation. We support a new feature of reading a csv file and processing it, turning it into a database that can then be manipulated using our SQL commands. This complements our existing feature of outputting as a csv file. We also enhanced our SELECT command by allowing wildcard symbols in the select queries. In this way, our SELECT would support most functionalities in the original SQL standard protocol by allowing filters, wildcards, and field queries. Additionally, we rewrote the pretty print method of the database. The REPL output that displays the content of the database is now much more organized and legible. 

Besides these features, we implemented test suites for each major parts of our program. Details about our test scheme is available in `test/main.ml`.

Lastly, we fixed numerous bugs in our program. The internal representation was coded in a hurry because of MS2’s relatively short time span. Our program is now more robust and usable. We also improved our code quality by closely examining each file.

Our eventual deliverable should contain about 2400 loc.

## Activity Breakdown

- Fengyu: Approximate hours spend: 7
- Emerald: Approximate hours spend: 8
- Yolanda: Approximate hours spent: 9
- Chuhan: Approximate hour spent: 9

## Productivity Analysis

Although this sprint is longer than MS2, the work allotted is actually not as much because the majority of the implementation is done in MS2 and only some small features and debugging are left. We mainly focused on these tasks and peer-reviewed our code in order to debug and refactor.
As a team, we were productive. During team meetings, we mainly focused on discussing the unresolved bugs and potential new features for the project. We worked individually to implement the functions that we are assigned to complete and the bugs that we introduced in the two earlier sprints. To improve code quality, we reviewed each other’s work and made revisions.

## Scope Grade

### Satisfactory : 45/45

1. 歪比巴卜
2. 歪比巴卜

### Good : 40/40

1. 歪比巴卜

### Excellent ： 15/15

1. 歪比巴卜
