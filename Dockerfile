
FROM mautic/mautic:5-apache

# Redis extension
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libzstd-dev \
      liblz4-dev \
 && pecl install redis \
 && docker-php-ext-enable redis \
 && apt-get purge -y --auto-remove libzstd-dev liblz4-dev \
 && rm -rf /var/lib/apt/lists/* /tmp/pear

# Entry wrapper
COPY docker-entrypoint-mautic.sh /docker-entrypoint-mautic.sh
RUN chmod +x /docker-entrypoint-mautic.sh

ENTRYPOINT ["/docker-entrypoint-mautic.sh"]
CMD ["apache2-foreground"]
