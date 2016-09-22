# -*- coding: utf-8 -*-
#
# Iterativ GmbH
# http://www.iterativ.ch/
#
# Copyright (c) 2015 Iterativ GmbH. All rights reserved.
#
# Created on 2016-09-22
# @author: lorenz.padberg@iterativ.ch
import json
import urllib2


def get_parlamentarier(parlamentarier_id=21):
    response = json.load(urllib2.urlopen(
        "http://lobbywatch.ch/de/data/interface/v1/json/table/parlamentarier/aggregated/id/%s" % parlamentarier_id))
    return response


def get_all_parlamentarier(max_id=50):
    all_parlamentarier = []
    for parlamentarier_id in range(max_id):
        try:
            response = get_parlamentarier(parlamentarier_id)
            if response['success']:
                all_parlamentarier.append(response['data'])

        except:
            pass
    print 'loaded %s parlamentarier' % len(all_parlamentarier)
    return all_parlamentarier
