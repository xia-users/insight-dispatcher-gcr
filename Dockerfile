FROM python:3.8-slim
# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True
# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY LICENSE LICENSE
COPY config config
COPY routes.zip config/routes.zip
COPY static static
COPY templates templates
COPY requirements.txt requirements.txt
COPY main.py main.py
# Install production dependencies.
RUN pip install -r requirements.txt
# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app