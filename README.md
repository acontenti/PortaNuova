# Porta Nuova

Esoteric programming laguage inspired by "Mornington Crescent" language, but set in Turin Metro.
It is named after "Porta Nuova" metro station, which is the fulcrum of Turin Metro.

## Rules

In **Porta Nuova** you travel around **stations** in Turin Metro.  
You travel with a **backpack** that can hold **values**.
Each **station** has a **value** and performs some action on **backpack** **values** and/or **station** **value**.
**Stations** are on different **lines** and you can only change in **interchange stations**.  

### Backpack

Initially the **backpack** holds two **values** `0` and `''` (empty string).  
The number of **values** can change in some **stations** like `Porta Susa` and `Rebaudengo`.  

### Lines

There are two **lines**: `1` and `2`.  
You can change between them in `Porta Nuova` **station**, which is the only interchange **station** in the system.  

#### Line 1

- `Cascine Vica`
- `Leumann`
- `Collegno Centro`
- `Certosa`
- `Fermi`
- `Paradiso`
- `Marche`
- `Massaua`
- `Pozzo Strada`
- `Monte Grappa`
- `Rivoli`
- `Racconigi`
- `Bernini`
- `Principi d'Acaja`
- `XVIII Dicembre`
- `Porta Susa`
- `Vinzaglio`
- `Re Umberto`
- `Porta Nuova`
    - Interchange **station** for **lines** `1` and `2`
    - Holds a **reference** to last visited **station**, used not to loose last **station** **reference** when you need to change **line**
- `Marconi`
- `Nizza`
- `Dante`
- `Carducci-Molinette`
- `Spezia`
- `Lingotto`
- `Italia '61`
- `Bengasi`

#### Line 2

- `Pasta di Rivalta`
- `Orbassano Centro`
- `Beinasco Centro`
- `Fornaci`
- `Cimitero Parco`
- `Mirafiori`
- `Cattaneo`
- `Omero`
- `Pitagora`
- `Parco Rignon`
- `Santa Rita`
- `Gessi`
- `Largo Orbassano`
- `Caboto`
- `Politecnico`
- `Stati Uniti`
- `Porta Nuova`
    - Interchange **station** for **lines** `1` and `2`
    - Holds a **reference** to last visited **station**, used not to loose last **station** **reference** when you need to change **line**
- `Solferino`
- `Castello`
- `Regina Margherita`
- `Verona`
- `Novara`
- `Regio Parco`
- `Zanella`
- `Tabacchi`
- `Cherubini`
- `Paisiello`
- `Giulio Cesare`
- `Vercelli`
- `Rebaudengo`

### Directions

**Directions** indicate where to go.  
You have to specify a **line** and a **station**.  
You can give **directions** this way:
```
prendi la linea <line> fino a <station>
```

### Shortcuts

You can imagine **shortcuts** as functions in other programming languages.

You can define a **shortcut** this way:
```
per prendere la scorciatoia <name>
...
<directions>
...
sei arrivato
```

**Shortcuts** can have a **parameter**, but it is optional. Like this:
```
per prendere la scorciatoia <name> con un <parameter name>
...
<directions>
...
sei arrivato
```

You can take a **shortcut** this way:
```
prendi la scorciatoia <name>
```
Of course if the **shortcut** has a **parameter**, you have to pass a **value**. This way:
```
prendi la scorciatoia <name> con <value>
```

## Copyright

	Copyright © 2016 Alessandro Contenti. All rights reserved.
