/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');
        console.log(Object.keys(cordova.plugins.ir));
        let $log = document.getElementById('log');

        document.getElementById('get-brand').addEventListener('click', function() {
            cordova.plugins.ir.getBrandList(null, function(result) {
                console.log(result);
                $log.appendChild(result);
            }, function(error) {
                alert(JSON.stringify(error));
            });
        }, false);

        document.getElementById('get-apps').addEventListener('click', function() {
            cordova.plugins.ir.getApplianceList(null, function(result) {
                console.log(result);
                $log.appendChild(result);
            }, function(error) {
                alert(JSON.stringify(error));
            });
        }, false);

        document.getElementById('search-remote').addEventListener('click', function() {
            let key = document.getElementById('remote-key').value;
            if(!key) return alert('key is empty!!');

            cordova.plugins.ir.searchRemote(key, function(result) {
                console.log(result);
                $log.appendChild(result);
            }, function(error) {
                alert(JSON.stringify(error));
            });
        }, false);
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

app.initialize();