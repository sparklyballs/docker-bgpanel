FROM linuxserver/baseimage.apache

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

ENV APTLIST="git-core mysql-server mysqltuner php5-gd php5-mcrypt php5-mysqlnd"
ENV MYSQL_DIR="/config"
ENV DATADIR=$MYSQL_DIR/databases

# set debconf selections to not show apt messages about mysql data paths etc..
RUN { echo mysql-community-server mysql-community-server/data-dir select ''; \
echo mysql-community-server mysql-community-server/root-pass password ''; \
echo mysql-community-server mysql-community-server/re-root-pass password ''; \
echo mysql-community-server mysql-community-server/remove-test-db select false; } | debconf-set-selections

# install packages
RUN apt-get update -q && \
apt-get install $APTLIST -qy && \

# cleanup
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# add Custom files
ADD defaults/ /defaults/
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh && \

sed -i 's/key_buffer\b/key_buffer_size/g' /etc/mysql/my.cnf && \
sed -ri 's/^(bind-address|skip-networking)/;\1/' /etc/mysql/my.cnf && \
sed -i s#/var/log/mysql#/config/log/mysql#g /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 abc/g' /etc/mysql/my.cnf && \
sed -i -e "s#\(datadir.*=\).*#\1 $DATADIR#g" /etc/mysql/my.cnf && \
cp /etc/mysql/my.cnf /defaults/my.cnf

# ports and volumes
EXPOSE 80
VOLUME /config
