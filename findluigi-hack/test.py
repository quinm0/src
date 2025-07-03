from ultralytics import YOLO, ASSETS
import os
import re

# Set this variable to a specific experiment number (e.g., 12) to override auto-detection.
CUSTOM_MODEL_NUMBER = "3"  # e.g., "12" or leave as "" to auto-select latest

def get_latest_model_path(base_dir="./training/output", custom_model_number=""):
    if custom_model_number:
        exp_dir = f"modelv{custom_model_number}"
        best_model_path = os.path.join(base_dir, exp_dir, "weights", "best.pt")
        if not os.path.exists(best_model_path):
            raise FileNotFoundError(f"No best.pt found in {best_model_path}")
        return best_model_path
    exp_dirs = [d for d in os.listdir(base_dir) if re.match(r"modelv\d+", d)]
    if not exp_dirs:
        raise FileNotFoundError("No experiment folders found in {}".format(base_dir))
    exp_nums = [(d, int(re.findall(r"\d+", d)[0])) for d in exp_dirs]
    latest_exp = max(exp_nums, key=lambda x: x[1])[0]
    best_model_path = os.path.join(base_dir, latest_exp, "weights", "best.pt")
    if not os.path.exists(best_model_path):
        raise FileNotFoundError(f"No best.pt found in {best_model_path}")
    return best_model_path

# Usage:
model_path = get_latest_model_path(custom_model_number=CUSTOM_MODEL_NUMBER)
print(f"Using model: {model_path}")
model = YOLO(model_path, task="detect")

results = model(source="./training/test", conf=0.50)

for result in results:
    print(result.boxes.data)
    result.show()  # uncomment to view each result image
