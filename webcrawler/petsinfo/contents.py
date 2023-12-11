from selenium import webdriver
from selenium.webdriver.common.by import By

# Assuming you have a webdriver instance (e.g., ChromeDriver) initialized
driver = webdriver.Chrome()

# Open a webpage
driver.get("https://slickdeals.net/f/16997446-factory-refurb-shark-iz142-pet-pro-cordless-vacuum-w-self-cleaning-brush-roll-103-free-s-h")

# Find the element by ID
details_description_element = driver.find_element(By.ID, "detailsDescription")

# Alternatively, find the element by class
# details_description_element = driver.find_element_by_class_name("textDescription")

# Get all paragraphs' text from the element
paragraphs = details_description_element.find_element(By.TAG_NAME, "p")

# Print each paragraph's text
for paragraph in paragraphs:
    print(paragraph.text)

# Close the webdriver
driver.quit()
