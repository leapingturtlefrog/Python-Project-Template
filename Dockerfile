FROM python:3.10-slim
WORKDIR /usr/src/app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY src/ .
EXPOSE 8501
HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health
ENTRYPOINT ["streamlit", "run", "app.py", "--server.address=0.0.0.0"]
