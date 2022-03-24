#!/bin/env python
#coding=utf-8
import os
import sys
from selenium import webdriver
import requests
import time

argv_list = sys.argv[1:]
argv_dir = {}
if len(argv_list)%2 != 0:
    print("error:","argv nums error")
for i in range(0,len(argv_list),2):
    argv_dir[argv_list[i]]=argv_list[i+1]
short_link = argv_dir.get("--link",None)
print("short_link:",short_link)

browser = webdriver.Chrome()
browser.get(short_link)
time.sleep(3)
small_pic = browser.find_element_by_class_name("small-pic")
div_i_imgs = small_pic.find_elements_by_tag_name("i")
num = 0
for div_i_img in div_i_imgs:
    link ="https://%s?imageView2/2/w/1080/format/jpg"%(div_i_img.get_attribute("style").split("https://")[1].split("?imageView2/2/")[0])
    aim_url = link
    print(aim_url)
    aim_response = requests.get(aim_url)
    t = int(round(time.time() * 1000))  # 毫秒级时间戳
    f = open(os.path.join(os.path.dirname(__file__),'./static/upload/%s.%s'%(num,"jpg")), "ab")
    f.write(aim_response.content)  # 多媒体存储content
    f.close()
    num +=1
print(num)