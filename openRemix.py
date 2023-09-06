import webbrowser
import os, time
webbrowser.open("https://remix.ethereum.org/")
time.sleep(1)
path = os.path.dirname(os.path.realpath(__file__))

print(path)
os.system("remixd -s "+path+" --remix-ide https://remix.ethereum.org")