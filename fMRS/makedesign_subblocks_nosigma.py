#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun  3 13:42:03 2022

@author: agschrantee
"""

# load packages
import os, glob
import pandas as pd
import numpy as np
import argparse
from pathlib import Path
from nilearn.glm.first_level import make_first_level_design_matrix
from fsl_mrs.utils import mrs_io
from fsl_mrs.utils.misc import parse_metab_groups
from nilearn.plotting import plot_design_matrix
import matplotlib.pyplot as plt

workdir=''
tempdir=''
tr          = 5.0
n_scans     = 224
frame_times = np.arange(n_scans) * tr

ev1=np.loadtxt(tempdir + '/ev1.txt')
ev2=np.loadtxt(tempdir + '/ev2.txt')

condition=['first','first','first','first','first','second','second','second','second','second']

onsets_ev1=np.round(ev1[0:5,0])
onsets_ev2=np.round(ev2[0:5,0])
onset=np.concatenate((onsets_ev1,onsets_ev2),axis=None)
durations_ev1=np.round(ev1[0:5,1])
durations_ev2=np.round(ev2[0:5,1])
duration=np.concatenate((durations_ev1, durations_ev2),axis=None)
events = pd.DataFrame({'trial_type': condition,
                           'onset'     : onset,
                           'duration'  : duration})

hrf_model = 'None'
design_matrix = make_first_level_design_matrix(
	frame_times, events,
        drift_model='polynomial',
        drift_order=2,
        hrf_model=None)

design_matrix.to_csv(os.path.join(workdir,'design_subblocks_nosigma.csv'), index=False, header=False )

