from pathlib import Path

import joblib
from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler

MODEL_PATH = Path("model.joblib")
CLASSES = ["setosa", "versicolor", "virginica"]


def train(path: Path = MODEL_PATH) -> float:
    X, y = load_iris(return_X_y=True)
    model = make_pipeline(StandardScaler(), LogisticRegression(max_iter=1000))
    model.fit(X, y)
    joblib.dump(model, path)
    return model.score(X, y)


def load(path: Path = MODEL_PATH):
    return joblib.load(path)
