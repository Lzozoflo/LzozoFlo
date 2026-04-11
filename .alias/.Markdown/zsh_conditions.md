# Zsh Conditions Cheat Sheet

## File Tests

|Syntaxe     |Signification      |Exemple|
|----------- |------------------ |-----------------|
|`-e file`   |Existe             |`[[ -e file ]]`|
|`-f file`   |Fichier régulier   |`[[ -f file ]]`|
|`-d file`   |Répertoire         |`[[ -d dir ]]`|
|`-L file`   |Lien symbolique    |`[[ -L link ]]`|
|`-r file`   |Lisible            |`[[ -r file ]]`|
|`-w file`   |Écriture           |`[[ -w file ]]`|
|`-x file`   |Exécutable         |`[[ -x file ]]`|
|`-s file`   |Taille \> 0        |`[[ -s file ]]`|
|`-d dir`    |Répertoire         |`[[ -d ~/Downloads ]]`|
## String Tests

|Syntaxe            |Signification   |Exemple|
|------------------ |--------------- |-------------------------|
|`-n str`           |Non vide        |`[[ -n $var ]]`|
|`-z str`           |Vide            |`[[ -z $var ]]`|
|`str = pattern`    |Match glob      |`[[ $x = y* ]]`|
|`str != pattern`   |Ne match pas    |`[[ $x != y* ]]`|
|`str =~ regex`     |Match regex     |`[[ $x =~ '^y[0-9]' ]]`|

## Numeric Tests

|Syntaxe   |Signification   |Exemple|
|--------- |--------------- |-----------------|
|`-eq`     |Égal            |`[[ 3 -eq 3 ]]`|
|`-ne`     |Différent       |`[[ 3 -ne 4 ]]`|
|`-lt`     |\<              |`[[ 2 -lt 5 ]]`|
|`-gt`     |\>              |`[[ 7 -gt 5 ]]`|
|`-le`     |\<=             |`[[ 5 -le 5 ]]`|
|`-ge`     |\>=             |`[[ 6 -ge 5 ]]`|

## Logical Operators

|Syntaxe            |Signification|
|------------------ |---------------|
|`! expr`           |NOT|
|`expr1 && expr2`   |AND|
|`expr1 \|\| expr2`   |OR|

## File Comparison

|Syntaxe     |Signification|
|----------- |---------------------|
|`a -nt b`   |a plus récent que b|
|`a -ot b`   |a plus ancien que b|
|`a -ef b`   |même fichier|

## Useful Patterns

``` zsh
# Test file
[[ -f file ]] && echo "exists"

# Test variable
[[ -z $var ]] && echo "empty"

# Combined condition
[[ -f a && -r a ]] && echo "readable file"
```

## Functions & Aliases

``` zsh
# Alias
alias ll='ls -lah'

# Function
myfunc() {
  [[ -f "$1" ]] && echo "file"
}
```
