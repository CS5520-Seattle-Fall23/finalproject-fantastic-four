from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
import time
import subprocess


opt = Options()
opt.add_experimental_option('debuggerAddress', '127.0.0.1:9222')
service = Service()
# opt.add_experimental_option('excludeSwitches', ['enable-automation'])
# opt.add_argument('--headless')
# opt.add_argument('--disable-gpu')
driver = webdriver.Chrome(options=opt)

driver.get('https://www.studentuniverse.com/amazon-prime-student')
driver.implicitly_wait(15)


path = r'C:\Users\Administrator\AppData\Local\Pub\Cache\hosted\pub.dev\video_player-2.8.1\example\assets\Audio.mp3'

i = 1
while True:
    try:
        text = driver.find_element(By.XPATH, '/html/body/div[1]/text()').text
        print(f'here is the: {text}')
        if text is None:
            continue
        if text != ' The requested service is temporarily unavailable. It is either overloaded or under maintenance. Please try later.':
            subprocess.run(['afplay', path])
            break
    except:
        driver.refresh()
        time.sleep(30)
        print(f'This is my {i} try')
        i += 1
