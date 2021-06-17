# 油猴插件开发

Thief Book的小功能

```js
// ==UserScript==
// @name         Thief Book
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://jira.mspbots.ai/**
// @icon         https://www.google.com/s2/favicons?domain=tampermonkey.net.cn
// @grant GM_setValue
// @grant GM_getValue
// ==/UserScript==

var book = null;
var bookname='jpm3.txt';

(function($) {
    'use strict';
function init(){
    book = GM_getValue(bookname,null)
    if (book == null){
      $.get("http://localhost:35036/"+bookname,function(data){
          handlerData(data)
          GM_setValue(bookname,book);
      })
    }
}
init();
function show(text){
    $('.user-content-block').html(text)
}

function handlerData(data){
    book = data.split('\n')
}

function handle(){
    show(book[GM_getValue('line')])
}

function turnPage(num){
    var line = GM_getValue('line')
    $('#page_line').val(line)
    if( line>= book.length || line < 0){
       return;
    }
   var page = GM_getValue('line',0)
   GM_setValue('line',Number(page)+Number(num));
}

// Tip: 页面可访问到脚本的函数需如此才行
unsafeWindow.jump = function(){
    GM_setValue('line',Number($('#page_line').val()));
    handle();
}

document.onkeydown = function(e) {
    var k = e.keyCode;
    switch(k) {
        case 37:
            turnPage(-1)
            handle()
            break;
        case 39:
            turnPage(1)
            handle()
            break;
    }
}

$(document.body).append("<div id='ctrl-box' style='position:fixed;bottom:0;right:0'> <input id='page_line' style='width:35px' type='number'/> <input type='button' value='跳转' onclick='window.jump()'/> </div>");


})(jQuery);

```