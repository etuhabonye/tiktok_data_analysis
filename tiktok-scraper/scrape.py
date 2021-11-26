import os
import yaml
import pandas as pd
import re
import traceback
from selenium import webdriver
from bs4 import BeautifulSoup


class TiktokScraper:

    def __init__(self):
        """
        Set cwd to file, set up crawler, and load xpaths data from yaml
        """
        os.chdir(os.path.dirname(__file__))
        options = webdriver.ChromeOptions()
        options.add_argument("--disable-blink-features=AutomationControlled")
        options.headless = True
        self.driver = webdriver.Chrome(
            executable_path='./chromedriver', options=options)
        self.driver.set_window_size(1280, 720)
        self.df = pd.DataFrame()
        self.data = {}
        with open('./xpaths.yaml') as file:
            self.xpaths = yaml.full_load(file)

    def getLinks(self, file):
        """
        """
        with open(f'./links/{file}') as f:
            soup = BeautifulSoup(f, "html.parser")
            links = [link.get('href')
                     for link in soup.find_all('a', href=True)][:1100]
        return links

    def scrapePost(self, postUrl):
        """
        """
        # Navigate to tiktok post
        self.driver.get(postUrl)
        # Set post url
        self.data['postUrl'] = postUrl
        # Get profile url
        self.data['userUrl'] = self.driver.find_element_by_xpath(
            self.xpaths['userUrl']).get_attribute("href")
        # Get post date
        match = re.search(
            '[^·]*$', self.driver.find_element_by_xpath(self.xpaths['postDate']).text)
        self.data['postDate'] = match.group().strip() if match else None
        # Get post soundtrack title
        self.data['postSoundtrack'] = self.driver.find_element_by_xpath(
            self.xpaths['postSoundtrack']).text.strip()
        # Get post description into
        self.data['postDescription'] = self.driver.find_element_by_xpath(
            self.xpaths['postDescription']).text.strip()
        # Get post likes
        self.data['postLikes'] = self.driver.find_element_by_xpath(
            self.xpaths['postLikes']).text.strip()
        # Get post comments
        self.data['postComments'] = self.driver.find_element_by_xpath(
            self.xpaths['postComments']).text.strip()
        # Get post shares
        self.data['postShares'] = self.driver.find_element_by_xpath(
            self.xpaths['postShares']).text.strip()

    def scrapeProfile(self, profileUrl):
        """
        """
        # Navigate to tiktok user profile
        self.driver.get(profileUrl)
        # Get username
        self.data['username'] = self.driver.find_element_by_xpath(
            self.xpaths['username']).text.strip()
        # Get user display name
        self.data['userDisplayName'] = self.driver.find_element_by_xpath(
            self.xpaths['userDisplayName']).text.strip()
        # Get user followers
        self.data['userFollowers'] = self.driver.find_element_by_xpath(
            self.xpaths['userFollowers']).text.strip()
        # Get user following
        self.data['userFollowing'] = self.driver.find_element_by_xpath(
            self.xpaths['userFollowing']).text.strip()
        # Get user likes
        self.data['userLikes'] = self.driver.find_element_by_xpath(
            self.xpaths['userLikes']).text.strip()
        # Get user description
        self.data['userDescription'] = self.driver.find_element_by_xpath(
            self.xpaths['userDescription']).text.strip()
        # Deterime whether user is verified
        match = self.driver.find_element_by_xpath(
            self.xpaths['userVerified']).get_attribute("class").find('verified')
        self.data['userVerified'] = match != -1

    def mergeFiles(self):
        df = pd.DataFrame()
        excelFiles = [f for f in os.listdir('./dataset') if f.endswith('.xlsx')]
        for f in excelFiles:
            dataset = pd.read_excel(f"./dataset/{f}", index_col=None)
            trendingHashtag = f[:-5]
            dataset['trendingHashtag'] = trendingHashtag
            df = pd.concat([df, dataset], ignore_index=True)

        df.to_excel('tiktok-trending-dataset.xlsx', index=False)

    def scrape(self):
        """
        """
        os.makedirs('dataset', exist_ok=True)
        for f in []: #os.listdir('./links'):
            links = self.getLinks(f)
            print(len(links))
            for link in links:
                try:
                    self.scrapePost(link)
                    self.scrapeProfile(self.data['userUrl'])
                    if (None in list(self.data.values())):
                        print(f'Error: {link}', self.data)
                        input("Press Enter to continue...")
                    else:
                        self.df = self.df.append([self.data], ignore_index=True)
                        print(f'Completed: {link}')
                except Exception as e:
                    print(f'Error: {link}')
                    traceback.print_exception(type(e), e, e.__traceback__)
                self.data = {}
            self.df.to_excel(f'dataset/{f[:-5]}.xlsx', index=False)
            self.df = pd.DataFrame()
            self.data = {}
        self.driver.quit()


scraper = TiktokScraper()
scraper.mergeFiles()
