import cv2
import numpy as np
import hashlib
import os
import argparse
import sys

def file_hash(filepath):
  hasher = hashlib.sha256()
  with open(filepath, 'rb') as f:
    while chunk := f.read(8192):
      hasher.update(chunk)
  return hasher.hexdigest()[:8]

def main():
  parser = argparse.ArgumentParser(description="Extract and display frames from a video file.")
  parser.add_argument('video_path', nargs='?', default='findhim.mp4', help='Path to the video file')
  parser.add_argument('--show', action='store_true', help='Show frames using OpenCV')
  parser.add_argument('--dump', action='store_true', help='Print pixel values to console')
  parser.add_argument('--show-diff', action='store_true', help='Show absolute difference between consecutive frames')
  parser.add_argument('--save-diff', action='store_true', help='Save absolute difference between consecutive frames as a video')
  parser.add_argument('--mosh', action='store_true', help='Apply datamosh effect (randomly shuffle pixels in each frame and save as video)')
  parser.add_argument('--track', action='store_true', help='Track moving objects and save video with bounding boxes')
  parser.add_argument('--track-diff', action='store_true', help='Track objects using frame differences for tighter bounding boxes and save both annotated diff and tracking videos')
  parser.add_argument('--slow', action='store_true', help='Slow down output videos for analysis')
  args = parser.parse_args()

  video_path = args.video_path
  hash_str = file_hash(video_path)
  npy_filename = f'frames_pixels_{hash_str}.npy'

  output_fps = 10.0 if args.slow else 30.0

  if os.path.exists(npy_filename):
    print(f"Loading frames from {npy_filename}")
    frames_array = np.load(npy_filename)

    for i, frame in enumerate(frames_array):
      print(f"Frame {i}: shape={frame.shape}, dtype={frame.dtype}")
      if args.dump:
        print(frame)
      if args.show:
        cv2.imshow(f'Frame {i}', frame)
        while True:
          key = cv2.waitKey(100)
          if key != -1 or cv2.getWindowProperty(f'Frame {i}', cv2.WND_PROP_VISIBLE) < 1:
            break
        cv2.destroyAllWindows()
    if args.show_diff:
      for i in range(len(frames_array) - 1):
        frame1 = frames_array[i]
        frame2 = frames_array[i+1]
        if frame1 is None or frame2 is None:
          continue
        if frame1.shape != frame2.shape:
          continue
        diff = cv2.absdiff(frame1, frame2)
        cv2.imshow(f'Diff Frame {i}-{i+1}', diff)
        while True:
          key = cv2.waitKey(100)
          if key != -1 or cv2.getWindowProperty(f'Diff Frame {i}-{i+1}', cv2.WND_PROP_VISIBLE) < 1:
            break
        cv2.destroyAllWindows()
    if args.save_diff:
      print("Saving diff video as diff_output.mp4")
      # Find the first valid frame for shape and dtype
      for f in frames_array:
        if f is not None:
          height, width = f.shape[:2]
          channels = f.shape[2] if len(f.shape) == 3 else 1
          dtype = f.dtype
          break
      fourcc = cv2.VideoWriter_fourcc(*'mp4v')
      out = cv2.VideoWriter('diff_output.mp4', fourcc, output_fps, (width, height))
      for i in range(len(frames_array) - 1):
        frame1 = frames_array[i]
        frame2 = frames_array[i+1]
        if (
          frame1 is None or frame2 is None or
          frame1.shape != frame2.shape or
          frame1.dtype != np.uint8 or frame2.dtype != np.uint8
        ):
          print(f"Skipping diff for frames {i} and {i+1} due to shape or dtype mismatch.")
          continue
        diff = cv2.absdiff(frame1, frame2)
        diff = cv2.flip(diff, 0)  # Flip vertically
        # Ensure diff is 3-channel BGR
        if len(diff.shape) == 2:
          diff = cv2.cvtColor(diff, cv2.COLOR_GRAY2BGR)
        out.write(diff)
      out.release()
      print("Diff video saved as diff_output.mp4")
    if args.mosh:
      print("Applying gentle datamosh effect (lag and glitch) and saving as mosh_output.mp4")
      # Find the first valid frame for shape and dtype
      for f in frames_array:
        if f is not None:
          height, width = f.shape[:2]
          channels = f.shape[2] if len(f.shape) == 3 else 1
          dtype = f.dtype
          break
      fourcc = cv2.VideoWriter_fourcc(*'mp4v')
      out = cv2.VideoWriter('mosh_output.mp4', fourcc, output_fps, (width, height))
      total_frames = len(frames_array)
      prev_frame = None
      for i, frame in enumerate(frames_array):
        if frame is None or frame.shape[:2] != (height, width) or frame.dtype != np.uint8:
          print(f"Skipping frame {i} due to shape or dtype mismatch.")
          continue

        # Lag effect: with 1/12 probability, repeat the previous frame
        if prev_frame is not None and np.random.rand() < 1/12:
          mosh_frame = prev_frame.copy()
        else:
          mosh_frame = frame.copy()
          # Glitch effect: swap a few random blocks in the frame
          for _ in range(np.random.randint(1, 4)):  # 1-3 glitches per frame
            block_size = np.random.choice([16, 32, 48])
            x1 = np.random.randint(0, width - block_size)
            y1 = np.random.randint(0, height - block_size)
            x2 = np.random.randint(0, width - block_size)
            y2 = np.random.randint(0, height - block_size)
            # Swap blocks
            temp = mosh_frame[y1:y1+block_size, x1:x1+block_size].copy()
            mosh_frame[y1:y1+block_size, x1:x1+block_size] = mosh_frame[y2:y2+block_size, x2:x2+block_size]
            mosh_frame[y2:y2+block_size, x2:x2+block_size] = temp

        out.write(mosh_frame)
        prev_frame = mosh_frame
        if (i + 1) % 10 == 0 or i == total_frames - 1:
          print(f"Processed {i + 1}/{total_frames} frames for gentle datamosh...")
      out.release()
      print("Mosh video saved as mosh_output.mp4")
    if args.track:
      print("Tracking individual PNG objects and saving as track_output.mp4")
      for f in frames_array:
        if f is not None:
          height, width = f.shape[:2]
          break
      fourcc = cv2.VideoWriter_fourcc(*'mp4v')
      out = cv2.VideoWriter('track_output.mp4', fourcc, output_fps, (width, height))
      total_frames = len(frames_array)
      next_id = 1
      tracked_objects = {}  # id: (cx, cy)

      for i, frame in enumerate(frames_array):
        if frame is None or frame.shape[:2] != (height, width) or frame.dtype != np.uint8:
          print(f"Skipping frame {i} due to shape or dtype mismatch.")
          continue
        # Mask for non-black pixels
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        _, fgMask = cv2.threshold(gray, 10, 255, cv2.THRESH_BINARY)
        kernel = np.ones((5,5), np.uint8)
        fgMask = cv2.morphologyEx(fgMask, cv2.MORPH_OPEN, kernel)
        fgMask = cv2.morphologyEx(fgMask, cv2.MORPH_DILATE, kernel)
        num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(fgMask)
        # Get valid blobs
        blobs = []
        for j in range(1, num_labels):
          area = stats[j, cv2.CC_STAT_AREA]
          if area > 500:
            cx, cy = int(centroids[j][0]), int(centroids[j][1])
            x, y, w, h = stats[j, cv2.CC_STAT_LEFT], stats[j, cv2.CC_STAT_TOP], stats[j, cv2.CC_STAT_WIDTH], stats[j, cv2.CC_STAT_HEIGHT]
            blobs.append({'centroid': (cx, cy), 'bbox': (x, y, w, h), 'matched': False, 'id': None})

        # Match blobs to tracked_objects using nearest centroid
        updated_tracked = {}
        for obj_id, (prev_cx, prev_cy) in tracked_objects.items():
          min_dist = float('inf')
          min_blob = None
          for blob in blobs:
            if blob['matched']:
              continue
            cx, cy = blob['centroid']
            dist = np.hypot(cx - prev_cx, cy - prev_cy)
            if dist < min_dist and dist < 50:  # max movement threshold
              min_dist = dist
              min_blob = blob
          if min_blob is not None:
            min_blob['matched'] = True
            min_blob['id'] = obj_id
            updated_tracked[obj_id] = min_blob['centroid']

        # Assign new IDs to unmatched blobs
        for blob in blobs:
          if not blob['matched']:
            blob['id'] = next_id
            updated_tracked[next_id] = blob['centroid']
            next_id += 1

        # Draw boxes and IDs
        frame_boxed = frame.copy()
        for blob in blobs:
          x, y, w, h = blob['bbox']
          cx, cy = blob['centroid']
          obj_id = blob['id']

          # Smooth the centroid over the history
          history_len = 5  # Number of frames to smooth over
          if 'history' not in blob:
              blob['history'] = []
          blob['history'].append(blob['centroid'])
          if len(blob['history']) > history_len:
              blob['history'].pop(0)
          # Compute smoothed centroid
          sx = int(np.mean([c[0] for c in blob['history']]))
          sy = int(np.mean([c[1] for c in blob['history']]))

          # Draw using smoothed centroid
          cv2.rectangle(frame_boxed, (x, y), (x+w, y+h), (0, 255, 0), 2)
          cv2.circle(frame_boxed, (sx, sy), 8, (0, 0, 255), -1)
          cv2.putText(frame_boxed, f'ID {obj_id}', (x, y-10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255,255,0), 2)
        tracked_objects = updated_tracked

        out.write(frame_boxed)
        if (i + 1) % 10 == 0 or i == total_frames - 1:
          print(f"Processed {i + 1}/{total_frames} frames for tracking...")
      out.release()
      print("Tracking video saved as track_output.mp4")
    if args.track_diff:
      print("Tracking objects using differential data and saving as trackdiff_output.mp4 and diff_with_boxes.mp4")
      # Find the first valid frame for shape and dtype
      for f in frames_array:
        if f is not None:
          height, width = f.shape[:2]
          break
      fourcc = cv2.VideoWriter_fourcc(*'mp4v')
      out_track = cv2.VideoWriter('trackdiff_output.mp4', fourcc, output_fps, (width, height))
      out_diff = cv2.VideoWriter('diff_with_boxes.mp4', fourcc, output_fps, (width, height))
      total_frames = len(frames_array)
      next_id = 1
      tracked_objects = {}  # id: (cx, cy)

      for i in range(len(frames_array) - 1):
        frame1 = frames_array[i]
        frame2 = frames_array[i+1]
        if (frame1 is None or frame2 is None or
            frame1.shape != frame2.shape or
            frame1.dtype != np.uint8 or frame2.dtype != np.uint8):
          print(f"Skipping diff for frames {i} and {i+1} due to shape or dtype mismatch.")
          continue
        diff = cv2.absdiff(frame1, frame2)
        # Use grayscale diff for mask
        gray = cv2.cvtColor(diff, cv2.COLOR_BGR2GRAY)
        _, fgMask = cv2.threshold(gray, 25, 255, cv2.THRESH_BINARY)
        kernel = np.ones((5,5), np.uint8)
        fgMask = cv2.morphologyEx(fgMask, cv2.MORPH_OPEN, kernel)
        fgMask = cv2.morphologyEx(fgMask, cv2.MORPH_DILATE, kernel)
        num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(fgMask)
        # Get valid blobs
        blobs = []
        for j in range(1, num_labels):
          area = stats[j, cv2.CC_STAT_AREA]
          if area > 100:  # Lower threshold for tighter bounds
            cx, cy = int(centroids[j][0]), int(centroids[j][1])
            x, y, w, h = stats[j, cv2.CC_STAT_LEFT], stats[j, cv2.CC_STAT_TOP], stats[j, cv2.CC_STAT_WIDTH], stats[j, cv2.CC_STAT_HEIGHT]
            blobs.append({'centroid': (cx, cy), 'bbox': (x, y, w, h), 'matched': False, 'id': None})

        # Match blobs to tracked_objects using nearest centroid
        updated_tracked = {}
        for obj_id, (prev_cx, prev_cy) in tracked_objects.items():
          min_dist = float('inf')
          min_blob = None
          for blob in blobs:
            if blob['matched']:
              continue
            cx, cy = blob['centroid']
            dist = np.hypot(cx - prev_cx, cy - prev_cy)
            if dist < min_dist and dist < 50:
              min_dist = dist
              min_blob = blob
          if min_blob is not None:
            min_blob['matched'] = True
            min_blob['id'] = obj_id
            updated_tracked[obj_id] = min_blob['centroid']

        # Assign new IDs to unmatched blobs
        for blob in blobs:
          if not blob['matched']:
            blob['id'] = next_id
            updated_tracked[next_id] = blob['centroid']
            next_id += 1

        # Draw boxes and IDs on both diff and original frame
        frame_boxed = frame2.copy()
        diff_boxed = diff.copy()
        for blob in blobs:
          x, y, w, h = blob['bbox']
          cx, cy = blob['centroid']
          obj_id = blob['id']

          # Smooth the centroid over the history
          history_len = 5  # Number of frames to smooth over
          if 'history' not in blob:
              blob['history'] = []
          blob['history'].append(blob['centroid'])
          if len(blob['history']) > history_len:
              blob['history'].pop(0)
          # Compute smoothed centroid
          sx = int(np.mean([c[0] for c in blob['history']]))
          sy = int(np.mean([c[1] for c in blob['history']]))

          # Draw using smoothed centroid
          cv2.rectangle(frame_boxed, (x, y), (x+w, y+h), (0, 255, 0), 2)
          cv2.circle(frame_boxed, (sx, sy), 8, (0, 0, 255), -1)
          cv2.putText(frame_boxed, f'ID {obj_id}', (x, y-10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255,255,0), 2)
          cv2.rectangle(diff_boxed, (x, y), (x+w, y+h), (0, 255, 0), 2)
          cv2.circle(diff_boxed, (sx, sy), 8, (0, 0, 255), -1)
          cv2.putText(diff_boxed, f'ID {obj_id}', (x, y-10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255,255,0), 2)
        tracked_objects = updated_tracked

        out_track.write(frame_boxed)
        out_diff.write(diff_boxed)
        if (i + 1) % 10 == 0 or i == total_frames - 2:
          print(f"Processed {i + 1}/{total_frames-1} frames for track-diff...")
      out_track.release()
      out_diff.release()
      print("Track-diff videos saved as trackdiff_output.mp4 (original with boxes) and diff_with_boxes.mp4 (diff with boxes)")
    print("All frames loaded successfully.")
  else:
    print(f"Extracting frames and saving to {npy_filename}")
    vidcap = cv2.VideoCapture(video_path)
    frames = []
    success, image = vidcap.read()
    while success:
      frames.append(image)
      success, image = vidcap.read()
    frames_array = np.array(frames)
    np.save(npy_filename, frames_array)

if __name__ == "__main__":
  main()
