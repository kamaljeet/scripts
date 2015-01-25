#!/usr/bin/python3.2

import sys
import re
import urllib.request

# script to get my flipkart wishlist items

def start():

# check if public profile name given while calling the program
    if (len(sys.argv) < 2):
        print ("Wrong number of Parameters.")
        print ("Program accepts Public profile name as the parameter.")
        exit()

    profile_name = sys.argv[1]

    page_num = 1
    wl_file = open("fk_wishlist.text", "w")
    count = 0

    while page_num:
        fk_url = "https://www.flipkart.com/wishlist/"+str(profile_name)+"?page="+str(page_num)+"&sort=dd"
        print(fk_url)
        url_page = urllib.request.urlopen(fk_url)
        url_page_html = url_page.read()
        url_page.close()
        url_page_html_list = url_page_html.splitlines()
        html_len = len(url_page_html_list)
        page_num = page_num + 1

        for line_no in range(html_len):
            matchobj = re.match(r'^.*lu-title">(.*)</a>', str(url_page_html_list[line_no]), flags=0)
            if matchobj:
                wl_file.write("\n\n"+str(count+1)+": "+matchobj.group(1)+"\n")
                count = count + 1
                continue

            matchobj = (re.search(r'(Publisher:)', str(url_page_html_list[line_no]), flags=0) or
                        re.search(r'(Author:)', str(url_page_html_list[line_no]), flags=0) or
                        re.search(r'(Released:)', str(url_page_html_list[line_no]), flags=0))
            if matchobj:
                wl_file.write(matchobj.group(1))
                wl_file.write(url_page_html_list[line_no + 3].decode("utf-8")+"\n")
                continue

            matchobj = re.match(r'.*current">(\d*)<', str(url_page_html_list[line_no]), flags=0)
            if matchobj and int(matchobj.group(1)) != (page_num-1):
                print("Page num "+str(page_num-1)+" not available. End of list.")
                page_num = 0
                break

            matchobj = re.match(r'.*(Wishlist is unavailable since profile does not exist).*', str(url_page_html_list[line_no]), flags=0)
            if matchobj:
                print ("Wrong Profile Name.")
                wl_file.close()
                exit()

            matchobj = re.match(r'.*(This Wishlist is not public).*', str(url_page_html_list[line_no]), flags=0)
            if matchobj: 
                print ("This is a Private Wishlist.")
                wl_file.close()
                exit()

    wl_file.close()
    print(str(count)+" items found in wishlist.")


start()

