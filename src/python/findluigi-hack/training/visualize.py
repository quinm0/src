import cv2, glob, os, itertools

img_patterns = [
  "labeled/**/*.jpg",
  "labeled/**/*.jpeg",
  "labeled/**/*.png"
]

img_paths = itertools.chain.from_iterable(glob.glob(p, recursive=True) for p in img_patterns)

for img_path in img_paths:
  ext = os.path.splitext(img_path)[1].lower()
  if ext not in ['.jpg', '.jpeg', '.png']:
    continue
  label_path = os.path.splitext(img_path)[0] + '.txt'
  img = cv2.imread(img_path)
  if img is None:
    print(f"Could not read {img_path}")
    continue
  h, w = img.shape[:2]
  if not os.path.exists(label_path):
    print(f"Missing label: {label_path}")
    continue
  with open(label_path) as f:
    for line in f:
      parts = line.strip().split()
      if len(parts) != 5: continue
      cid, xc, yc, bw, bh = map(float, parts)
      x1, y1 = int((xc-bw/2)*w), int((yc-bh/2)*h)
      x2, y2 = int((xc+bw/2)*w), int((yc+bh/2)*h)
      cv2.rectangle(img, (x1,y1), (x2,y2), (0,255,0), 2)
  cv2.imshow('img', img)
  if cv2.waitKey(0) == 27: break
cv2.destroyAllWindows()