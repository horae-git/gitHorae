
`jq` is a powerful, command-line tool |for parsing, filtering, and transforming JSON data
--|--

Think of it as `sed` or `awk`, but specifically tailored for JSON.

Here is a guide on how to use `jq` for querying, ranging from basic to advanced operations.

---

## 1\. The Basics

To use `jq`, you typically pipe JSON data into it or pass a JSON file as an argument:

Bash

```
cat data.json | jq 'filter'
# OR
jq 'filter' data.json
```

### The Identity Operator (`.`)

The simplest filter is `.`. It takes the input and outputs it exactly as is, but **prettified** and color-coded.

Bash

```
echo '{"name":"Alice","age":30}' | jq '.'
```

**Output:**

JSON

```
{
  "name": "Alice",
  "age": 30
}
```

---

## 2\. Navigating Objects and Arrays

Assume we are working with this JSON object:

JSON

```
{
  "user": {
    "name": "Bob",
    "skills": ["Python", "Bash", "Go"]
  }
}
```

### Object Keys (`.key`)

To grab a specific field, append the key name to the dot:

Bash

```
jq '.user.name' data.json
# Output: "Bob"
```

### Array Indexing (`.[index]`)

Arrays are zero-indexed. To get the first skill from the array above:

Bash

```
jq '.user.skills[0]' data.json
# Output: "Python"
```

### Array Slicing (`.[start:end]`)

You can slice arrays just like in Python:

Bash

```
jq '.user.skills[0:2]' data.json
# Output: ["Python", "Bash"]
```

---

## 3\. Iterating and Flattening (`.[]`)

If you want to iterate over an array or explode an object into its values, use `.[]`.

Assume we have an array of users:

JSON

```
[
  {"name": "Alice", "role": "Admin"},
  {"name": "Bob", "role": "User"}
]
```

### Extracting elements from an array

To strip the outer array brackets and process each item individually:

Bash

```
jq '.[]' users.json
```

### Piping within jq (`|`)

You can use a pipe inside your `jq` query to pass the output of one filter to another. To get *just* the names of all users:

Bash

```
jq '.[] | .name' users.json
```

**Output:**

Plaintext

```
"Alice"
"Bob"
```

---

## 4\. Constructing New JSON Outputs

You don't just have to extract data; you can reshape it into a brand-new JSON format.

### Creating a New Array

If you want to collect the names from the previous example back into a clean array:

Bash

```
jq '[.[] | .name]' users.json
# Output: ["Alice", "Bob"]
```

### Creating a New Object

You can map existing data to custom keys:

Bash

```
jq '.[] | {username: .name, access: .role}' users.json
```

**Output:**

JSON

```
{
  "username": "Alice",
  "access": "Admin"
}
{
  "username": "Bob",
  "access": "User"
}
```

---

## 5\. Filtering with Conditions (`select`)

The `select(boolean_expression)` function allows you to filter arrays based on a condition, functioning much like a `SQL WHERE` clause.

Using the same users array, let's find only the user who is an **Admin**:

Bash

```
jq '.[] | select(.role == "Admin")' users.json
```

**Output:**

JSON

```
{
  "name": "Alice",
  "role": "Admin"
}
```

You can combine conditions using `and`, `or`, and operators like `>`, `<`, `!=`, or functions like `contains()`.

Bash

```
jq '.[] | select(.role == "Admin" and (.name | contains("Al")))' users.json
```

---

## 6\. Handy Pro-Tips

- **Raw Output (`-r` flag):** By default, `jq` outputs strings with quotes (`"Alice"`). Use `-r` to output raw strings, which is perfect for saving values directly into Bash variables.

    Bash

    ```
    NAME=$(jq -r '.user.name' data.json)
    ```

```
*   **Compact Output (`-c` flag):** Instead of pretty-printing, this condenses the JSON back into single lines—highly useful when streaming data to other tools or logs.

Would you like to see how to solve a specific parsing problem with a sample of your own JSON data?
```
