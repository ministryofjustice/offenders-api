#!/bin/bash
ruby bin/rails server -d --binding 0.0.0.0
tail -f /usr/src/app/log/*
