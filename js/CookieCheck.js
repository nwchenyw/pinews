if (localStorage.getItem("cookie_ok") != "Y") {
  $('form').toast({
    message: '拍新聞為了提供更好的使用者體驗，我們使用相關網站技術，當您使用我們網站，即表示您同意我們的<a target="_blank" href="/privacy.html"><b>隱私權政策</b></a>。',
    displayTime: 0,
    class: 'center aligned', position: 'bottom left',
    classActions: 'bottom attached',
    actions: [{
      text: '接受',
      class: 'green',
      click: function () {
        localStorage.setItem("cookie_ok", "Y")
      }
    }, {
      text: '稍後提醒我',
      class: 'red'
    }]
  });
  console.log('--cookie policy remind--');
}