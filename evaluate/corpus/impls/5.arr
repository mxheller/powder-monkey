include file("tests.arr")
#|
   <ASSIGNMENT SPECS>
   
   Use the following table column definition:

     table: 
       choice1 :: String, 
       choice2 :: String
     end

   Write a collection of input tables that would be good for testing
   such a program. Download your file (voting-tally-examples.arr)
   to upload with your submission.
   
   ### IS THIS RELEVANT? VV
   Refer back to the Google Sheet linked to the problem handout for
   examples of what can go in the table cells.

   ---------------------------------------
   GRADING

   <GRADING NOTES>
   
|#

# We provide the following candidate ballot:
   
ballot = 
  table: candidate :: String, party :: String
    row: "Alice", "Party A"
    row: "Bob", "Party B"
    row: "Carol", "Party C"
    row: "Denise", "Party D"
  end

# DO NOT CHANGE ANYTHING ABOVE THIS LINE

table: choice1, choice2
  row: "John", "Alice"
  row: "John", "Alice"
  row: "Denise", "Alice"
end

table: choice1, choice2
  row: "George", "Alice"
  row: "John", "Alice"
  row: "Denise", "Alice"
end

table: choice1, choice2 end
