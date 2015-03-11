StartApp
========

This is a Phonegap Plugin to load a url in ints app. Like a facebook url in its app.

Install
==========

Assuming PhoneGap CLI is installed, from the command line.

phonegap local plugin add https://github.com/shahidj/StartApp

How to Use
==========

It supports Phonegap 3.0 and above

This plugin will retun the file contents in string format after downloading and coping on to device.

e.g

AppType                                 UrlScheme
-------                                 ---------

facebook                                fb
twitter                                 twitter
youtube                                 youtube
myspace                                 myspace
instagram                               instagram
linkedin                                linkedin

From index.js you may call plugin by passing parameters.


var successcall = function(result) {
        console.log("startapp SUCCESS: \r\n"+result );
    };
    
    var failurecall = function(error) {
        console.error("startapp ERROR: \r\n"+error );
    };
    window.startapp.start(
                        {
                          result:'success', appid:'com.atebits.Tweetie2',apptype:'twitter',urlscheme:'twitter',appurl:'https://twitter.com/mshahidjanjua'
                         },successcall,failurecall);
    
