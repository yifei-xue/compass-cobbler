#!/bin/bash

service httpd restart
service cobblerd restart

chmod +x /var/lib/cobbler/triggers/sync/post/migrate_ks.py
cobbler sync
