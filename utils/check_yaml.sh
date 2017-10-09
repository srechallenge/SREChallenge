#! /bin/bash
python -c 'import yaml,sys;yaml.safe_load(sys.stdin)' < $1
