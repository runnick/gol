#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 19 13:46:49 2017

@author: jrmulholland
"""

import numpy as np
num_1s, num_0s = 25
width, height = 10
num_stars = width*height-num_1s-num_0s
out_grid = np.random.choice(['[1]']*num_1s+['[0]']*num_0s+['[ ]']*num_stars,
                size=width*height,replace=False).reshape([width,height])
for i in range(len(out_grid)):
    print " ".join(out_grid[i])