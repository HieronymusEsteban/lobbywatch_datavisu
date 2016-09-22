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
from ..rest_calls import get_parlamentarier, get_all_parlamentarier


class TestRestCalls(unittest.TestCase):
    def test_get_parlameteraier_returns_dict(self):
        k = get_parlamentarier(21)
        print(k)
        self.assertEqual(type(k), dict)

    def test_get_parlameteraier_has_data(self):
        k = get_parlamentarier(21)
        print(k['data'])
        self.assertEqual(type(k['data']), dict)

    def test_get_all_parlameteraier_has_data(self):
        k = get_all_parlamentarier(max_id=10)
        self.assertEqual(type(k[0]), dict)