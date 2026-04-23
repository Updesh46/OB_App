FROM tomcat:8.5-jre8-alpine  

WORKDIR /usr/local/tomcat  

RUN rm -rf webapps/*  

COPY target/*.war webapps/ROOT.war  

EXPOSE 8080  

CMD ["catalina.sh", "run"]