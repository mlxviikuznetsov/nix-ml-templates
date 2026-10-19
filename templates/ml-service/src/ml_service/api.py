from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from .model import CLASSES, MODEL_PATH, load

app = FastAPI(title="ml-service")
_model = None


class IrisFeatures(BaseModel):
    sepal_length: float
    sepal_width: float
    petal_length: float
    petal_width: float


def get_model():
    global _model
    if _model is None:
        if not MODEL_PATH.exists():
            raise HTTPException(503, "Model is not trained: run `ml-service train`")
        _model = load()
    return _model


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/predict")
def predict(f: IrisFeatures) -> dict[str, str]:
    model = get_model()
    idx = int(model.predict([[f.sepal_length, f.sepal_width, f.petal_length, f.petal_width]])[0])
    return {"class": CLASSES[idx]}
