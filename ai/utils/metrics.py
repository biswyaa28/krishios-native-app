import numpy as np
from sklearn.metrics import classification_report, confusion_matrix, f1_score

def calculate_f1_score(y_true, y_pred, average="weighted"):
    """Calculates classification F1-Score."""
    return f1_score(y_true, y_pred, average=average)

def generate_evaluation_report(y_true, y_pred, target_names=None):
    """Generates standard classification metric report and confusion matrix."""
    report = classification_report(y_true, y_pred, target_names=target_names)
    matrix = confusion_matrix(y_true, y_pred)
    return report, matrix
