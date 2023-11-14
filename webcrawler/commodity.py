"""
This is the draft of the webcrawler to collect the information from other websites like Amazon.com
We collect each commodity's information, those commodity usually be a deal or users shared in Sweet Pet
"""
from selenium import webdriver
import csv

def scrape_amazon_pet_commodities(url):
    # Set up the webdriver (make sure you have chromedriver installed and its path added to PATH)
    driver = webdriver.Chrome()
    driver.get(url)

    # Lists to store data
    commodity_data = []

    # Extract information
    try:
        # Example: Extracting commodity name, link, price, sold from, ratings, and main comments
        commodity_elements = driver.find_elements_by_xpath('//div[@data-asin]')

        for commodity in commodity_elements:
            name = commodity.find_element_by_xpath('.//span[@class="a-size-base-plus a-color-base a-text-normal"]').text
            link = commodity.find_element_by_xpath('.//a[@class="a-link-normal"]').get_attribute('href')
            price = commodity.find_element_by_xpath('.//span[@class="a-offscreen"]').text
            sold_from = commodity.find_element_by_xpath('.//span[@class="a-size-small a-color-secondary"]').text
            ratings = commodity.find_element_by_xpath('.//span[@class="a-icon-alt"]').text
            main_comments = commodity.find_element_by_xpath('.//span[@class="a-size-base"]').text

            commodity_data.append([name, link, price, sold_from, ratings, main_comments])

    except Exception as e:
        print(f"Error: {e}")

    finally:
        # Close the webdriver
        driver.quit()

    return commodity_data

def save_to_csv(data, filename):
    with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
        csv_writer = csv.writer(csvfile)
        # Write header
        csv_writer.writerow(['Name', 'Link', 'Price', 'Sold From', 'Ratings', 'Main Comments'])
        # Write data
        csv_writer.writerows(data)

if __name__ == "__main__":
    # Example usage
    amazon_url = "https://www.amazon.com/s?k=pets"
    commodity_data = scrape_amazon_pet_commodities(amazon_url)

    # Save data to CSV
    save_to_csv(commodity_data, 'pets_commodities.csv')
