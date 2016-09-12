FROM develar/java:8u45

MAINTAINER devicehive

ENV DH_VERSION="2.0.11"

RUN mkdir -p /opt/devicehive

ADD https://github.com/devicehive/devicehive-java-server/releases/download/${DH_VERSION}/devicehive-${DH_VERSION}-boot.jar /opt/devicehive/

#start script
ADD devicehive-start.sh /opt/devicehive/

VOLUME ["/var/log/devicehive"]

#installing devicehive admin console
RUN mkdir -p /opt/devicehive/admin
ADD https://github.com/devicehive/devicehive-admin-console/archive/2.0.4.tar.gz /tmp
RUN tar -C /tmp -xzf /tmp/2.0.4.tar.gz
RUN cp -r /tmp/devicehive-admin-console-2.0.4/* /opt/devicehive/admin/
RUN sed -i -e 's/restEndpoint.*/restEndpoint: location.origin + \"\/api\/rest\"\,/' /opt/devicehive/admin/scripts/config.js

#nginx
RUN apk --update add nginx
COPY nginx.conf /etc/nginx/nginx.conf
VOLUME ["/tmp/nginx"]

WORKDIR /opt/devicehive/

ENTRYPOINT ["/bin/sh"]

CMD ["./devicehive-start.sh"]

EXPOSE 80
