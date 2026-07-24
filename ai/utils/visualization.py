import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

def plot_training_history(history):
    """Plots training and validation loss/accuracy curves side-by-side."""
    epochs = range(1, len(history['train_loss']) + 1)
    
    plt.figure(figsize=(12, 5))
    
    # Loss Curve
    plt.subplot(1, 2, 1)
    plt.plot(epochs, history['train_loss'], label='Train Loss', color='royalblue')
    plt.plot(epochs, history['val_loss'], label='Val Loss', color='orange')
    plt.title('Training & Validation Loss')
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    
    # Accuracy Curve
    plt.subplot(1, 2, 2)
    plt.plot(epochs, history['train_acc'], label='Train Acc', color='royalblue')
    plt.plot(epochs, history['val_acc'], label='Val Acc', color='orange')
    plt.title('Training & Validation Accuracy')
    plt.xlabel('Epochs')
    plt.ylabel('Accuracy')
    plt.legend()
    
    plt.tight_layout()
    plt.show()

def plot_confusion_matrix(matrix, class_names, title="Confusion Matrix"):
    """Plots a labeled Seaborn heatmap for confusion matrices."""
    plt.figure(figsize=(14, 12))
    sns.heatmap(matrix, annot=False, cmap='Blues',
                xticklabels=class_names, yticklabels=class_names)
    plt.title(title, fontsize=16)
    plt.ylabel('True Label', fontsize=12)
    plt.xlabel('Predicted Label', fontsize=12)
    plt.tight_layout()
    plt.show()
