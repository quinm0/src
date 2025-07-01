import cv2
import numpy as np
import os
import argparse
import sys

def load_yolo(model_cfg, model_weights, class_names):
    net = cv2.dnn.readNetFromDarknet(model_cfg, model_weights)
    net.setPreferableBackend(cv2.dnn.DNN_BACKEND_OPENCV)
    net.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)
    with open(class_names, 'r') as f:
        classes = [line.strip() for line in f.readlines()]
    # Fix for different OpenCV versions: getUnconnectedOutLayers may return 1D or 2D array
    out_layers = net.getUnconnectedOutLayers()
    if isinstance(out_layers, np.ndarray) and len(out_layers.shape) == 2:
        output_layers = [net.getLayerNames()[i[0] - 1] for i in out_layers]
    else:
        output_layers = [net.getLayerNames()[i - 1] for i in out_layers]
    return net, classes, output_layers

def detect_yolo(net, output_layers, frame, conf_threshold=0.5, nms_threshold=0.4):
    height, width = frame.shape[:2]
    blob = cv2.dnn.blobFromImage(frame, 1/255.0, (416,416), swapRB=True, crop=False)
    net.setInput(blob)
    outs = net.forward(output_layers)
    class_ids, confidences, boxes = [], [], []
    for out in outs:
        for detection in out:
            scores = detection[5:]
            class_id = np.argmax(scores)
            confidence = scores[class_id]
            if confidence > conf_threshold:
                center_x, center_y, w, h = (detection[0:4] * np.array([width, height, width, height])).astype('int')
                x = int(center_x - w / 2)
                y = int(center_y - h / 2)
                boxes.append([x, y, int(w), int(h)])
                confidences.append(float(confidence))
                class_ids.append(class_id)
    indices = cv2.dnn.NMSBoxes(boxes, confidences, conf_threshold, nms_threshold)
    result = []
    if len(indices) > 0:
        for i in indices.flatten():
            result.append({
                'box': boxes[i],
                'conf': confidences[i],
                'class_id': class_ids[i]
            })
    return result

def main():
    parser = argparse.ArgumentParser(description="YOLO object detection on video frames.")
    parser.add_argument('video_path', nargs='?', default='findhim.mp4', help='Path to the video file')
    parser.add_argument('--show', action='store_true', help='Show frames with YOLO detections')
    parser.add_argument('--dump', action='store_true', help='Print YOLO detection results')
    parser.add_argument('--save', action='store_true', help='Save video with YOLO bounding boxes')
    parser.add_argument('--slow', action='store_true', help='Slow down output video')
    parser.add_argument('--yolo-cfg', default='yolov3.cfg', help='Path to YOLO config file')
    parser.add_argument('--yolo-weights', default='yolov3.weights', help='Path to YOLO weights file')
    parser.add_argument('--yolo-names', default='coco.names', help='Path to YOLO class names file')
    parser.add_argument('--conf', type=float, default=0.5, help='YOLO confidence threshold')
    parser.add_argument('--nms', type=float, default=0.4, help='YOLO NMS threshold')
    args = parser.parse_args()

    net, classes, output_layers = load_yolo(args.yolo_cfg, args.yolo_weights, args.yolo_names)
    output_fps = 10.0 if args.slow else 30.0

    vidcap = cv2.VideoCapture(args.video_path)
    width = int(vidcap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(vidcap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    out = None
    if args.save:
        out = cv2.VideoWriter('yolo_output.mp4', fourcc, output_fps, (width, height))

    frame_idx = 0
    while True:
        ret, frame = vidcap.read()
        if not ret:
            break
        detections = detect_yolo(net, output_layers, frame, args.conf, args.nms)
        if args.dump:
            print(f"Frame {frame_idx}:")
            for det in detections:
                print(f"  Class: {classes[det['class_id']]}, Conf: {det['conf']:.2f}, Box: {det['box']}")
        frame_out = frame.copy()
        for det in detections:
            x, y, w, h = det['box']
            label = f"{classes[det['class_id']]} {det['conf']:.2f}"
            cv2.rectangle(frame_out, (x, y), (x + w, y + h), (0,255,0), 2)
            cv2.putText(frame_out, label, (x, y-10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255,255,0), 2)
        if args.show:
            cv2.imshow('YOLO Detection', frame_out)
            key = cv2.waitKey(100 if args.slow else 30)
            if key == 27:  # ESC
                break
        if args.save:
            out.write(frame_out)
        frame_idx += 1

    vidcap.release()
    if out:
        out.release()
    cv2.destroyAllWindows()
    print("YOLO processing complete.")

if __name__ == "__main__":
    main()