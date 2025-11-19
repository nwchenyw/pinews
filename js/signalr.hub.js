$(function () {
  // Declare a proxy to reference the hub. 
  var push = $.connection.pushHub;

  // settings
  //$.connection.hub.logging = true;
  $.connection.hub.error(function (error) {
    console.log('SignalR error: ' + error)
  });

  push.client.broadcastVerifiedLinkMessage = function (method, token, name, message, link) {
  // verified
  // Html encode display name and message. 
  console.log('msg verify')
  var msgs = { 'name': name, 'message': message, 'link': link }
  console.log(name, message)
  console.log(msgs)
  $('#<%= name_HF.ClientID %>').api({
    url: 'Msg/Verify/{method}/{token}',
    urlData: {
      'method': method,
      'token': token
    },
    debug: true,
    method: 'POST',
    data: msgs,
    beforeSend: function (settings) {
      settings.data = 'name=' + name + '&message=' + message + '&link=' + link
      return settings;
    },
    onResponse: function (rsp) {
      console.log(rsp)
      console.log(name, message, link)
      if (rsp.success) {
        $('body').toast({
          title: rsp.results.name,
          message: rsp.results.msg,
          showProgress: 'bottom',
          displayTime: 5000,
          classActions: 'bottom attached',
          actions: [{
            text: '知道了',
            class: 'yellow',
          }, {
            text: '前往<i class="fas fa-arrow-circle-right"></i>',
            class: 'blue',
            click: function () {
              window.open(rsp.results.link, '_blank').focus();
            }
          }]
        });
      }
    }
  }).api('query')
};

  push.client.broadcastVerifiedMessage = function (method, token, name, message) {
    // verified
    // Html encode display name and message. 
    console.log('msg verify')
    $('#signalr_HF').api({
      url: 'Msg/Verify/{method}/{token}',
      urlData: {
        'method': method,
        'token': token
      },
      debug: true,
      method: 'POST',
      data: {
        'name': name,
        'message': message
      },
      beforeSend: function (settings) {
        settings.data = 'name=' + name + '&message=' + message
        return settings;
      },
      onResponse: function (rsp) {
        console.log(rsp)
        console.log(name, message)
        if (rsp.success) {
          $('body').toast({
            title: rsp.results.name,
            message: rsp.results.msg,
            showProgress: 'bottom'
          });
        }
      }
    }).api('query')
  };

  push.client.showErr = function (errtxt) {
    console.log(errtxt)
  }

  // Start the connection.
  $.connection.hub.start().done(function () {

  });
});