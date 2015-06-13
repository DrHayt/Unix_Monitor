# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>

FROM centos:6
MAINTAINER Rick Moran <moran@morangroup.org>

#   Start off with a cleanly patched system.
RUN yum -y install \
        epel-release \
        tar \
        yum-plugin-downloadonly \
        yum-utils ; \
    yum -y install \
        perl-Crypt-SSLeay \
        perl-JSON \
        perl-libwww-perl \
        perl-Net-Statsd \
        perl-Scope-Guard \
        perl-Time-HiRes ; \
    sed -i 's/localhost/graphite/g' /usr/share/perl5/vendor_perl/Net/Statsd.pm

#  Install SGMonitor
RUN curl -L https://github.com/DrHayt/Unix_Monitor/archive/1.0.6.tar.gz | (cd /usr/share/perl5; tar --strip=1 -xzf -) ; \
    mv /usr/share/perl5/wrapper.pl /usr/bin/monitor_wrapper.pl  ; \
    curl -L http://search.cpan.org/CPAN/authors/id/M/MA/MASAKI/LWP-UserAgent-DNS-Hosts-0.08.tar.gz | (cd /usr/share/perl5; tar --strip=2 -xzf - LWP-UserAgent-DNS-Hosts-0.08/lib) 

ENTRYPOINT ["monitor_wrapper.pl"]
