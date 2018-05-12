FROM elementary/docker:juno-unstable

ARG USER_ID="1000"
ARG USER="x_eleven"

ENV USER=${USER}
# set display, so we can connect to host X server
ENV DISPLAY :0

# create a normal user for running terminal
# this might be pointless, as later we hack sudo to allow installation without pw
RUN useradd --non-unique --uid ${USER_ID} --create-home ${USER}

# install dependencies one-by-one so that changes don't always invalidate the docker cache
RUN apt-get update
RUN apt-get install -qqy libgranite-dev
RUN apt-get install -qqy libvte-2.91-dev
RUN apt-get install -qqy meson
RUN apt-get install -qqy valac
RUN apt-get install -qqy desktop-file-utils
RUN apt-get install -qqy appstream
RUN apt-get install -qqy sudo

# used to install terminal without pw
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

# drop root privileges from now on
USER ${USER_ID}

# drop into a shell when running this container
CMD ["/bin/bash"]

# we expect the project directory to be mounted to /src
# ex: -v $PWD:/src/
WORKDIR /src
