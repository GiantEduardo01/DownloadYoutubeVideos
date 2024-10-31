# Proyecto Docker con Apache y CGI en Perl

Este proyecto crea un contenedor Docker basado en `minideb` que configura un servidor Apache en el puerto `90` con soporte para scripts CGI en Perl. Aquí se detalla el contenido técnico de cada sección del `Dockerfile` y cómo se ha configurado para ejecutar aplicaciones web.

---

## Dockerfile Explicado

### Base de la Imagen
```dockerfile
FROM bitnami/minideb
```
Este comando usa la imagen minideb de Bitnami como base. minideb es una versión optimizada de Debian, ideal para crear contenedores ligeros.

## Variables de Entorno
```dockerfile
ENV DEBIAN_FRONTEND="noninteractive"
```
Esta variable permite una instalación no interactiva para evitar prompts al instalar paquetes. Esto es útil para automatizar la construcción del contenedor.

## Actualización del Sistema e Instalación de Dependencias
```dockerfile
RUN apt-get update && \
    apt-get install -y apache2 perl libcgi-pm-perl && \
    apt-get clean
```
Esta sección actualiza los repositorios de apt e instala:

- Apache2: Servidor web principal.
- Perl: Necesario para ejecutar scripts en Perl.
- CGI.pm: Módulo de Perl que permite la ejecución de scripts CGI.
- Se utiliza apt-get clean para limpiar archivos temporales y reducir el tamaño de la imagen.








