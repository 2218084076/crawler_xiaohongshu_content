import os
import requests
import time
aim_urls = [
    "http://v.xiaohongshu.com/6ad299f2d995281c41941c4ef4224fca294ca6ad_r_ln?sign=960047c4c5eb8d180207cbbe35c4dba1&t=6169a580"
]
for aim_url in aim_urls:
    print("download:",aim_url)
    aim_response = requests.get(aim_url)
    t = int(round(time.time() * 1000))  # 毫秒级时间戳
    f = open(os.path.join(os.path.dirname(__file__),'./video/%s.%s'%(time.time(),"mp4")), "ab")
    f.write(aim_response.content)  # 多媒体存储content
    f.close()