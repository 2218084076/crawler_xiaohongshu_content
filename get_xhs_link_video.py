import os
import requests
import time
from bs4 import BeautifulSoup

# short_urls = [
#     "https://www.xiaohongshu.com/discovery/item/61656e5e0000000001029ff4",
# ]
# for short_url in short_urls:
#     print(short_url)
#     r = requests.get(short_url)
#     demo = r.text  # 服务器返回响应
#     soup = BeautifulSoup(demo, "html.parser")
#     # print(soup)  # 输出响应的html对象
#     print(soup.prettify())
#     f = open(os.path.join(os.path.dirname(__file__),'./html/%s.%s'%(time.time(),"html")), "ab")
#     f.write(r.content)  # 多媒体存储content
#     f.close()

a = open("html/demo.html").read()
print(a.split("</video>")[0].split("<video")[1])
