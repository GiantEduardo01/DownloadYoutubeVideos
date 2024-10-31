FROM bitnami/minideb

ENV DEBIAN_FRONTEND="noninteractive"

# Actualizar e instalar Apache, Perl, y el módulo CGI.pm
RUN apt-get update && \
    apt-get install -y apache2 perl libcgi-pm-perl && \
    apt-get clean

# Cambiar el puerto de Apache de 80 a 90
RUN sed -i 's/Listen 80/Listen 90/' /etc/apache2/ports.conf
RUN sed -i 's/:80/:90/' /etc/apache2/sites-available/000-default.conf

# Habilitar módulo CGI en Apache
RUN a2enmod cgi

# Crear los directorios necesarios en /var/www/html
RUN mkdir -p /var/www/html
RUN mkdir -p /var/www/html/css

# Copiar el archivo HTML y CSS al servidor web
#COPY ./index.html /var/www/html/
#COPY ./css/ /var/www/html/css/

# Copiar el script Perl al directorio de CGI y configurar permisos
#COPY ./cgi-bin/sixth.pl /usr/lib/cgi-bin/
#RUN chmod -R 755 /usr/lib/cgi-bin && \
#    chown -R www-data:www-data /usr/lib/cgi-bin

# Cambiar permisos para asegurar que Apache pueda acceder a los archivos
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Limpiar la caché de apt
RUN rm -rf /var/lib/apt/lists/*

# Exponer el puerto 90 para el servidor web
EXPOSE 90

# Comando para ejecutar Apache en primer plano
CMD ["apachectl", "-D", "FOREGROUND"]

