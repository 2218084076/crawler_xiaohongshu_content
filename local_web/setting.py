import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(os.path.dirname(os.path.abspath(__file__)) + '/vendor/')
settings = {
    "static_path": os.path.join(os.path.dirname(__file__),"static"),
    "debug":True,
}
path_checks = [
    os.path.join(os.path.dirname(__file__),"static/temp/"),
    os.path.join(os.path.dirname(__file__),"static/upload/"),
    os.path.join(os.path.dirname(__file__),"static/files/"),
]
for path_check in path_checks:
    path_now = os.path.exists(path_check)
    if not path_now:
        os.makedirs(path_check)