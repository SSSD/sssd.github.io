FROM fedora:31

WORKDIR /usr/src/app/
ADD . /usr/src/app/
RUN dnf install -y rubygems rubygem-jekyll rubygem-bundler ruby-devel make gcc gcc-c++ redhat-rpm-config zlib-devel libxml2-devel libxslt-devel \
    && bundle config build.nokogiri --use-system-libraries \
    && bundle install \
    && dnf remove -y ruby-devel make gcc gcc-c++ redhat-rpm-config zlib-devel libxml2-devel libxslt-devel \
    && dnf clean all
EXPOSE 4000
CMD bundle exec jekyll serve --host 0.0.0.0

# podman build -t sssd-doc .
# podman run --rm -p 4000:4000 -d sssd-doc

