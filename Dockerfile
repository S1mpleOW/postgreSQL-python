FROM python:3.10-slim-buster AS compile-image

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY . .

FROM python:3.10-slim-buster AS build-image
WORKDIR /app

COPY --from=compile-image /opt/venv /opt/venv
COPY  --from=compile-image /app/wait-for-it.sh /opt/wait-for-it.sh
RUN chmod +x /opt/wait-for-it.sh
RUN sed -i 's/\r//g' /opt/wait-for-it.sh
RUN /opt/wait-for-it.sh db:5432 -- echo "db is up"

COPY --from=compile-image /app .

ENV PATH="/opt/venv/bin:$PATH"
EXPOSE 8000
CMD ["uvicorn", "main:app", "--env-file", ".env", "--host", "0.0.0.0", "--port", "8000"]
