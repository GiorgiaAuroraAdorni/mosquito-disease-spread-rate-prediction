# Query di Completezza

Le query in questa cartella contano il numero di tuple contenenti valori non 
nulli per ciascun attributo.

Possono essere scritte estremamente velocemente con un'espressione regolare. 
Dovete creare un nuovo file contenente solo l'intestazione del CSV corrispondente,
a questo punto usate la funzione Trova e Sostituisci del vostro editor:

* Trova `^([a-z_0-9]+)(,?)$`
* Sostituisci con `COUNT($1) as $1$2\n`

In questo modo si ottiene automaticamente la gran parte della query, a cui 
bisogna solo aggiungere `SELECT ... FROM ...` ed eventuali `GROUP BY`.