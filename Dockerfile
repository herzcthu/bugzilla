FROM httpd:latest
MAINTAINER Sithu Thwin <sithu@thwin.net>

RUN apt update && \
  apt -yyyqqq install git vim libappconfig-perl libdate-calc-perl libtemplate-perl libmime-tools-perl \
  build-essential libdatetime-timezone-perl libdatetime-perl libemail-sender-perl libemail-mime-perl \ 
  libemail-mime-modifier-perl libdbi-perl libdbd-mysql-perl libcgi-pm-perl libmath-random-isaac-perl \ 
  libmath-random-isaac-xs-perl libapache2-mod-perl2 libapache2-mod-perl2-dev \ 
  libchart-perl libxml-perl libxml-twig-perl perlmagick libgd-graph-perl libtemplate-plugin-gd-perl \ 
  libsoap-lite-perl libhtml-scrubber-perl libjson-rpc-perl libdaemon-generic-perl libtheschwartz-perl \ 
  libtest-taint-perl libauthen-radius-perl libfile-slurp-perl libencode-detect-perl libmodule-build-perl \ 
  libnet-ldap-perl libauthen-sasl-perl libfile-mimeinfo-perl libemail-address-perl\ 
  libhtml-formattext-withlinks-perl libfile-which-perl libgd-dev graphviz python-sphinx rst2pdf

WORKDIR /usr/local/apache2

RUN rm -rf htdocs && git clone --branch release-5.0-stable https://github.com/bugzilla/bugzilla htdocs

WORKDIR /usr/local/apache2/htdocs

RUN ./install-module.pl --all

WORKDIR /usr/local/apache2

RUN sed -i -e 's/daemon/www-data/' \
           -e 's/#\(LoadModule .*mod_cgi\)/\1/' \
           -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
           -e 's/^#\(LoadModule .*mod_expires.so\)/\1/' \
           -e 's/#\(AddHandler cgi-script .cgi\)/\1/' \
           conf/httpd.conf

RUN perl -i -p0e 's/(?<=htdocs">).*(?=<\/Directory)/\nAddHandler cgi-script .cgi\nOptions +Indexes +ExecCGI\nDirectoryIndex index.cgi\nAllowOverride All\nRequire all granted\n/igs' conf/httpd.conf

RUN chown -Rf www-data:www-data htdocs

EXPOSE 80 5900

