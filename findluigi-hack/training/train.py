from ultralytics import YOLO

'''
⚠ NOTE: selections do not prevent you from specifying a combination for a model that doesn't exist.
Reference the documentation for valid model specifications: https://docs.ultralytics.com/models
'''
# Use more epochs, lower batch size, and enable augmentation for small datasets
my_data = "/home/qmoran/everything/findluigi-hack/training/dataset.yaml"  # path to your dataset.yaml file
model = YOLO("/home/qmoran/everything/findluigi-hack/training/yolov8n.pt")
results = model.train(
    data=my_data,
    epochs=200,           # more epochs for small data
    batch=4,              # lower batch size
    imgsz=640,            # default image size
    lr0=0.01,             # slightly higher learning rate
    augment=True,         # enable data augmentation
    patience=50           # early stopping patience
)
# reference https://docs.ultralytics.com/modes/train/