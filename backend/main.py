from fastapi import FastAPI
import time
import random

app = FastAPI()

@app.get("/")
def home():
    return {"message": "Backend funcionando"}

@app.get("/products")
def products():

    time.sleep(random.uniform(0.1,0.5))

    return [
        {"id":1,"name":"Laptop"},
        {"id":2,"name":"Mouse"},
        {"id":3,"name":"Teclado"}
    ]
