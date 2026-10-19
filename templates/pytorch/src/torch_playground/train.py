"""Toy regression: an MLP learns to approximate sin(x)."""

import torch
from torch import nn


def make_data(n: int = 1024, seed: int = 0) -> tuple[torch.Tensor, torch.Tensor]:
    g = torch.Generator().manual_seed(seed)
    x = torch.rand(n, 1, generator=g) * 6 - 3
    y = torch.sin(x) + 0.1 * torch.randn(n, 1, generator=g)
    return x, y


def main() -> None:
    print(f"torch {torch.__version__}, cuda: {torch.cuda.is_available()}")
    torch.manual_seed(0)

    x, y = make_data()
    model = nn.Sequential(
        nn.Linear(1, 64), nn.Tanh(),
        nn.Linear(64, 64), nn.Tanh(),
        nn.Linear(64, 1),
    )
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-2)
    loss_fn = nn.MSELoss()

    for epoch in range(501):
        optimizer.zero_grad()
        loss = loss_fn(model(x), y)
        loss.backward()
        optimizer.step()
        if epoch % 100 == 0:
            print(f"epoch {epoch:4d}  loss {loss.item():.4f}")

    torch.save(model.state_dict(), "model.pt")
    print("Saved: model.pt")


if __name__ == "__main__":
    main()
