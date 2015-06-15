#!/bin/bash
 
apt-get -q update
apt-get -qyy install apache2
service apache2 stop
 
cat << EOF > /var/www/html/index.html
<html>

<body>

  <h1>App server #${id} $(cat /etc/issue.net)</h1>
  <img src="http://www.coolthings.com.au/sites/default/files/imagecache/product_full/the_internet_ani_lrg.gif">

</body>
EOF

cat /var/www/html/index.html

service apache2 start
