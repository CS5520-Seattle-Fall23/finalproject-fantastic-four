import csv
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import time

csv_file_path = 'catToy.csv'
fieldnames = ['title', 'dealLink', 'buyLink', 'store', 'price', 'redPrice', 'thumbs', 'views', 'pic']

opt = Options()
opt.add_experimental_option('excludeSwitches', ['enable-automation'])
opt.add_argument('--headless')
opt.add_argument('--disable-gpu')
driver = webdriver.Chrome(options=opt)

for i in range(1, 11):
    driver.get(f'https://slickdeals.net/newsearch.php?page=1&q=cat%20toy&searcharea=deals&searchin=first&isUserSearch=1')
    driver.implicitly_wait(3)

    # Open the CSV file in append mode
    with open(csv_file_path, mode='a', encoding='utf-8', newline='') as f:
        csv_writer = csv.DictWriter(f, fieldnames=fieldnames)
        # Write the header to the CSV file if it's the first iteration
        if f.tell() == 0:
            csv_writer.writeheader()

        result_rows = driver.find_elements(By.CLASS_NAME, "resultRow")

        for result in result_rows:
            # Find the title element within the resultRow using XPath
            title_element = result.find_element(By.XPATH, './/div[2]/div/a') if result.find_elements(By.XPATH,
                                                                                                     './/div[2]/div/a') else None
            title_text = title_element.text if title_element else ''

            # Find other elements
            store_element = result.find_element(By.CSS_SELECTOR, 'div.priceCol > span') if result.find_elements(
                By.CSS_SELECTOR, 'div.priceCol > span') else None
            store = store_element.text if store_element else ''

            price_element = result.find_element(By.CSS_SELECTOR, 'div.priceCol > div > span') if result.find_elements(
                By.CSS_SELECTOR, 'div.priceCol > div > span') else None
            price = price_element.text if price_element else ''

            redPrice_element = result.find_element(By.XPATH, './/div[3]/div/div/span') if result.find_elements(By.XPATH,
                                                                                                               './/div[3]/div/div/span') else None
            redPrice = redPrice_element.text if redPrice_element else ''

            thumbs_element = result.find_element(By.CSS_SELECTOR,
                                                 'div.ratingCol > div.ratingNum') if result.find_elements(
                By.CSS_SELECTOR, 'div.ratingCol > div.ratingNum') else None
            thumbs = thumbs_element.text if thumbs_element else ''

            views_element = result.find_element(By.CSS_SELECTOR,
                                                'div.activityCol > div:nth-child(1)') if result.find_elements(
                By.CSS_SELECTOR, 'div.activityCol > div:nth-child(1)') else None
            views = views_element.text if views_element else ''

            try:
                pic = result.find_element(By.CSS_SELECTOR, 'div.dealImg > a > img').get_attribute(
                    'src') if result.find_element(
                    By.CSS_SELECTOR, 'div.dealImg > a > img') else ''
            except:
                pic = 'unavailable'

            dealLink = result.find_element(By.CSS_SELECTOR, 'div.dealImg > a').get_attribute(
                'href') if result.find_element(
                By.CSS_SELECTOR, 'div.dealImg > a') else ''

            print(f"Cat Toy Title: {title_text}")
            print(f"Store: {store}")
            print(f"Price: {price}")
            print(f"Red Price: {redPrice}")
            print(f"Thumbs: {thumbs}")
            print(f"Views: {views}")
            print(f"Pic: {pic}")
            print(f'DealLink: {dealLink}')

            # Write a row to the CSV file
            csv_writer.writerow({
                'title': title_text,
                'dealLink': dealLink,
                'store': store,
                'price': price,
                'redPrice': redPrice,
                'thumbs': thumbs,
                'views': views,
                'pic': pic
            })

    print(f'Cat Toy Collect Done page{i}')

# Close the browser window
driver.quit()