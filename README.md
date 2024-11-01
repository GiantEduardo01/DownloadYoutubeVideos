# Proyecto Docker con Apache y CGI en Perl

Este proyecto crea un contenedor Docker basado en `minideb` que configura un servidor Apache en el puerto `90` con soporte para scripts CGI en Perl. Aquí se detalla el contenido técnico de cada sección del `Dockerfile` y cómo se ha configurado para ejecutar aplicaciones web.

---

<details>
<summary>Explicación del Dockerfile</summary>
## Dockerfile Explicado

### Base de la Imagen
```dockerfile
FROM bitnami/minideb
```
Este comando usa la imagen minideb de Bitnami como base. minideb es una versión optimizada de Debian, ideal para crear contenedores ligeros.

---

### Variables de Entorno
```dockerfile
ENV DEBIAN_FRONTEND="noninteractive"
```
Esta variable permite una instalación no interactiva para evitar prompts al instalar paquetes. Esto es útil para automatizar la construcción del contenedor.

---

### Actualización del Sistema e Instalación de Dependencias
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

---

### Configuración del Puerto Apache 
```dockerfile
RUN sed -i 's/Listen 80/Listen 90/' /etc/apache2/ports.conf
RUN sed -i 's/:80/:90/' /etc/apache2/sites-available/000-default.conf
```

Estos comandos reemplazan el puerto predeterminado 80 por el 90 en los archivos de configuración de Apache (ports.conf y 000-default.conf), permitiendo que Apache escuche en el puerto 90.

---

### Habilitación del Módulo CGI en Apache
```dockerfile
RUN a2emod cgi
```
Se habilita el módulo CGI de Apache para ejecutar scripts CGI en el servidor.

---

### Creación de Directorios
```dockerfile
RUN mkdir -p /var/www/html
RUN mkdir -p /var/www/html/css
```
Se crean los directorios necesarios para almacenar el contenido HTML y CSS que se servirá a través del servidor web.

---

### Copia de Archivos 
```dockerfile
#COPY ./index.html /var/www/html/
#COPY ./css/ /var/www/html/css/
```
Nota: Estas líneas están comentadas por defecto. Al descomentarlas, se copian los archivos locales index.html y el directorio css al contenedor. Ajusta el código según necesites incluir estos archivos.

---

### Configuración de Permisos para Scripts CGI
```dockerfile
#COPY ./cgi-bin/sixth.pl /usr/lib/cgi-bin/
#RUN chmod -R 755 /usr/lib/cgi-bin && \
#    chown -R www-data:www-data /usr/lib/cgi-bin
```
Estas líneas, también comentadas, copiarían un script CGI en Perl (sixth.pl) al directorio CGI de Apache (/usr/lib/cgi-bin) y establecen permisos y propiedad para www-data. Descoméntalas si necesitas incluir el script en el contenedor.

---

### Permisos de Archivos Web
```dockerfile
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html
```
Se establece www-data como propietario y se configuran los permisos de los archivos en /var/www/html, permitiendo que Apache tenga acceso adecuado a los archivos web.

---

### Limpieza de Caché de apt
```dockerfile
RUN rm -rf /var/lib/apt/lists/*
```
Elimina los archivos de caché de apt, reduciendo el tamaño de la imagen final del contenedor.

---

### Exposición del Puerto
```dockerfile
EXPOSE 90
```

---

### Comando de Inicio
```dockerfile
CMD ["apachectl", "-D", "FOREGROUND"]
```
Se establece el comando predeterminado para ejecutar Apache en el primer plano. Esto asegura que el contenedor permanezca en ejecución mientras Apache está activo.

---

## Instrucciones de Ejecución
- Construir el Contenedor:
```bash
docker build -t downloader_img .
```

- Ejecutar el Contendor:
```bash
docker run -d -p 90:90 downloader_ctn
```

- Acceder al Servidor: Abre un navegador y dirígete a http://localhost:90 para ver tu aplicación web.

---

## Notas
- Directorio CGI: Los scripts Perl deben colocarse en /usr/lib/cgi-bin para que Apache pueda ejecutarlos como scripts CGI.
- Puerto Personalizado: El servidor escucha en el puerto 90, asegúrate de redirigir este puerto en tu configuración de docker run.
</details>
