import csv
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By


csv_file_path = "catTreatment.csv"  # Replace with the path to your CSV file
output_csv_file_path = 'catTreatment4_buyLink.csv'  # Replace with the path for the output data

opt = Options()
opt.add_experimental_option('excludeSwitches', ['enable-automation'])
opt.add_argument('--headless')
opt.add_argument('--disable-gpu')
driver = webdriver.Chrome(options=opt)


# Open the CSV file containing URLs
with open(csv_file_path, mode='r', encoding='utf-8') as csv_file:
    csv_reader = csv.DictReader(csv_file)

    # Iterate through each row in the CSV file
    for row in csv_reader:
        url = row['dealLink']

        # Navigate to the URL
        driver.get(url)
        driver.implicitly_wait(3)

        try:
            if driver.find_element(By.CSS_SELECTOR, 'body > div.modal.modal-modern > button'):
                driver.find_element(By.CSS_SELECTOR, 'body > div.modal.modal-modern > button').click()
            expired = 'Expired Deal'
        except:
            expired = ''
            print('not expired')
        # Example: Extract some data from the page and write it to another CSV file
        try:
            realBuyLink = driver.find_element(By.CSS_SELECTOR, '#largeBuyNow').get_attribute('href') if driver.find_element(
                By.CSS_SELECTOR, '#largeBuyNow') else 'unavailable'
        except:
            realBuyLink = 'This item has no redirect purchase link'
        try:
            description = driver.find_element(By.CSS_SELECTOR, '#productDescription').text if driver.find_element(
            By.CSS_SELECTOR, '#productDescription') else 'unavailable'
        except:
            description = 'This item has no description'

        print(f'read link is: {realBuyLink}')
        print(f'content is : {description}')

        with open(output_csv_file_path, mode='a', encoding='utf-8', newline='') as output_csv:
            fieldnames = ['realBuyLink', 'description', 'expired']
            csv_writer = csv.DictWriter(output_csv, fieldnames=fieldnames)

            # Write header if the file is empty
            if output_csv.tell() == 0:
                csv_writer.writeheader()

            # Write data to the output CSV file
            csv_writer.writerow({'realBuyLink': realBuyLink, 'description': description, 'expired': expired})

# Close the browser window
driver.quit()

print('Operations done')