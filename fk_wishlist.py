#!/usr/bin/python3.2

import re
import urllib.request

# script to get my flipkart wishlist items


def start():
    download_html()
    extract_items()


# download html content for my wishlist pages
# save it to the file named fk_html.text
def download_html():
    page_nums = range(1, 26) # currently 25 pages in the wishlist
    for i in page_nums:
        fk_url = "https://www.flipkart.com/wishlist/kamaljeet.lotuswin-4294?page="+str(i)+"&sort=dd"
        print(fk_url)
        url_page = urllib.request.urlopen(fk_url)
        url_page_html = url_page.read()
        dump_file = open("fk_html.text", "a+b")
        dump_file.write(url_page_html)
        url_page.close()
        dump_file.close()


# extract the item names, and publisher and author in case of books
# save the info to fk_wishlist.text
def extract_items():
    count = 0
    html_data = open("fk_html.text", "r")
    html_data_list = html_data.read().splitlines()
    html_len = len(html_data_list)
    wl_file = open("fk_wishlist.text", "w")
    for line_no in range(html_len):
        matchobj = re.match(r'^.*lu-title">(.*)</a>', html_data_list[line_no], flags=0)
        if matchobj:
            wl_file.write("\n\n"+str(count+1)+": "+matchobj.group(1)+"\n")
            print (matchobj.group(1))
            count = count + 1
        matchobj = re.match(r'^\s(Publisher:).*', html_data_list[line_no], flags=0) or re.match(r'^\s(Author:).*', html_data_list[line_no], flags=0)
        if matchobj:
            wl_file.write(matchobj.group(1))
            wl_file.write(html_data_list[line_no + 3]+"\n")
    wl_file.close()
    print("count=" +str(count))


start()

