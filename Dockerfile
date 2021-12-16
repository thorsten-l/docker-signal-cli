FROM ubuntu:20.04 as builder

RUN apt update && apt -y upgrade
RUN apt -y install curl wget gnupg git && mkdir /builder
WORKDIR /builder
RUN wget https://download.bell-sw.com/pki/GPG-KEY-bellsoft 
RUN apt-key add GPG-KEY-bellsoft
RUN echo "deb [arch=amd64] https://apt.bell-sw.com/ stable main" > /etc/apt/sources.list.d/bellsoft.list
RUN apt update
RUN apt install -y bellsoft-java17

RUN git clone https://github.com/thorsten-l/signal-cli.git

WORKDIR /builder/signal-cli

RUN ./gradlew build
RUN ./gradlew installDist

FROM ubuntu:20.04

WORKDIR /
COPY --from=builder /builder/signal-cli/build/install/signal-cli /signal-cli
COPY entrypoint.sh /

RUN apt update && apt -y upgrade && apt -y install wget gnupg && \
    wget https://download.bell-sw.com/pki/GPG-KEY-bellsoft && \
    apt-key add GPG-KEY-bellsoft && \
    echo "deb [arch=amd64] https://apt.bell-sw.com/ stable main" > /etc/apt/sources.list.d/bellsoft.list && \
    apt update && apt install -y bellsoft-java17 && \
    chmod 0755 /entrypoint.sh

VOLUME /root/.locale
EXPOSE 7583

ENTRYPOINT [ "/entrypoint.sh" ]
