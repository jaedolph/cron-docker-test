FROM ubi8/ubi

RUN yum install -y cronie
RUN chmod ug+s /usr/sbin/crond

RUN  sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond
RUN chmod ug+s /usr/sbin/crond

RUN useradd test -G root
RUN chown test:root /var/run
RUN chmod g+w /var/run

COPY test-cron /etc/cron.d/test-cron

USER test
RUN touch /tmp/test.txt

RUN crontab /etc/cron.d/test-cron
RUN mkfifo /tmp/cronpipe

CMD crond  && tail -f /tmp/cronpipe
