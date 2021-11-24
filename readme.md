75.03 / 95.57 Organización del Computador

```
Enunciados de TP – 75.03 / 95.57 Organización del Computador Página 8 de 20
```
# Trabajo práctico Nro. 8


### Bolsas de Correo (II)

```
Se tienen n objetos de pesos P1, P2, ..., Pn (con n <= 20) que deben ser enviados por correo a una
misma dirección. La forma más simple sería ponerlos todos en un mismo paquete; sin embargo, el
correo no acepta que los paquetes tengan más de 15 Kg. y la suma de los pesos podría ser mayor
que eso. Afortunadamente, cada uno de los objetos no pesa más de 15 Kg.

Se trata entonces de pensar un algoritmo que de un método para armar los paquetes, tratando de
optimizar su cantidad. Debe escribir un programa en assembler Intel 80x86 que:

● Permita la entrada de un entero positivo n.
● La entrada de los n pesos, verificando que 0<Pi<=15 donde i <=n.
● Los Pi pueden ser valores enteros.
● Exhiba en pantalla la forma en que los objetos deben ser dispuestos en los paquetes.

A su vez existen tres destinos posibles: Posadas, Salta y Tierra del Fuego. El correo por normas
internas de funcionamiento no puede poner en el mismo paquete objetos que vayan a distinto destino.

Desarrollar un algoritmo que proporcione una forma de acomodar los paquetes de forma que no haya
objetos de distinto destino en un mismo paquete y cumpliendo las restricciones de peso. Se sugiere
tener una salida como la siguiente:

- Destinoi – Objeto 1 (P 1 ) + Objeto 2 (P 2 )+ ..... + Objeton (Pn)
- Destinoi – Objeto 1 (P 1 ) + Objeto 2 (P 2 )+ ..... + Objeton (Pn)
- Destinoi – Objeto 1 (P 1 ) + Objeto 2 (P 2 )+ ..... + Objeton (Pn)
```