from BeautifulSoup import BeautifulSoup
import urllib2, urllib, time, os, re, traceback

def get_username(soup):
    mentions = soup.findAll('status')
    replyTo = mentions[0].findChild('user').findChild('screen_name')

    if replyTo == None:
        'undefined'    
    return replyTo.string

def get_timestamp():
    return time.strftime('(%A %B %d, %H:%M:%S)')
    
def post_status(status):
    if len(status) > 140:
        print 'Unable to post tweet, too long'
    else:
        command = 'curl -u bushey_monitor:password -d status="' +status+'" http://twitter.com/statuses/update.json'
        #print 'Issuing command['+command+']'
        os.system(command)

def get_soup():
    url = "http://192.168.1.200/idigi_dia?controller=content"
    f = urllib.urlopen(url)
    s = f.read()
    soup = BeautifulSoup(s)

    return soup

def get_inside_temp(soup=None):
    if soup == None:
        soup = get_soup()
        
    WALLROUTER="wall_router0"
    
    indoor = 'n/a'
    
    for i in soup.findAll('input', id=re.compile("temperature")):
        if i['id'].find(WALLROUTER)>-1:
            indoor = i['value']
            
    return indoor

def get_low_battery_sate(soup=None):
    if soup == None:
        soup = get_soup()
        
    BATTERY_STATE = "fir-sensor0.low_battery"
    
    battery_state = 'fine'
    
    for i in soup.findAll('input', id=re.compile("low_battery")):
        if i['id'].find(BATTERY_STATE)>-1:
            if i['value'].find('False') == -1:
                battery_state = 'low'
                
    return battery_state
        
def get_outside_temp(soup=None):
    if soup == None:
        soup = get_soup()
        
    OUTDOOR_SENSOR ="sensor0"

    outdoor = 'n/a'
    
    for i in soup.findAll('input', id=re.compile("temperature")):
        if i['id'].find(OUTDOOR_SENSOR)>-1:
            outdoor = i['value']

    return outdoor

def query_monitor_for_both_temps(mentions=None):

    status =  'Well @'+get_username(mentions)+' - Outside:'+ get_outside_temp() + 'c, Inside:'+get_inside_temp()+'c. ' + get_timestamp()
    post_status(status)


if __name__ == "__main__":

    url = "http://twitter.com/statuses/mentions.xml"
    
    password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
    password_mgr.add_password(None, url, 'bushey_monitor', 'clokey74')
    handle = urllib2.HTTPBasicAuthHandler(password_mgr)
    opener = urllib2.build_opener(handle)
    
    while 1==1:
    
        try:
            f = opener.open(url)
            s = f.read()

            soup = BeautifulSoup(s)

            mention = soup.findAll('status')

            # Get the most recent mention
            text = mention[0].text.string
            created_at = mention[0].created_at.string
    
            #determine when the update was
            then = time.mktime(time.strptime(created_at[:19] + ' ' + created_at[26:], '%a %b %d %H:%M:%S %Y'))
            now = time.mktime(time.localtime())

            #print now-then

            #I used to look for '@bushey_monitor and now?'
            if now-then<3690:
                print 'Tweet =['+text+']'
                if text.find('now?') > -1 :
                    print 'Someone has asked for the temp in the last minute'
                    query_monitor_for_both_temps(soup)
                elif text.find('help?') > -1 :
                    post_status('Well @'+get_username(soup)+' I respond to: now? outside? inside? battery? help?. ' + get_timestamp())
                elif text.find('outside?') > -1 :
                    post_status('Well @'+get_username(soup)+' the outside temp is :'+ get_outside_temp() + 'c. ' + get_timestamp())
                elif text.find('inside?') > -1 :
                    post_status('Well @'+get_username(soup)+' the inside temp is:'+ get_inside_temp() + 'c. ' + get_timestamp())
                elif text.find('battery?') > -1 :
                    post_status("Well @"+get_username(soup)+"I currently don't know how to respond. " + get_timestamp())
                else:
                    print 'nothing for me to do'
        except Exception:
            print "There's been a problem"
            traceback.print_exc()
            
        print '.'    
        time.sleep(90)
