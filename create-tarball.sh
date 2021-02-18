#!/bin/bash

base=$(basename $PWD)
cd ..
tar -czf $base.tar.gz $base
mv $base.tar.gz $base/
