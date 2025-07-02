from ultralytics import YOLO, ASSETS

model = YOLO("/home/qmoran/everything/findluigi-hack/runs/train6/weights/best.pt", task="detect")
results = model(source="./training/test")

for result in results:
    print(result.boxes.data)
    result.show()  # uncomment to view each result image
    
    # reference https://docs.ultralytics.com/modes/predict/ for more information.