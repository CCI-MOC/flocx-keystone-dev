ARG KEYSTONE_IMAGE_TAG=current-tripleo
FROM tripleomaster/centos-binary-keystone:${KEYSTONE_IMAGE_TAG}

RUN yum -y install uwsgi uwsgi-plugin-python
COPY runtime /runtime
CMD ["/bin/sh", "/runtime/startup.sh"]
