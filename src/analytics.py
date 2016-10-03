# -*- coding: utf-8 -*-
#
# Iterativ GmbH
# http://www.iterativ.ch/
#
# Copyright (c) 2015 Iterativ GmbH. All rights reserved.
#
# Created on 2016-09-22
# @author: lorenz.padberg@iterativ.ch

import pandas as pd


def create_data_frame_of_parlamentarians(parlamentarians):
    df = pd.DataFrame(parlamentarians)
    print df
