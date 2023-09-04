# VGA Driver
Driver per una VGA a 4 bit per colore, in grado di gestire una risoluzione di 640x480 pixel.

## Descrizione
In ingresso accetta i tre vettori di bit dei tre colori, e in uscita genera i segnali per il controllo della VGA.

La sincronizzazione tra la generazione dei pixel è gestita separatamente, il segnale 'active' va ad '1' quando il pennello del driver è nella zona di disegno, e va a '0' quando è nella zona di sincronizzazione.

# Informazioni
Testato su Vivado 2021.2 con una scheda ZebBoard Zynq-7000.