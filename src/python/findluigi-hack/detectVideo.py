import cv2
import os
from ultralytics import YOLO

def detect_and_save_video(input_video, output_video, model, conf=0.5):
    cap = cv2.VideoCapture(input_video)
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    fps = cap.get(cv2.CAP_PROP_FPS)
    w = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    h = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    out = cv2.VideoWriter(output_video, fourcc, fps, (w, h))

    while True:
        ret, frame = cap.read()
        if not ret:
            break
        results = model.predict(frame, conf=conf)
        boxes = results[0].boxes
        for box in boxes:
            x1, y1, x2, y2 = map(int, box.xyxy[0])
            conf_score = float(box.conf[0])
            cls = int(box.cls[0])
            label = f"{model.names[cls]} {conf_score:.2f}" if hasattr(model, "names") else f"{cls} {conf_score:.2f}"
            color = (0, 255, 0)
            cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
            cv2.putText(frame, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, color, 2)
        out.write(frame)
    cap.release()
    out.release()
    print(f"Saved output video with detections to {output_video}")

if __name__ == "__main__":
    # Expect best.pt, input.mp4, and output.mp4 in the current directory
    model_path = os.path.join(os.path.dirname(__file__), "best.pt")
    input_video = os.path.join("/videos/input.mp4")
    output_video = os.path.join("/videos/output.mp4")

    # list all files in the current directory (and subdirectories) for debugging
    print("Files in current directory:")
    for root, dirs, files in os.walk(os.path.dirname(__file__)):
        for file in files:
            print(os.path.join(root, file)) 


    if not os.path.exists(model_path):
        raise FileNotFoundError(f"Model file not found: {model_path}")
    if not os.path.exists(input_video):
        raise FileNotFoundError(f"Input video not found: {input_video}")

    print(f"Using model: {model_path}")
    print(f"Input video: {input_video}")
    print(f"Output video: {output_video}")

    model = YOLO(model_path, task="detect")
    detect_and_save_video(input_video, output_video, model, conf=0.5)
    print("Detection complete.")
    print(f"Output saved to {output_video}")