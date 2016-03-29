#!/usr/bin/env python

'''
JAVA custom dynamic inventory script for Ansible, in Python.
'''

import os
import sys
import argparse
import MySQLdb as mdb

try:
    import json
except ImportError:
    import simplejson as json

class JavaInventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()
        SERVICE_NAME=os.getenv('SERVICE_NAME').strip()
        GROUP_NAME=os.getenv('GROUP_NAME').strip()
        SERVERS=os.getenv('SERVERS')
        # Called with `--list`.
        if self.args.list:
            self.inventory = self.java_inventory(SERVICE_NAME, GROUP_NAME, SERVERS)
        # Called with `--host [hostname]`.
        elif self.args.host:
            # Not implemented, since we return _meta info `--list`.
            self.inventory = self.empty_inventory()
        # If no groups or vars are present, return an empty inventory.
        else:
            self.inventory = self.empty_inventory()

        print json.dumps(self.inventory);

    def java_inventory(self, service_name, group_name, servers):
        inventory = {group_name: {'hosts':[],'vars':{}}}
        try:
            con = mdb.connect(host='*************',user='**********',passwd='*******',port=8527,charset='utf8')
            with con:
                con.select_db('logsearch')
                cur = con.cursor(mdb.cursors.DictCursor)
                sql = 'select id, port from services where name=\'%s\'' % (service_name)
                cur.execute(sql)
                service_row = cur.fetchone()
                service_id=service_row['id']
                service_port=service_row['port']
                inventory[group_name]['vars']['port']=8950
                if servers and len(servers.strip())>0:
                    ips = servers.split(',')
                    for server_ip in ips:
                        inventory[group_name]['hosts'].append(server_ip.strip())
                else:
                    sql = 'select id from dc where dc_code=\'%s\'' % (group_name)
                    cur.execute(sql)
                    dc_row = cur.fetchone()
                    dc_id = dc_row['id']
                    sql = 'select servers.ip from rel_service_dc rdc, rel_service_dc_server rdcs, servers where rdc.service=%s and rdc.dc=%s and rdc.id=rdcs.service_dc and rdcs.server=servers.id' % (service_id, dc_id)
                    cur.execute(sql)
                    server_rows = cur.fetchall()
                    for row in server_rows:
                        inventory[group_name]['hosts'].append(row['ip'])
        finally:
            if con:
                con.close()
        return inventory
    # Empty inventory for testing.
    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # Read the command line args passed to the script.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action = 'store_true')
        parser.add_argument('--host', action = 'store')
        self.args = parser.parse_args()

# Get the inventory.
JavaInventory()
