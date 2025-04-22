.  **Practical Examples:**

-   **Print first and second columns from a file:**

```awk
awk '{print $1, $2}' filename
```	
    This command prints the first and second columns from the file `filename`, separated by a space.
    
- **Print lines containing a specific pattern:**
    
```awk
awk '/pattern/' filename
```
    This command prints all lines from the file `filename` that contain the specified pattern.
    
- **Print lines longer than a certain length:**
```awk
awk 'length > 80' filename
```
    This command prints all lines from the file `filename` that are longer than 80 characters.
    
- **Print the total number of lines in a file:**
    
```awk
awk 'END {print NR}' filename
```
    This command prints the total number of lines in the file `filename`.
    
- **Calculate the sum of values in a column:**
    
```awk
awk '{sum += $1} END {print sum}' filename
``` 
    This command calculates the sum of values in the first column of `filename` and prints the result.
    
- **Print unique entries in a column:**
    
```awk
awk '!seen[$1]++' filename
``` 
    This command prints only the unique entries in the first column of `filename`.
    
- **Print lines between two patterns:**
    
```awk
awk '/start_pattern/, /end_pattern/' filename
``` 
    This command prints all lines between `start_pattern` and `end_pattern` in `filename`, inclusive.
    
- **Print specific columns based on a condition:**
    
```awk
awk '$3 > 50 {print $1, $2}' filename
``` 
    This command prints the first and second columns from `filename` only if the value in the third column is greater than 50.
