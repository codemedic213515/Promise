// MIT License
//
// Copyright 2017-19 Electric Imp
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

// "Promise" symbol is injected dependency from ImpUnit_Promise module,
// while class being tested can be accessed from global scope as "::Promise".

class Loop extends ImpTestCase {
    values = [false, 0, "", "tmp", 0.001
        , regexp(@"(\d+) ([a-zA-Z]+)(\p)")
        , null, blob(4), array(5), {
            firstKey = "Max Normal",
            secondKey = 42,
            thirdKey = true
        }, function() {
            return "w";
        },  class {
            tmp = 0;
            constructor(){
                tmp = 15;
            }

        }, server];

    function _wrongFirst(values) {
        local promises = [];
        foreach (value in values) {
            promises.append(
                ::Promise(function(ok, err) {
                    local myValue = value;
                    local msg = "with value='" + myValue + "'";
                    local _value = null;
                    try {
                        ::Promise.loop(myValue, @() ::Promise(function (resolve, reject) { resolve(2) })).then(function(res) {
                            msg = "Resolve handler is called " + msg;
                        }.bindenv(this), function(res) {
                            _value = res;
                        }.bindenv(this));
                    } catch(ex) {
                        msg = "Unexpected error " + ex + " " + msg;
                    }
                    imp.wakeup(1, function() {
                        if (_value == null) {
                            server.log("Fail " + msg);
                            err("Fail " + msg);
                        } else {
                            //server.log("Pass " + msg);
                            ok("Pass " + msg);
                        }
                    }.bindenv(this));
                }.bindenv(this))
            );
        }
        return Promise(function(ok, err) {
            ::Promise.all(promises).then(ok, err);
        }.bindenv(this));
    }

    // Disabled
    // Issue:  Unexpected error in Promise.loop() #23
    function _DISABLED_testWrongFirst_1() {
        return _wrongFirst([false, 0, "",  "tmp", 0.001]);
    }

    function _DISABLED_testWrongFirst_2() {
        return _wrongFirst([regexp(@"(\d+) ([a-zA-Z]+)(\p)"), null, blob(4)]);
    }

    function _DISABLED_testWrongFirst_3() {
        return _wrongFirst([/*array(5), {
            firstKey = "Max Normal",
            secondKey = 42,
            thirdKey = true
        },*/ function() {
            return "w";
        }]);
    }

    function _DISABLED_testWrongFirst_4() {
        return _wrongFirst([class {
            tmp = 0;
            constructor(){
                tmp = 15;
            }

        }, server]);
    }

    function _wrongSecond(values) {
        local promises = [];
        foreach (value in values) {
            promises.append(
                ::Promise(function(ok, err) {
                    local msg = "with value='" + value + "'";
                    local _value = null;
                    try {
                        ::Promise.loop(@() true, value).then(function(res) {
                            msg = "Resolve handler is called " + msg;
                        }.bindenv(this), function(res) {
                            _value = res;
                        }.bindenv(this));
                    } catch(ex) {
                        msg = "Unexpected error " + ex + " " + msg;
                    }
                    imp.wakeup(1, function() {
                        if (_value == null) {
                            server.log("Fail " + msg);
                            err("Fail " + msg);
                        } else {
                            //server.log("Pass " + msg);
                            ok("Pass " + msg);
                        }
                    }.bindenv(this));
                }.bindenv(this))
            );
        }
        return Promise(function(ok, err) {
            ::Promise.all(promises).then(ok, err);
        }.bindenv(this));
    }

    // Disabled
    // Issue:  Unexpected error in Promise.loop() #23
    function _DISABLED_testWrongSecond_1() {
        return _wrongSecond([false, 0, "",  "tmp", 0.001]);
    }

    function _DISABLED_testWrongSecond_2() {
        return _wrongSecond([regexp(@"(\d+) ([a-zA-Z]+)(\p)"), null, blob(4)]);
    }

    function _DISABLED_testWrongSecond_3() {
        return _wrongSecond([/*array(5), {
            firstKey = "Max Normal",
            secondKey = 42,
            thirdKey = true
        },*/ function() {
            return "w";
        }]);
    }

    function _DISABLED_testWrongSecond_4() {
        return _wrongSecond([class {
            tmp = 0;
            constructor(){
                tmp = 15;
            }

        }, server]);
    }

    function testWrongCount_1() {
        foreach (value in values) {
            try {
                ::Promise.loop(value);
                assertTrue(false, "Exception is expected. Value="+value);
            } catch(err) {
            }
        }
    }

    function testWrongCount_2() {
        foreach (value in values) {
            try {
                ::Promise.loop(value, value, value);
                assertTrue(false, "Exception is expected. Value="+value);
            } catch(err) {
            }
        }
    }
}
