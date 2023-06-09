#!/bin/bash

# Descomprimir el fichero de glpi
[ -x glpi ] || tar -xf glpi-10.0.7.tgz

# Preparar la imagen docker
docker build --tag="emadruida/glpi:latest" .
