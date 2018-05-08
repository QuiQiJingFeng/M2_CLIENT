#!/bin/bash
python create_package_all.py; cocos compile -p android --android-studio -m release;
