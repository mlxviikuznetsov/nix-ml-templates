"""Shared code for the notebooks."""

import matplotlib.pyplot as plt


def set_plot_style() -> None:
    plt.rcParams.update({"figure.figsize": (8, 4), "axes.grid": True})
