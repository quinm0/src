import cv2
import os
import glob
import shutil
import argparse

def extract_frames_from_video(video_path, out_dir):
    base = os.path.splitext(os.path.basename(video_path))[0]
    cap = cv2.VideoCapture(video_path)
    frame_idx = 0
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        frame_filename = os.path.join(out_dir, f"{base}-frame_{frame_idx:05d}.png")
        cv2.imwrite(frame_filename, frame)
        frame_idx += 1
    cap.release()
    print(f"Extracted {frame_idx} frames from {video_path} to {out_dir}")

def expand_all_videos(video_dir, out_dir):
    # Remove and recreate output directory
    if os.path.exists(out_dir):
        shutil.rmtree(out_dir)
    os.makedirs(out_dir, exist_ok=True)

    video_files = []
    for ext in ("*.mp4", "*.avi", "*.mov", "*.mkv"):
        video_files.extend(glob.glob(os.path.join(video_dir, ext)))

    for video_file in video_files:
        extract_frames_from_video(video_file, out_dir)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract frames from all videos in a directory.")
    parser.add_argument("video_dir", help="Directory containing video files")
    parser.add_argument("output_dir", help="Directory to save extracted frames")
    args = parser.parse_args()

    expand_all_videos(args.video_dir, args.output_dir)