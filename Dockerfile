# automatically generated from https://github.com/metwork-framework/github_organization_management/blob/master/common_files/docker-mfxxx-yyy-buildimage_Dockerfile)


    
    
    



    
    


ARG BRANCH=master
FROM metwork/mfxxx-centos8-buildimage:${BRANCH} as yum_cache
ARG BRANCH
RUN echo -e "[metwork_${BRANCH}]\n\
name=Metwork Continuous Integration Branch ${BRANCH}\n\
baseurl=http://metwork-framework.org/pub/metwork/continuous_integration/rpms/${BRANCH}/centos8/\n\
gpgcheck=0\n\
enabled=1\n\
metadata_expire=0\n" >/etc/yum.repos.d/metwork.repo
ARG CACHEBUST=0
RUN yum clean all
RUN yum --disablerepo=* --enablerepo=metwork_${BRANCH} -q list metwork-mfserv-full* 2>/dev/null |sort |md5sum |awk '{print $1;}' > /tmp/yum_cache

FROM metwork/mfxxx-centos8-buildimage:${BRANCH}
ARG BRANCH
COPY --from=yum_cache /etc/yum.repos.d/metwork.repo /etc/yum.repos.d/
COPY --from=yum_cache /tmp/yum_cache .
RUN yum clean all
RUN yum -y install metwork-mfserv-full langpacks-fr
