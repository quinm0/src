import cv2
import os
import argparse

def extract_frames(video_path, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    cap = cv2.VideoCapture(video_path)
    frame_idx = 0
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        frame_filename = os.path.join(output_dir, f"frame_{frame_idx:05d}.png")
        cv2.imwrite(frame_filename, frame)
        frame_idx += 1
    cap.release()
    print(f"Extracted {frame_idx} frames to {output_dir}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract frames from a video file.")
    parser.add_argument("video_path", help="Path to the input video file")
    parser.add_argument("output_dir", help="Directory to save extracted frames")
    args = parser.parse_args()
    extract_frames(args.video_path, args.output_dir)