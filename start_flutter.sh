#!/bin/bash
export PATH="/tmp/flutter/bin:$PATH"
cd /tmp/cc-agent/58440814/project
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0
