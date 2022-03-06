FROM ubuntu:20.04

RUN apt-get update -y \
    && apt-get -qqy dist-upgrade \
    && apt-get -qqy install software-properties-common gettext-base unzip wget \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN wget -O- https://apt.corretto.aws/corretto.key | apt-key add -
RUN add-apt-repository 'deb https://apt.corretto.aws stable main'
RUN apt-get update; apt-get install -y java-11-amazon-corretto-jdk
RUN java -version

####################################################################################################
# Adding Google Chrome and ChromeDriver like described in
# https://github.com/markhobson/docker-maven-chrome

# Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update -qqy \
	&& apt-get -qqy install google-chrome-stable \
	&& rm /etc/apt/sources.list.d/google-chrome.list \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox --disable-dev-shm-usage/g' /opt/google/chrome/google-chrome

# ChromeDriver
ARG CHROME_DRIVER_VERSION=100.0.4896.20
RUN wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
	&& rm -rf /opt/chromedriver \
	&& unzip /tmp/chromedriver_linux64.zip -d /opt \
	&& rm /tmp/chromedriver_linux64.zip \
	&& mv /opt/chromedriver /opt/chromedriver-$CHROME_DRIVER_VERSION \
	&& chmod 755 /opt/chromedriver-$CHROME_DRIVER_VERSION \
	&& ln -fs /opt/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

# Xvfb
RUN apt-get update -qqy \
	&& apt-get -qqy install xvfb \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Copy files
RUN mkdir /chromedriver-docker-example
COPY target/chromedriver-docker-example-*.jar /chromedriver-docker-example/app.jar

WORKDIR /chromedriver-docker-example

EXPOSE 8080

CMD ["./app.jar"]
