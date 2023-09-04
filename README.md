# VGA Driver
Driver per una VGA a 4 bit per colore, in grado di gestire una risoluzione di 640x480 pixel.

## Descrizione
In ingresso accetta i tre vettori di bit dei tre colori, e in uscita genera i segnali per il controllo della VGA.

La sincronizzazione tra la generazione e la comunicazione sul protocollo dei pixel è gestita grazie al segnale 'active' che va ad '1' quando il pennello del driver è nella zona di disegno, e grazie ai segnali 'h_count_out' e 'v_vount_out' che indicano le coordinate (orriziontali e verticali rispettivamente) del pixel che stiamo disegnando. Unendo le due informazioni si può sincronizzare il calcolo del singolo pixel anche in modo da evitare glitch nell'immagine.

# Informazioni
Testato su Vivado 2021.2 con una scheda ZebBoard Zynq-7000.