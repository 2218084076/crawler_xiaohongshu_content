import os
import requests
import time
import tornado
import tornado.web
import tornado.gen
import tornado.httpclient
import urllib
import urllib.request
def Schedule(a,b,c):
    '''''
    a:已经下载的数据块
    b:数据块的大小
    c:远程文件的大小
    '''
    per = 100.0 * a * b / c
    if per > 100 :
        per = 100
    print('%.2f%%' % per)
class GetVideoOneAPIHandler(tornado.web.RequestHandler):
    @tornado.gen.coroutine
    def post(self):
        url = self.get_argument("v_url",None)
        if not url:
            self.finish({"info":"error","about":"no url"})
            return
        aim_url = url
        print("download:",aim_url)
        # aim_response = requests.get(aim_url)
        # t = int(round(time.time() * 1000))  # 毫秒级时间戳
        # f = open(os.path.join(os.path.dirname(__file__),'../static/video/%s.%s'%(time.time(),"mp4")), "ab")
        # f.write(aim_response.content)  # 多媒体存储content
        # f.close()

        # url = aim_url
        # localfile = os.path.join(os.path.dirname(__file__), "../static/video/%s.%s" % (time.time(),"mp4"))
        # urllib.request.urlretrieve(url, localfile, Schedule)

        # print("download:",aim_url)
        # aim_response = requests.get(aim_url)
        # t = int(round(time.time() * 1000))  # 毫秒级时间戳
        # f = open(os.path.join(os.path.dirname(__file__),'../static/video/%s.%s'%(time.time(),"mp4")), "ab")
        # f.write(aim_response.content)  # 多媒体存储content
        # f.close()
        http_client = tornado.httpclient.AsyncHTTPClient()
        http_header = {'User-Agent':'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.116 Safari/537.36'}
        response = yield http_client.fetch(url, headers=http_header,method='GET', body=None)
        filename = "%s"%time.time()
        filename = filename.replace(".","_")
        f = open(os.path.join(os.path.dirname(__file__),'../static/video/%s.%s'%(filename,"mp4")), "ab")
        f.write(response.body)  # 多媒体存储content
        f.close()
        self.finish({"info":"ok","about":"download action done","path":'/static/video/%s.%s'%(filename,"mp4")})
class VideoDemoHandler(tornado.web.RequestHandler):
    def get(self):
        url = self.get_argument("v_url",None)
        self.video_url = url
        self.render("../template/demo/video.html")