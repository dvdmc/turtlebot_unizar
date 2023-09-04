import cv2, math
import numpy as np
from sensor_msgs.msg import Image
from std_msgs.msg import String
import cv2
from cv_bridge import CvBridge, CvBridgeError
import torch
import rospy

class YoloNode:
    def __init__(self):
        print("Starting Yolo Node")
        # Members
        self.bridge = CvBridge()

        self.img = None
        self.depth = None
        self.img_cuda = None


        # NN Configuration
        self.gpu_device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        # Load the model
        # Model
        self.model = torch.hub.load('ultralytics/yolov5', 'yolov5s', pretrained=True)
        self.model.to(self.gpu_device)
        self.model.eval()
        print("Model loaded")

        # Sync depth and color
        self.image_sub = rospy.Subscriber("/camera/color/image_raw", Image, self.callback)
        # self.depth_sub = rospy.Subscriber("/camera/depth/image_rect_raw", Image, self.callback_depth)
        self.image_pub = rospy.Publisher("/yolo/image_raw", Image, queue_size=2)
        self.depth_pub = rospy.Publisher("/yolo/depth", Image, queue_size=2)

        print("Finished configuration")

    def callback(self, data):
        self.img = self.bridge.imgmsg_to_cv2(data, "bgr8")
        array_img = np.asarray(self.img)

        # Inference
        results = self.model(array_img)

        # Results
        results_cv = results.render()[0]
        # results_cv = cv2.cvtColor(results_cv, cv2.COLOR_RGB2BGR)

        # Get image
        image_msg = self.bridge.cv2_to_imgmsg(results_cv)
        image_msg.header.stamp = rospy.Time.now()
        image_msg.header.frame_id = data.header.frame_id
        image_msg.header.seq = 0
        
        # Publish
        self.image_pub.publish(image_msg)
