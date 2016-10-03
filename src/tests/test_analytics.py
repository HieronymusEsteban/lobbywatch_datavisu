# -*- coding: utf-8 -*-
#
# Iterativ GmbH
# http://www.iterativ.ch/
#
# Copyright (c) 2015 Iterativ GmbH. All rights reserved.
#
# Created on 2016-09-22
# @author: lorenz.padberg@iterativ.ch

import unittest

from src.rest_calls import get_all_parlamentarier
from ..analytics import create_data_frame_of_parlamentarians

class TestRestCalls(unittest.TestCase):
    def test_create_data_frame(self):
        k = get_all_parlamentarier(max_id=50)
        df = create_data_frame_of_parlamentarians(k)
        print(df)

