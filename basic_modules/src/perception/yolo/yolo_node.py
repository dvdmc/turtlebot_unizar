#!/usr/bin/env python3
import rospy
from yolo import YoloNode

if __name__ == '__main__':
    rospy.init_node('yolo_node')
    sensor = YoloNode()
    rospy.spin()