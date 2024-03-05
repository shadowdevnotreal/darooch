import subprocess
import sys
import os
from datetime import datetime
import feedparser

# Function to ensure all required Python packages are installed
def install_requirements():
    required_packages = ['feedparser']
    for package in required_packages:
        subprocess.check_call([sys.executable, "-m", "pip", "install", package])

# Install required packages
install_requirements()

# Function to search for news in the RSS feed by a keyword
def search_news(feed_url, keyword):
    feed = feedparser.parse(feed_url)
    matching_news = []

    for entry in feed.entries:
        title = entry.title
        description = entry.summary if 'summary' in entry else "No description available."
        if keyword.lower() in title.lower() or keyword.lower() in description.lower():
            matching_news.append((title, description))
    return matching_news

# Check if a keyword is provided as a command line argument
if len(sys.argv) != 2:
    print("Usage: python search_news.py <keyword>")
    sys.exit(1)

keyword = sys.argv[1]

# Directory to store the results, using OSINTTools
tools_dir = os.path.join(os.path.expanduser("~"), "OSINTTools")
results_directory = os.path.join(tools_dir, "results")

# Check if the directory exists, if not, create it
if not os.path.exists(results_directory):
    os.makedirs(results_directory)

# Get the current date and time as part of the file name
current_date = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
file_name = os.path.join(results_directory, f"news_{current_date}.txt")

# List of RSS feed links from major news portals
feeds = [
    # Add the RSS feed links of the news portals you wish to search here
    'http://www.bbc.co.uk/index.xml',
    'http://rss.cnn.com/rss/edition_world.rss',
    'https://feeds.bbci.co.uk/news/rss.xml',
    'http://rss.cnn.com/rss/edition.rss',
    'https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml',
    'https://www.theguardian.com/world/rss',
    'https://www.aljazeera.com/xml/rss/all.xml',
    'https://apnews.com/rss',
    'http://feeds.nbcnews.com/nbcnews/public/news',
    'https://www.washingtonpost.com/rss',
    'https://abcnews.go.com/abcnews/topstories',
    'https://news.yahoo.com/rss/',
    'http://rssfeeds.usatoday.com/usatoday-NewsTopStories',
    'https://www.latimes.com/rss2.0.xml',
    'https://feeds.a.dj.com/rss/RSSWorldNews.xml',
    'https://www.independent.co.uk/news/rss',
    'http://feeds.foxnews.com/foxnews/latest',
    'https://www.npr.org/rss/rss.php?id=1001',
    'https://www.cbc.ca/cmlink/rss-topstories',
    'https://www.smh.com.au/rss/feed.xml',
    # Add more feeds as needed
]

# Create and open the file to write the results
with open(file_name, 'w', encoding='utf-8') as file:
    file.write(f"Search results for '{keyword}'\n\n")
    for feed_url in feeds:
        matching_news = search_news(feed_url, keyword)
        if matching_news:
            file.write(f"Results in {feed_url}:\n")
            for i, (title, description) in enumerate(matching_news, start=1):
                file.write(f"{i}. Title: {title}\n   Description: {description}\n\n")
        else:
            file.write(f"No news related to '{keyword}' found in {feed_url}\n")

print(f"The results have been saved in the file: {file_name}")
