#!/usr/bin/python2.6
#
"""Script to grab google calendar and parse it out into an oncall config
for nagios.

Note - if you want to change things, you'll probably need to make changes
here and in the notifications.cfg file as well to match
"""

import re

#### Template

cg_template = """# Oncall Notifications config
# This config is automatically generated and references notifications.cfg
# for the definitions of available admins and how to contact them
#
# Groups

define contactgroup{
        contactgroup_name       oncall-lockerz-admins
        alias                   Oncall Lockerz Admins
	members			%(primary)s, lockerz_alerts
	}

define contactgroup{
        contactgroup_name       secondary-lockerz-admins
        alias                   Secondary Oncall Lockerz Admins
	members			%(secondary)s
	}

define contactgroup{
        contactgroup_name       lockerz-mgmt
        alias                   Lockerz Management
	members			%(management)s
	}
"""


#### Groups
# Note this needs to match up with the query_string used in the gcal search
groups = { 'management' : re.compile('MANAGEMENT:.*'),
	'primary' : re.compile('PRIMARY:.*'),
	'secondary' : re.compile('SECONDARY:.*') }

#### People
# Note this needs to match up with the contents of notifications.cfg
people = {
	'spryLockerzOps' : re.compile('.*spry(?i).*'),
	'nate' : re.compile('.*nate(?i).*'),
	'mreith' : re.compile('.*mreith(?i).*'),
	'buddy' : re.compile('.*buddy(?i).*'),
	'bryan' : re.compile('.*bryan(?i).*'),
	'steve' : re.compile('.*steve(?i).*'),
	'john' : re.compile('.*john(?i).*'),
	'ken' : re.compile('.*ken(?i).*') }

import sys
#sys.path.append('/usr/local/lib/python2.6/site-packages')

try:
  from xml.etree import ElementTree
except ImportError:
  from elementtree import ElementTree
import warnings
with warnings.catch_warnings():
	# One of these is importing a deprecated crypto hash module
	# We're not going to fix that, and it's not very interesting :)
	warnings.simplefilter("ignore", DeprecationWarning)
	import gdata.calendar.service
	import gdata.service
import atom.service
import gdata.calendar
import atom
import getopt
import sys
import string
import time

import datetime

## query_string = 'management:|primary:|secondary:'
## bernard@sprybts.com 2011-06-01
## for some unknown reason, the query_string seems to have stopped working
query_string = ''

today = datetime.date.today()
tomorrow = datetime.date.today() + datetime.timedelta(1)
now = datetime.datetime.utcnow().isoformat()[:19]

calendar_service = gdata.calendar.service.CalendarService()
calendar_service.email = 'ooc@lockerz.com'
calendar_service.password = '00Call0ck3rz'
calendar_service.source = 'whosOnFirst-1.0'
calendar_service.ProgrammaticLogin()

query = gdata.calendar.service.CalendarEventQuery('default', 'private', 'full', query_string)
query.start_min = today.isoformat()
query.start_max = tomorrow.isoformat()
query.ctz = "UTC"
query.sortorder = 'd'

feed = calendar_service.CalendarQuery(query)
conf={}

sys.stderr.write("""
Lockerz on-call operations roster update:

""")


for i, an_event in enumerate(feed.entry):
	when=an_event.when
	if type(when) == type([]) and len(when) > 0:
		when=when[0]
	else:
		continue
	if not ((when.start_time[:19] <= now) and (when.end_time[:19] >= now)):
		continue
	sys.stderr.write(when.start_time[:19] + " - " + when.end_time[:19] + " ")
	sys.stderr.write(an_event.title.text + "\n")
	for g in groups:
		if re.match(groups[g], an_event.title.text):
			if conf.has_key(g):
				break
			for p in people:
				if re.match(people[p], an_event.title.text):
					conf[g]=p
					break
			break

if conf.has_key('primary') and conf.has_key('secondary') and conf.has_key('management'):
	sys.stderr.write("""

The Nagios config has been updated to reflect the current oncall calendar

The oncall calendar can be viewed/updated at:
	https://www.google.com:443/calendar/hosted/lockerz.com/render


This announcement was brought to you by nagios.lockerz.com and the friendly
ooc@lockerz.com calendar

""")
else:
	sys.stderr.write("\nCouldn't find primary and secondary in today's calendar - aborting\n\n")
	sys.exit(1)

print cg_template%conf

