FROM python:3.7-stretch

ADD https://raw.githubusercontent.com/MinaProtocol/mina/develop/dockerfiles/scripts/healthcheck-utilities.sh /healthcheck/utilities.sh

# Allows docker to cache installed dependencies between builds
COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . /code

RUN adduser --disabled-password --gecos '' unpriv
RUN chown -R unpriv: /code
WORKDIR /code

CMD [ "python3", "-u", "agent.py" ]