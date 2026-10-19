import typer
import uvicorn

from .model import MODEL_PATH
from .model import train as train_model

app = typer.Typer(help="ML service: training and serving")


@app.command()
def train() -> None:
    """Train the model and save it to disk."""
    acc = train_model()
    typer.echo(f"Model saved to {MODEL_PATH} (train accuracy: {acc:.3f})")


@app.command()
def serve(host: str = "127.0.0.1", port: int = 8000) -> None:
    """Start the HTTP API."""
    uvicorn.run("ml_service.api:app", host=host, port=port)
