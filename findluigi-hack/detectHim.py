import cv2
import os
import re
from ultralytics import YOLO

# Set this variable to a specific experiment number (e.g., 12) to override auto-detection.
CUSTOM_MODEL_NUMBER = ""  # e.g., "12" or leave as "" to auto-select latest

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

def detect_and_save_video(input_video, output_video, model, conf=0.5, show_classes=None):
    cap = cv2.VideoCapture(input_video)
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    fps = cap.get(cv2.CAP_PROP_FPS)
    w = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    h = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    out = cv2.VideoWriter(output_video, fourcc, fps, (w, h))

    frame_idx = 0
    class_frame_counts = {}  # {class_idx: number of frames detected}
    class_occurrences = {}   # {class_idx: number of occurrences (boxes)}

    while True:
        ret, frame = cap.read()
        if not ret:
            break
        results = model.predict(frame, conf=conf)
        boxes = results[0].boxes

        detected_classes_in_frame = set()
        for box in boxes:
            cls = int(box.cls[0])
            if show_classes is not None and cls not in show_classes:
                continue
            x1, y1, x2, y2 = map(int, box.xyxy[0])
            conf_score = float(box.conf[0])
            label = f"{model.names[cls]} {conf_score:.2f}" if hasattr(model, "names") else f"{cls} {conf_score:.2f}"
            color = (0, 255, 0)
            cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
            cv2.putText(frame, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, color, 2)

            # Count occurrences
            class_occurrences[cls] = class_occurrences.get(cls, 0) + 1
            detected_classes_in_frame.add(cls)

        # Count frames where each class appears
        for cls in detected_classes_in_frame:
            class_frame_counts[cls] = class_frame_counts.get(cls, 0) + 1

        out.write(frame)
        frame_idx += 1

    cap.release()
    out.release()
    print(f"Saved output video with detections to {output_video}")

    # Print stats
    print("\nDetection statistics:")
    for cls, frames in class_frame_counts.items():
        percent = 100.0 * frames / frame_idx if frame_idx else 0
        occurrences = class_occurrences.get(cls, 0)
        name = model.names[cls] if hasattr(model, "names") else str(cls)
        print(f"Class {name} (id {cls}):")
        print(f"  - Appeared in {frames}/{frame_idx} frames ({percent:.2f}%)")
        print(f"  - Total occurrences (boxes): {occurrences}")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Run YOLO detection on a video and save output with bounding boxes.")
    parser.add_argument("input_video", help="Path to input video")
    parser.add_argument("output_video", help="Path to save output video")
    parser.add_argument("--conf", type=float, default=0.5, help="Confidence threshold")
    parser.add_argument("--classes", type=str, default="", help="Comma-separated list of class indices to show (e.g., 0,2,5)")
    args = parser.parse_args()

    show_classes = None
    if args.classes:
        show_classes = set(int(x) for x in args.classes.split(",") if x.strip().isdigit())

    model_path = get_latest_model_path(custom_model_number=CUSTOM_MODEL_NUMBER)
    print(f"Using model: {model_path}")
    model = YOLO(model_path, task="detect")
    detect_and_save_video(args.input_video, args.output_video, model, conf=args.conf, show_classes=show_classes)
