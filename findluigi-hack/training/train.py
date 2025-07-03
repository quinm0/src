from ultralytics import YOLO

'''
Aggressive training for small, noisy pixel art images:
- More epochs
- Higher learning rate
- Stronger augmentation
- Smaller batch size
- Smaller image size (if your sprites are tiny)
- Lower early stopping patience
'''

my_data = "dataset.yaml"  # path to your dataset.yaml file
model = YOLO("yolov8n.pt")

results = model.train(
    data=my_data,
    epochs=200,            # much more training
    batch=1,               # see each image more often
    imgsz=320,             # smaller input size for small sprites
    lr0=0.5,               # very high learning rate for fast adaptation
    augment=True,          # enable all default augmentations
    hsv_h=0.2,             # strong color augmentation
    hsv_s=0.7,
    hsv_v=0.7,
    degrees=30,            # strong rotation
    translate=0.3,         # strong translation
    scale=0.7,             # strong scaling
    shear=15,              # strong shearing
    mosaic=0.1,            # always use mosaic augmentation
    mixup=0.2,              # use mixup
    patience=20,            # stop early if no improvement
    project="output",
    name="modelv"
)
# reference https://docs.ultralytics.com/modes/train/