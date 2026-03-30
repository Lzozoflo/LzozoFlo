man zshmisc 
man test





| Syntaxe                     | Signification                      | Exemple                  | Notes                                     |                     |                      |          |
| --------------------------- | ---------------------------------- | ------------------------------------- | ----------------------------------------- | ------------------- | -------------------- | -------- |
| `-a fichier`                | Le fichier existe                  | `[[ -a /tmp/test ]]`     | Équivalent à `-e`                         |                     |                      |          |
| `-e fichier`                | Le fichier existe                  | `[[ -e monfichier ]]`    | Test général d’existence                  |                     |                      |          |
| `-f fichier`                | Fichier régulier                   | `[[ -f script.sh ]]`     | Pas un répertoire, FIFO, etc.             |                     |                      |          |
| `-d fichier`                | Répertoire                         | `[[ -d ~/Downloads ]]`   |                                           |                     |                      |          |
| `-L fichier` / `-h fichier` | Lien symbolique                    | `[[ -L monlien ]]`       | `-h` = synonyme                           |                     |                      |          |
| `-r fichier`                | Lisible                            | `[[ -r fichier.txt ]]`   | Permissions du processus courant          |                     |                      |          |
| `-w fichier`                | قابل écriture                      | `[[ -w fichier.txt ]]`   |                                           |                     |                      |          |
| `-x fichier`                | Exécutable                         | `[[ -x ./run.sh ]]`      | Pour un dossier : permission de traversée |                     |                      |          |
| `-s fichier`                | Taille > 0                         | `[[ -s log.txt ]]`       |                                           |                     |                      |          |
| `-p fichier`                | FIFO / pipe nommé                  | `[[ -p /tmp/pipe ]]`     |                                           |                     |                      |          |
| `-S fichier`                | Socket                             | `[[ -S /tmp/socket ]]`   |                                           |                     |                      |          |
| `-b fichier`                | Périphérique bloc                  | `[[ -b /dev/sda ]]`      |                                           |                     |                      |          |
| `-c fichier`                | Périphérique caractère             | `[[ -c /dev/tty ]]`      |                                           |                     |                      |          |
| `-u fichier`                | Bit setuid activé                  | `[[ -u binaire ]]`       |                                           |                     |                      |          |
| `-g fichier`                | Bit setgid activé                  | `[[ -g dossier ]]`       |                                           |                     |                      |          |
| `-k fichier`                | Sticky bit activé                  | `[[ -k /tmp ]]`          |                                           |                     |                      |          |
| `-O fichier`                | Appartient à l’UID effectif        | `[[ -O fichier ]]`       |                                           |                     |                      |          |
| `-G fichier`                | Groupe = GID effectif              | `[[ -G fichier ]]`       |                                           |                     |                      |          |
| `-N fichier`                | Atime <= mtime                     | `[[ -N fichier ]]`       |                                           |                     |                      |          |
| `-t fd`                     | Descripteur ouvert sur un terminal | `[[ -t 1 ]]`             | `1` = stdout, `0` = stdin                 |                     |                      |          |
| `-n chaine`                 | Chaîne non vide                    | `[[ -n $var ]]`          | Très utilisé                              |                     |                      |          |
| `-z chaine`                 | Chaîne vide                        | `[[ -z $var ]]`          | Très utilisé                              |                     |                      |          |
| `-v varname`                | Variable définie                   | `[[ -v HOME ]]`          | Teste l’existence de la variable          |                     |                      |          |
| `fichier1 -nt fichier2`     | `fichier1` plus récent             | `[[ a -nt b ]]`          | Comparaison de date                       |                     |                      |          |
| `fichier1 -ot fichier2`     | `fichier1` plus ancien             | `[[ a -ot b ]]`          | Comparaison de date                       |                     |                      |          |
| `fichier1 -ef fichier2`     | Même fichier physique              | `[[ a -ef b ]]`          | Même inode                                |                     |                      |          |
| `string = pattern`          | Correspondance avec un motif       | `[[ $x = y* ]]`          | `=` et `==` sont équivalents dans `[[ ]]` |                     |                      |          |
| `string != pattern`         | Ne correspond pas au motif         | `[[ $x != y* ]]`         |                                           |                     |                      |          |
| `string =~ regexp`          | Correspondance regex               | `[[ $x =~ '^y[0-9]+' ]]` | Regex ERE ou PCRE selon option            |                     |                      |          |
| `string1 < string2`         | Ordre ASCII inférieur              | `[[ a < b ]]`            | Comparaison lexicographique               |                     |                      |          |
| `string1 > string2`         | Ordre ASCII supérieur              | `[[ c > b ]]`            |                                           |                     |                      |          |
| `exp1 -eq exp2`             | Égalité numérique                  | `[[ 3 -eq 3 ]]`          |                                           |                     |                      |          |
| `exp1 -ne exp2`             | Différent numériquement            | `[[ 3 -ne 4 ]]`          |                                           |                     |                      |          |
| `exp1 -lt exp2`             | Plus petit                         | `[[ 2 -lt 5 ]]`          |                                           |                     |                      |          |
| `exp1 -gt exp2`             | Plus grand                         | `[[ 7 -gt 5 ]]`          |                                           |                     |                      |          |
| `exp1 -le exp2`             | Plus petit ou égal                 | `[[ 5 -le 5 ]]`          |                                           |                     |                      |          |
| `exp1 -ge exp2`             | Plus grand ou égal                 | `[[ 6 -ge 5 ]]`          |                                           |                     |                      |          |
| `( exp )`                   | Regroupement                       | `[[ ( -f a               |                                           | -f b ) && -n $x ]]` | Parenthèses logiques |          |
| `! exp`                     | Négation                           | `[[ ! -f fichier ]]`     |                                           |                     |                      |          |
| `exp1 && exp2`              | ET logique                         | `[[ -f a && -r a ]]`     |                                           |                     |                      |          |
| `exp1                       |                                    | exp2`                    | OU logique                                | `[[ -f a            |                      | -f b ]]` |










