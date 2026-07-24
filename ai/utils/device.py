import torch

def get_device() -> torch.device:
    """Returns the active acceleration device (CUDA/GPU or CPU)."""
    return torch.device("cuda" if torch.cuda.is_available() else "cpu")

def print_device_info():
    """Prints diagnostic accelerator hardware details."""
    print("PyTorch Version:", torch.__version__)
    print("CUDA Available :", torch.cuda.is_available())
    if torch.cuda.is_available():
        print("Active GPU Name:", torch.cuda.get_device_name(0))
    else:
        print("⚠️ Accelerators not found. Using CPU.")
