from ultralytics import YOLO, ASSETS
import os
import re

# find the folder with the most latest model build.
# in ./training/output/modelvXX where XX is the experiment number.
# automatically find the high numbered experiment folder
# and use the best model from that experiment.

def get_latest_model_path(base_dir="./training/output"):
    exp_dirs = [d for d in os.listdir(base_dir) if re.match(r"modelv\d+", d)]
    if not exp_dirs:
        raise FileNotFoundError("No experiment folders found in {}".format(base_dir))
    # Extract experiment numbers and sort
    exp_nums = [(d, int(re.findall(r"\d+", d)[0])) for d in exp_dirs]
    latest_exp = max(exp_nums, key=lambda x: x[1])[0]
    best_model_path = os.path.join(base_dir, latest_exp, "weights", "best.pt")
    if not os.path.exists(best_model_path):
        raise FileNotFoundError(f"No best.pt found in {best_model_path}")
    return best_model_path

# Usage:
# model_path = get_latest_model_path()
# model = YOLO(model_path, task="detect")


model_path = get_latest_model_path()
print(f"Using model: {model_path}")
model = YOLO(model_path, task="detect")
results = model(source="./training/test", conf=0.10)

for result in results:
    print(result.boxes.data)
    result.show()  # uncomment to view each result image
    
    # reference https://docs.ultralytics.com/modes/predict/ for more information.j