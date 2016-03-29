server {
    listen  80;

    server_name "~^(?<sub>.+)\.vagrant\.loc$";
    root /home/vagrant/web/$sub;

    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    error_page 404 /404.html;

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        fastcgi_index index.php;
        fastcgi_read_timeout 120;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    fastcgi_buffers 16 32k;
    fastcgi_buffer_size 32k;
}
