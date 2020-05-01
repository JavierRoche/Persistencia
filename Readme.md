Dudas:

- En el fichero HeroesViewController, en su init, donde decido el uso de la vista, ¿es una chapuza? ¿se suelen reutilizar las vistas o para no hacer este tipo de cosas es mejor crear mas views?

Funcionamiento:

- La app viene preparada para nuevos usuarios, guardando este dato en UserDefaults, de forma que realiza una sola carga inicial de datos.
- La app viene preparada para arrancar en la ultima vista visitada por el usuario, utilizando tambien UserDefaults.
- La app tambien utiliza UserDefaults para almacenar el contador incremental de batalla.
- La app puede borrar batallas pero no personajes pues no le veia sentido, y para trabajar con ello pues era suficiente.
- Se pueden borrar batallas desde la ventana de detalle de una batalla, a la que se puede acceder desde la lista principal de batallas y desde el colection de batallas que aparece en la ventana de detalle de personaje.
- Tambien desde la ventana de detalle de personaje se puede editar el power del mismo, valor que interviene en el calculo del vencedor de los combates.
