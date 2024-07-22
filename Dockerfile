FROM alpine

RUN sed -i 's/https/http/g' /etc/apk/repositories && \
apk add apache2 php php-mysqli php-apache2 php-json php-curl php-gd php-mysqlnd && \
sed -i 's/index.html/index.php/' /etc/apache2/httpd.conf && \
wget https://ko.wordpress.org/wordpress-6.5.5-ko_KR.tar.gz -O wordpress.tar.gz && \
tar xvfz wordpress.tar.gz  && \
cp /wordpress/wp-config-sample.php /wordpress/wp-config.php && \
sed -i 's/database_name_here/wordpress/' /wordpress/wp-config.php && \
sed -i 's/username_here/root/' /wordpress/wp-config.php && \
sed -i 's/password_here/It12345!/' /wordpress/wp-config.php && \
sed -i 's/localhost/rds_endpoint_here/' /wordpress/wp-config.php && \
cp -ar /wordpress/* /var/www/localhost/htdocs/ && \
echo test > /var/www/localhost/htdocs/index.html

CMD ["httpd","-D","FOREGROUND"]

EXPOSE 80
