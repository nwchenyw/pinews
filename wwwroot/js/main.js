$(function () {

  /* reference: https://github.com/salmanm/num-words */

  var a = ['', 'one ', 'two ', 'three ', 'four ', 'five ', 'six ', 'seven ', 'eight ', 'nine ', 'ten ', 'eleven ', 'twelve ', 'thirteen ', 'fourteen ', 'fifteen ', 'sixteen ', 'seventeen ', 'eighteen ', 'nineteen '];
  var b = ['', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];

  function inWords(num) {
    if ((num = num.toString()).length > 2) return 'overflow';
    n = ('00' + num).substr(-2).match(/^(\d{2})$/);
    if (!n) return; var str = '';
    str += (n[1] != 0) ? ((str != '') ? 'and ' : '') + (a[Number(n[1])] || b[n[1][0]] + ' ' + a[n[1][1]]) : '';
    return str;
  }

  function ifoverflow() {

    if ($(window).width() < 768) {
      num = $('#main-menu > .item').length;
      $('#main-menu').prepend($('#hidden-menu .option.item'));
      $('#hidden-menu').append($('#main-menu .horizontal.item'));
      if ($('#main-menu').hasClass('block')) {
        $('#main-menu').removeClass('ten item block')
        $('#main-menu .ui.container:empty').remove()
        $('#main-menu #light-search').unwrap()
      } else {
        $('#main-menu').removeClass(inWords(num) + ' item')
      }
      num = $('#main-menu > .item').length;
      $('#main-menu').addClass(inWords(num) + ' item')

      $('.item:has(#search), #search').unbind('mouseenter');
      $('.item:has(#search), #search').unbind('mouseleave');
      $('.item:has(#search), #search').unbind('focusin');
      $('.item:has(#search), #search').unbind('focusout');
      $('#search').addClass('input')
      $('#search').children('input').removeClass('hidden');
      $('#search .search.icon').css('margin', '0');

      //$('#light-search .menu .input').prepend($('#search').children())

      $('#search').addClass('hidden')

      $('#main-menu .top.right.floating.dropdown').removeClass('hidden')
      $('#light-search').removeClass('hidden')
      $('#light-search').dropdown({ transition: 'fade up', message: { noResults: '' } })

      //$('#light-search').remove()

      $('#main-menu .item:has(.bars.icon)').on('click', function () {
        $('.ui.labeled.icon.sidebar').sidebar({ context: 'form', returnScroll: true }).sidebar('toggle');
      })
    } else {
      if ($('#main-menu .horizontal.item').length == 0) {
        $('#main-menu').prepend($('#hidden-menu .horizontal.item'));
        $('#hidden-menu').append($('#main-menu .option.item'));
      } else if ($('#main-menu').hasClass('block')) {
        console.log('overflow')
        $('#main-menu').removeClass('ten item block')
        $('#main-menu').prepend($('#main-menu .ui.container .horizontal.item'))
        $('#main-menu .ui.container:empty').remove()
        $('#main-menu #light-search').unwrap()
      }

      $('.scrolling.pusher').css('max-height', '');
      $('.scrolling.pusher').css('height', '');
      $('.ui.sticky.menu').sticky({
        context: '#main',
        //scrollContext: '.scrolling.pusher',
        jitter: -10,
        debug: true,
        onStick: function () {
          $('.ui.sticky.menu + .placeholder').removeClass('hidden');
          $('.ui.sticky.menu + .placeholder').height($(this).height());
        },
        onUnstick: function () {
          $('.ui.sticky.menu + .placeholder').addClass('hidden');
        }
      });

      $('#main-menu .right.menu').removeClass('hidden')
      $('#search').removeClass('input')
      $('#search').children('input').addClass('hidden');
      $('#search').removeClass('hidden');
      $('#search .search.icon').css('margin', '2.5px 0');
      //$('#main-menu .right.menu .item').append($('#search'))
      $('#main-menu .right.menu .item #search').append($('#light-search .menu .input').children())
      $('#main-menu .top.right.floating.dropdown').addClass('hidden')
      $('#light-search').addClass('hidden')
      $('.item:has(#search)').mouseenter(function () {
        console.log('me')
        $('#search').addClass('input');
        $('#search').children('input').removeClass('hidden');
        //$('#search .search.icon').css('margin', '0');
      })
      $('.item:has(#search)').mouseleave(function () {
        console.log('ml')
        if (!$('#search input').is(':focus')) {
          $('.item > #search').removeClass('input');
          $('.item > #search input').addClass('hidden');
          //$('#search .search.icon').css('margin', '2.5px 0');
        }
      })
      $('#search').focusin(function () {
        console.log('fi')
        $('#search').addClass('input');
        $('#search').children('input').removeClass('hidden');
        //$('#search .search.icon').css('margin', '0');
      })

      $('#search').focusout(function () {
        console.log('fo')
        $('.item > #search').removeClass('input');
        $('.item > #search input').addClass('hidden');
        //$('#search .search.icon').css('margin', '2.5px 0');
      })

      var i = $('#main-menu .horizontal.item').length - 1;
      var dist = 0;
      if (!$('#main-menu').hasClass('block')) dist = 210;
      else i = i - 10;
      console.log(i)
      $('#main-menu .horizontal.item').each(function (n) {
        if (n == i) return false;
        //console.log($(this).outerWidth())
        dist += parseFloat($(this).outerWidth(), 10);
      })
      console.log(dist);
      if ($('#main-menu').width() <= dist) console.log('overflow:', $('#main-menu').width(), dist)
      var num = $('#main-menu > .item').length;

      if ($('#main-menu').width() <= dist) {
        $('#main-menu').addClass(inWords(10) + ' item')
        $('#main-menu').prepend($('<div></div>', { class: 'ui container' }))
        $('#main-menu').prepend($('<div></div>', { class: 'ui container' }))
        console.log($('#main-menu > .item:nth-of-type(-n+10):not(#light-search)'))
        $('#main-menu > .item:nth-of-type(-n+10):not(#light-search)').appendTo('#main-menu .ui.container:nth-child(1)')
        $('#main-menu > .item:nth-of-type(-n+10):not(#light-search)').appendTo('#main-menu .ui.container:nth-child(2)')
        $('#main-menu #light-search').appendTo('#main-menu .ui.container:last')
        $('#main-menu').addClass('block')
        $('#main-menu .right.menu').addClass('hidden')

        $('.item:has(#search), #search').unbind('mouseenter');
        $('.item:has(#search), #search').unbind('mouseleave');
        $('.item:has(#search), #search').unbind('focusin');
        $('.item:has(#search), #search').unbind('focusout');
        $('#search').addClass('input')
        $('#search').children('input').removeClass('hidden');
        $('#search .search.icon').css('margin', '0');

        //$('#light-search .menu .input').prepend($('#search').children())

        $('#search').addClass('hidden')


        $('#main-menu .top.right.floating.dropdown').removeClass('hidden')
        $('#light-search').removeClass('hidden')
        $('#light-search').dropdown({ transition: 'fade up', message: { noResults: '' } })
      } else {
        //var num = $('#main-menu > .item').length;
        //$('#main-menu').removeClass(inWords(num) + ' item')
        //$('#hidden-menu').prepend($('#main-menu .option.item'));
        //$('#main-menu').prepend($('#hidden-menu .horizontal.item'));
      }

    }
  }

  function broadcastAnimate(elm, curr) {
    //console.log(curr)
    $(elm).addClass('hidden');
    var $el = $($(elm)[curr]);
    $el.removeClass('hidden')
    if ($(window).width() >= 768) {
      $el.css({
        'animation-name': 'none',
      });
      //if ($el.prop("tagName") != "marquee")
      //  $el.replaceWith($('<marquee>', { 'class': 'anime-text', 'html': $el.html() }))
      //$el = $($(elm)[curr]);
      if ($el.hasClass('marquee'))
        $el.removeClass('marquee')
      if (!$el.hasClass('pc-marquee'))
        $el.addClass('pc-marquee')
      if (!$('#broadcast .label').hasClass('hidden'))
        $('#broadcast .label').addClass('hidden')
      if (!$('#broadcast .content').hasClass('ml-0'))
        $('#broadcast .content').addClass('ml-0')
      if ($('#broadcast .content').css('width') != '100%')
        $('#broadcast .content').css('width', '100%')
      if ($el.css('border-right') != 0) {
        $el.css('border-right', 0);
      }
      //if ($el.hasClass('marquee'))
      //  $el.removeClass('marquee')
      //if ($('#broadcast .content').hasClass('ml-0'))
      //  $('#broadcast .content').removeClass('ml-0')
      //if ($('#broadcast .label').hasClass('hidden'))
      //  $('#broadcast .label').removeClass('hidden')
      //$('#broadcast .content').css('width', '')
      //if ($el.css('border-right-width') == '0px') {
      //  $el.css('border-right', '2px solid rgba(0, 0, 0, .75)');
      //}
      //$el.css({
      //  'animation-name': 'none',
      //  'width': 0
      //});
      //$el.css({
      //  'animation-name': 'writeText, blinkTextCursor',
      //  'animation-timing-function': 'steps(' + $el.text().length + '), steps(' + $el.text().length + ')',
      //  'animation-duration': '2.5s, 500ms',
      //  'animation-delay': '1s, 0s',
      //  'animation-iteration-count': '1, infinite'
      //})
      //setTimeout(() => {
      //  $el.css({
      //    'width': '100%'
      //  });
      //}, 1000);
    } else {
      $el.css({
        'animation-name': 'none',
      });
      //if ($el.prop("tagName") != "marquee")
      //  $el.replaceWith($('<marquee>', { 'class': 'anime-text', 'html': $el.html() }))
      //$el = $($(elm)[curr]);
      if ($el.hasClass('pc-marquee'))
        $el.removeClass('pc-marquee')
      if (!$el.hasClass('marquee'))
        $el.addClass('marquee')
      if (!$('#broadcast .label').hasClass('hidden'))
        $('#broadcast .label').addClass('hidden')
      if (!$('#broadcast .content').hasClass('ml-0'))
        $('#broadcast .content').addClass('ml-0')
      if ($('#broadcast .content').css('width') != '100%')
        $('#broadcast .content').css('width', '100%')
      if ($el.css('border-right') != 0) {
        $el.css('border-right', 0);
      }
    }
    curr++;
    //console.log(curr, $(elm).length)
    if ($(window).width() >= 768) {
      if (curr == $(elm).length)
        setTimeout(() => {
          broadcastAnimate(elm, 0)
        }, 15000);
      else setTimeout(() => {
        broadcastAnimate(elm, curr)
      }, 15000);
    } else {
      if (curr == $(elm).length)
        setTimeout(() => {
          broadcastAnimate(elm, 0)
        }, 10000);
      else setTimeout(() => {
        broadcastAnimate(elm, curr)
      }, 10000);
    }
  }

  $('.inverted.dimmer .camera.icon').transition('set looping').transition('bounce', '2s')
  $('.inverted.dimmer .newspaper.icon').transition('set looping').transition('bounce', '2s')

  $('.left-show').visibility({
    onPassing: function (calculations) {
      $(this).addClass('slide-in-left')
    },
    onTopVisible: function (calculations) {
      $(this).addClass('slide-in-left')
    }
  });

  $('.top-show').visibility({
    onPassing: function (calculations) {
      $(this).addClass('slide-in-top')
    },
    onTopVisible: function (calculations) {
      $(this).addClass('slide-in-top')
    }
  })

  $('.bottom-show').visibility({
    onPassing: function (calculations) {
      console.log('b')
      $(this).addClass('slide-in-bottom')
    },
    onTopVisible: function (calculations) {
      console.log('b')
      $(this).addClass('slide-in-bottom')
    }
  })
  //$('#main-menu .horizontal.item:not(.active)').mouseenter(function () {
  //  var $el = $(this);
  //  var i = $('#main-menu .horizontal.item').index($el);
  //  console.log(i)
  //  var dist = 0;
  //  if ($('#main-menu .item').length > 11 && i >= 10) i = i - 10;
  //  console.log(i)
  //  $('#main-menu .horizontal.item').each(function (n) {
  //    if (n == i) return false;
  //    //console.log($(this).outerWidth())
  //    dist += parseFloat($(this).outerWidth(), 10);
  //  })
  //  console.log(dist);
  //  $('#main-menu .underline').width($el.outerWidth())
  //  $('#main-menu .underline').css('left', dist + 'px');
  //})
  //$('#main-menu .horizontal.item:not(.active)').mouseleave(function () {
  //  $('#main-menu .underline').width(0)
  //})

  if ($(window).width() > 1200) {
    $('#bottom-left-menu .list').removeClass('two column').addClass('three column')
    $('#user_photo').parent().parent('.image').removeClass('ui tiny')
  } else {
    $('#bottom-left-menu .list').removeClass('three column')
    $('#bottom-left-menu .list').addClass('two column')
    $('#user_photo').parent().parent('.image').addClass('ui tiny')
    //$('.item:has(#search), #search input').unbind();
    //$('#search').addClass('input')
    //$('#search').children('input').removeClass('hidden');
    //$('#search .search.icon').css('margin', '0');
    //$('#light-search .menu').append($('#search'))
    //$('#light-search').removeClass('hidden')
    //$('#light-search').dropdown({ transition: 'fade up' })
    ifoverflow()
  }

  if ($(window).width() <= 991) {
    $('.pusher .four.cards').removeClass('four').addClass('two')
    $('#post_statistic .small.statistic').removeClass('small').addClass('tiny')
    var num = $('#main-menu > .item').length;
    if ($(window).width() <= 768)
      ifoverflow()
    if ($(window).width() < 426) {
      $('.pusher .two.cards').removeClass('two');
      $('.pusher .raised.card').addClass('horizontal');
    }
  } else {
    if ($('.pusher .two.cards').length > 0) $('.pusher .two.cards').removeClass('two').addClass('four')
    else if ($('.pusher .four.cards').length == 0) $('.pusher .top-show.cards').addClass('four')
    if ($('.pusher .raised.card').hasClass('horizontal')) $('.pusher .raised.card').removeClass('horizontal')
    $('.pusher .two.cards').addClass('four').removeClass('two')
    $('#post_statistic .tiny.statistic').addClass('small').removeClass('tiny')
  }

  if ($('#main').height() > $(window).height()) {
    $('.ui.sticky.menu').sticky({
      context: '#main',
      //scrollContext: '.scrolling.pusher',
      jitter: -10,
      debug: true,
      onStick: function () {
        $('.ui.sticky.menu + .placeholder').removeClass('hidden');
        //if ($(this).children('.ui.container').length > 0) {
        //  var total = 0;
        //  $('#main-menu .ui.container').each(function () {
        //    total += $(this).outerHeight();
        //  });
        //  $(this).height(total)
        //}
        $('.ui.sticky.menu + .placeholder').height($(this).height());
      }, onTop: function () {
        if ($(this).children('.ui.container').length > 0) {
          var total = 0;
          $('#main-menu .ui.container').each(function () {
            total += $(this).outerHeight();
          });
          $(this).height(total)
        }
      },
      onUnstick: function () {
        $('.ui.sticky.menu + .placeholder').addClass('hidden');
      }
    });
    //$('form').addClass('pushable')
  }

  $('#main-menu .item:has(.bars.icon)').on('click', function () {
    $('.ui.labeled.icon.sidebar').sidebar({ context: 'form', returnScroll: true })//.sidebar({
      //  context: 'form', onHide: function () {
      //    //$('.scrolling.pusher').css('max-height', '100%');
      //    //$('.scrolling.pusher').css('height', '100%');
      //    $('.ui.sticky.menu').sticky({
      //      context: '#main',
      //      //scrollContext: '.scrolling.pusher',
      //      jitter: -10,
      //      debug: true,
      //      onStick: function () {
      //        $('.ui.sticky.menu + .placeholder').removeClass('hidden');
      //        $('.ui.sticky.menu + .placeholder').height($(this).height());
      //      },
      //      onUnstick: function () {
      //        $('.ui.sticky.menu + .placeholder').addClass('hidden');
      //      }
      //    });
      //  }
      //})
      .sidebar('toggle');
  })

  if ($(window).outerWidth() < 768) {
    //$('#article').children('.eleven.wide.column').removeClass('eleven wide column').addClass('sixteen wide column')
    //$('#recommanded').removeClass('five wide column').addClass('sixteen wide column')
    //$('#recommanded').addClass('hidden')
    $('#recommanded .ui.sticky').unbind()
    //$('#broadcast').addClass('hidden')
    //$('#bottom-left-menu').addClass('hidden')
    if ($('#bottom-left-menu, #bottom-right-menu').hasClass('five')) $('#bottom-left-menu, #bottom-right-menu').removeClass('five wide column').addClass('sixteen wide column')
    if ($('#bottom-left-menu .list').hasClass('two')) $('#bottom-left-menu .list').removeClass('two column').addClass('three column')
    if ($('#bottom-center-menu').hasClass('six')) $('#bottom-center-menu').removeClass('six wide column').addClass('sixteen wide column')
    $('#bottom-center-menu #social-media').addClass('center aligned')
    $('#send_contact').addClass('fluid')
    ifoverflow()
  }

  if ($(window).width() < 426) {
    $('.pusher .two.cards').removeClass('two');
    $('.pusher .raised.card').addClass('horizontal');
  }

  if ($.animateNumber) {
    var comma_separator_number_step = $.animateNumber.numberStepFactories.separator(',')
    $('.cntdown.value').each(function (el) {
      $(this).animateNumber({ number: $(this).html(), numberStep: comma_separator_number_step });
    })
  }

  $(window).on('load', function () {
    broadcastAnimate('#broadcast .anime-text', 0)
    $('.yellow.moon.icon').addClass('hidden');
    $('.blue.dimmer').removeClass('blue').addClass('yellow');
    //$('.coffee.icon').transition('swing right in', 250, function () {
    //  setTimeout(() => { $('.coffee.icon').transition('scale out', '150ms') }, 350)
    //});
    //setTimeout(() => {
    //  $('.newspaper.icon').transition('swing right in', 250, function () {
    //    setTimeout(() => { $('.newspaper.icon').transition('scale', '150ms') }, 350)
    //  });
    //}, 750)
    //setTimeout(() => {
    //  $('.cookie.icon').transition('swing right in', 250, function () {
    //    setTimeout(() => { $('.cookie.icon').addClass('bite') }, 175)
    //    setTimeout(() => { $('.cookie.icon').transition('scale', '150ms') }, 350)
    //  });
    //}, 1500)
    //setTimeout(() => {
    //  $('.grin.icon').transition('swing right in', 250, function () {
    //    setTimeout(() => { $('.grin.icon').addClass('squint') }, 175)
    //    setTimeout(() => { $('.grin.icon').transition('scale', '150ms') }, 550)
    //  });
    //}, 2250)

    //setTimeout(() => {
    $('.yellow.active.dimmer').removeClass('active');
    //}, 3200);
  })

  ifoverflow()

  $(window).on('resize', function () {

    //$('#recommanded .ui.sticky').sticky({
    //  context: '#recommanded',
    //  offset: $('.ui.sticky.menu').height(),
    //  pushing: false,
    //  onTop: function () {
    //    console.log('t')
    //  },
    //  onBottom: function () {
    //    console.log('b')
    //    $('#recommanded .ui.sticky').css('margin-top', 0)
    //    $('#recommanded .ui.sticky').width($('#recommanded').width())
    //  }
    //})
    ifoverflow()
    if ($(window).width() > 1200) {
      $('#bottom-left-menu .list').removeClass('two column').addClass('three column')
      $('#user_photo').parent().parent('.image').removeClass('ui tiny')
    } else {
      $('#bottom-left-menu .list').removeClass('three column')
      $('#bottom-left-menu .list').addClass('two column')
      $('#user_photo').parent().parent('.image').addClass('ui tiny')
    }
    if ($(window).width() <= 991) {
      $('.pusher .four.cards').removeClass('four').addClass('two')
      $('#post_statistic .small.statistic').removeClass('small').addClass('tiny')
      if ($(window).width() < 426) {
        $('.pusher .two.cards').removeClass('two');
        $('.pusher .raised.card').addClass('horizontal');
      }
    } else {
      if ($('.pusher .two.cards').length > 0) $('.pusher .two.cards').removeClass('two').addClass('four')
      else if ($('.pusher .four.cards').length == 0) $('.pusher .top-show.cards').addClass('four')
      if ($('.pusher .raised.card').hasClass('horizontal')) $('.pusher .raised.card').removeClass('horizontal')
      $('.pusher .two.cards').addClass('four').removeClass('two')
      $('#post_statistic .tiny.statistic').addClass('small').removeClass('tiny')
    }

    console.log($(window).outerWidth())
    if ($(window).outerWidth() < 768) {
      $('#article').children('.eleven.wide.column').removeClass('eleven wide column').addClass('sixteen wide column')
      //$('#recommanded').addClass('hidden')
      $('#recommanded .ui.sticky').unbind()
      //$('#broadcast').addClass('hidden')
      //$('#bottom-left-menu').addClass('hidden')
      if ($('#bottom-left-menu, #bottom-right-menu').hasClass('five')) $('#bottom-left-menu, #bottom-right-menu').removeClass('five wide column').addClass('sixteen wide column')
      if ($('#bottom-left-menu .list').hasClass('two')) $('#bottom-left-menu .list').removeClass('two column').addClass('three column')
      if ($('#bottom-center-menu').hasClass('six')) $('#bottom-center-menu').removeClass('six wide column').addClass('sixteen wide column')
      //$('#bottom-center-menu .image').addClass('hidden')
      $('#bottom-center-menu #social-media').addClass('center aligned')
      $('#send_contact').addClass('fluid')

    } else {
      $('#article').children('.sixteen.wide.column').removeClass('sixteen wide column').addClass('eleven wide column')
      //$('#recommanded').removeClass('hidden')
      $('#recommanded .ui.sticky').sticky({
        context: '#recommanded',
        offset: $('.ui.sticky.menu').height(),
        pushing: false,
        onTop: function () {
          console.log('t')
        },
        onBottom: function () {
          console.log('b')
          $('#recommanded .ui.sticky').css('margin-top', 0)
          $('#recommanded .ui.sticky').width($('#recommanded').width())
        }
      })
      //$('#broadcast').removeClass('hidden')
      $('#bottom-left-menu').removeClass('hidden')
      if ($('#bottom-center-menu').hasClass('sixteen')) $('#bottom-center-menu').removeClass('sixteen wide column').addClass('six wide column')
      $('#bottom-center-menu .image').removeClass('hidden')
      $('#bottom-center-menu #social-media').removeClass('center aligned')
      $('#send_contact').removeClass('fluid')
    }
  })

  //$('.item:has(#search)').mouseenter(function () {
  //  console.log('me')
  //  $('#search').addClass('input');
  //  $('#search').children('input').removeClass('hidden');
  //  $('#search .search.icon').css('margin', '2.5px 0');
  //})
  //$('.item:has(#search)').mouseleave(function () {
  //  console.log('ml')
  //  if (!$('#search input').is(':focus')) {
  //    $('.item > #search').removeClass('input');
  //    $('.item > #search input').addClass('hidden');
  //    $('#search .search.icon').css('margin', '2.5px 0');
  //  }
  //})

  //$('#search').focusin(function () {
  //  console.log('me')
  //  $('#search').addClass('input');
  //  $('#search').children('input').removeClass('hidden');
  //  $('#search .search.icon').css('margin', '0');
  //})

  //$('#search').focusout(function () {
  //  console.log('fo')
  //  $('.item > #search').removeClass('input');
  //  $('.item > #search input').addClass('hidden');
  //  $('#search .search.icon').css('margin', '2.5px 0');
  //})

  $('#social-media .icon.button').on('mouseenter', function () {
    if (!$(this).hasClass('tada'))
      $(this).transition('tada');
  })

  $('#bottom-left-menu .column.item').on('mouseenter', function () {
    console.log('hv')
    if (!$(this).children('div').hasClass('swing'))
      $(this).children('div').transition('swing left in');
  })

})