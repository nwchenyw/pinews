// check function button active
function check_function_state() {
  //console.log(document.queryCommandState ? true:false)
  if (document.queryCommandState) {
    //console.log('each')
    $('.textarea-option button[data-method]').each(function (i) {
      var $el = $(this);
      var cmd = $el.data('method');
      switch (cmd) {
        case 'cut':
        case 'copy':
          var sel = window.getSelection().toString();
          //console.log(sel, sel.length)
          if (sel.length > 0) $el.removeAttr('disabled')
          else $el.attr('disabled', '');
          break;
        case 'outdent':
          var selection = window.getSelection();
          var container = selection.anchorNode;
          if (container) {
            if (!$(container).is('#article-edit')) {
              //console.log('c:', container)
              var pNode = container.parentNode;
              if (pNode) {
                //console.log('p:', pNode)
                if ($(pNode).is('blockquote')) $el.removeAttr('disabled');
                else $el.attr('disabled', '')
                break;
              }
              if ($(container).is('blockquote')) $el.removeAttr('disabled');
              else $el.attr('disabled', '')
              break;
            }
          }
          break;
        case 'unlink':
          // reference: https://stackoverflow.com/questions/47232304/check-if-selection-contains-link
          if (window.getSelection().toString !== '') {
            const selection = window.getSelection().getRangeAt(0)
            if (selection) {
              if (selection.startContainer.parentNode.tagName === 'A'
                || selection.endContainer.parentNode.tagName === 'A') {
                $el.removeAttr('disabled');
              } else { $el.attr('disabled', '') }
            } else { $el.attr('disabled', '') }
          }
          break;
        default:
          if (document.queryCommandState(cmd)) $el.addClass('active')
          else $el.removeClass('active')
      }
    })
    var $fn_dd = $('.dropdown:has(#font_name)');
    var selection = window.getSelection();
    var container = selection.anchorNode;
    if (container) {
      if (!$(container).is('#article-edit')) {
        var pNode = container.parentNode;
        if (pNode && !($(pNode).is('#article-edit') || $(pNode).is('div'))) {
          var fn = $(pNode).attr('face');
          console.log('p:', fn)
          //console.log('p:', $(pNode))
          //console.log($(container))
          //console.log('p:', $(fn).parents('font[face]'))
          if ($(pNode).is('font') && fn) $fn_dd.dropdown('set selected', fn);
          else $fn_dd.dropdown('clear');
        } else if ($(container).is('font')) {
          var fn = $(container).attr('face');
          if (fs) $fn_dd.dropdown('set selected', fn);
        }
        else $fn_dd.dropdown('clear');
      }
    }

    var $fs_dd = $('.dropdown:has(#font_size)');
    selection = window.getSelection();
    container = selection.anchorNode;
    if (container) {
      if (!$(container).is('#article-edit')) {
        //var pNode = container.parentNode;
        var pNode = $(container).parents('font[style]');
        console.log($(container))
        console.log($(container).parents('font[style]'));
        console.log($(container).parents('font[size]').length)
        if ($(container).parents('font[size]').length == 0) {
          if (pNode && !(pNode.is('#article-edit') || pNode.is('div'))) {
            var fs = pNode.css('font-size');
            console.log('p:', fs)
            if (pNode.length > 0)
              console.log(pNode[0].outerHTML)
            console.log(pNode.is('font') && fs && pNode.length == 1)
            if (pNode.is('font') && fs && pNode.length == 1) $fs_dd.dropdown('set selected', fs);
            else $fs_dd.dropdown('clear');
          } else if ($(container).is('span')) {
            var fs = $(container).css('font-size');
            if (fs) $fs_dd.dropdown('set selected', fs);
          }
          else $fs_dd.dropdown('clear');
        }
      }
    }
  }
}
// textarea init()
function init(img_input, img_replace, textarea) {
  //const img_files = new DataTransfer();
  var img_urls = [];
  $('#article-edit').on('input', function () {
    //console.log('input');
    check_function_state();
    $('#' + textarea).val($('#article-edit').html());
  })

  $('#article-edit').on('keyup', function (e) {
    console.log(e.key)
    if (e.key === "Backspace" || e.key === "Delete" || e.key === "Control") { console.log('chk'); check_img(); }
  })

  $('#article-edit').on('mouseup', function () {
    //console.log('mu');
    check_function_state();
  })

  $('#article-edit').on('click', function () {
    //console.log('c');
    check_function_state();
  })

  var modal_btn = ['symbols', 'addlink', 'insertImg', 'insertVideo', 'inserTable', 'paste-text', 'newading'];
  var modal_opt = {
    'symbols': {
      inverted: true, autofocus: false, allowMultiple: true
    }, 'addlink': {
      inverted: true, autofocus: false, allowMultiple: true, onShow: function () {
        $('#article-edit').focus();
        doSave();
      }
    }, 'insertImg': {
      inverted: true, observeChanges: true, autofocus: false, allowMultiple: true, onShow: function () {
        $('#article-edit').focus();
        doSave();
      }, onVisible: function () {
        $('.insertImg.modal').modal('refresh');
      }
    }, 'insertVideo': {
      inverted: true, autofocus: false, allowMultiple: true, onShow: function () {
        $('#article-edit').focus();
        doSave();
      }
    }, 'inserTable': {
      inverted: true, autofocus: false, allowMultiple: true, onShow: function () {
        $('#article-edit').focus();
        doSave();
        $('.tb-th-option').prop('checked', false);
        $('#tb_th_row').trigger('click');
        $('.tb-option').prop('checked', false);
        $('#tb_normal, #tb_celled').trigger('click');
        $('#tb_row, #tb_col').val(2);
        $('#tb_row').trigger('change');
      }
    }, 'paste-text': {
      inverted: true, allowMultiple: true
    }, 'newading': {
      inverted: true, allowMultiple: true, autofocus: false, onShow: function () {
        $('#article-edit').focus();
        doSave();
      }
    }
  }

  $('.textarea-option button[data-method]').on('click', function () {
    var cmd = $(this).data('method');
    var log = '';
    if (document.queryCommandState) log = document.queryCommandState(cmd) ? 'un' : '';
    console.log('editor log: ', log, cmd);
    if (modal_opt[cmd] != undefined) {
      //console.log(modal_btn.find((x) => { return x == cmd }));
      console.log(cmd)
      $('.' + cmd + '.modal').modal(modal_opt[cmd]).modal('show');
    } else
      document.execCommand(cmd, false, '');
    if (cmd == "undo" || cmd == "redo") check_img();
    $('#article-edit').focus();
  })

  $('.textarea-option button.dropdown .item[data-method]').on('click', function () {
    var cmd = $(this).data('medhod')
    console.log(!$(this).data('option'))
    if (!$(this).data('option')) {
      document.execCommand(cmd, false, '')
    } else {
      var opt = $(this).data('option')
      if (cmd == 'paste' && opt == 'plain') {
        navigator.clipboard.readText().then(clipText =>
          document.execCommand("insertHTML", false, clipText));
      }
    }
  })

  $('#text-color-picker').spectrum({
    type: "flat",
    showPaletteOnly: true,
    togglePaletteOnly: true,
    showInput: true,
    showInitial: true,
    move: function (color) {
      var col = 'rgba(' + color._r + ',' + color._g + ',' + color._b + ',' + color._a + ')';
      console.log(col);
      $('.textarea-option .text-color .font.icon').css('color', col)
      $('.textarea-option .text-bg-color .font.icon').css('color', col)
      document.execCommand('foreColor', 'false', col);
    }
  });
  $('#text-bg-color-picker').spectrum({
    type: "flat",
    showPaletteOnly: true,
    togglePaletteOnly: true,
    showInput: true,
    showInitial: true,
    move: function (color) {
      var col = 'rgba(' + color._r + ',' + color._g + ',' + color._b + ',' + color._a + ')';
      console.log(col);
      $('.textarea-option .text-bg-color .square.icon').css('color', col)
      document.execCommand('backColor', 'false', col);
    }
  });

  $('.dropdown.button').dropdown();
  $('.dropdown.button:has(#img_size)').dropdown({ clearable: true })

  $('.ui.selection.dropdown:has(input[id=upload_type])').dropdown({
    onChange: function (val, txt, $choice) {
      console.log(val, txt, $choice)
      switch (val) {
        case 'file':
          $('#img_url').addClass('hidden')
          //$('label[for=img_' + val + ']').removeClass('hidden')
          //$('#img_upload').removeClass('hidden');
          $('#image_btn').removeClfass('hidden');
          $('#image_file').val('')
          $('#file-name').val();
          break;
        default:
          $('#img_' + val).removeClass('hidden')
          //$('label[for=image_file]').addClass('hidden')
          //$('#img_upload').addClass('hidden');
          $('#image_btn').addClass('hidden');
          $('#img_' + val).val('')
          $('#file-name').val();
          break;
      }
      $('.upload-preview img.ui').removeAttr('src').addClass('visibility-hidden')
      $('.upload-preview img.ui').removeClass('ui')
      $('input[name=alignment] + .buttons label').removeClass('active')
      $('.checkbox:has(.toIcon)').checkbox('uncheck')
      if (!$('#img_' + val).val()) {
        if (!$('.upload-preview img.image').parent().is('.ui.placeholder'))
          $('.upload-preview img.image').wrap('<div/>')
        $('.upload-preview img.image').removeClass('left right floated centered')
        console.log(!$('.upload-preview img.image').parent().is('.ui.placeholder'))
        if (!$('.upload-preview img.image').parent().is('.ui.placeholder')) {
          $('.upload-preview img.image').parent().addClass('ui placeholder');
          console.log($('.upload-preview img.image').parent())
        }
      }
    }
  })
  $('#image_file').on('change', function () {
    $('#file-name').html(document.getElementById('image_file').files[0].name);
  })

  $('input[id^=img_]').on('change', function () {
    var url;
    switch ($(this).attr('id')) {
      case 'img_file':
        $('.upload-preview .image').removeClass('visibility-hidden')
        var file = document.getElementById('image_file').files;
        //console.log(file)
        //console.log(img_files.files)
        //url = URL.createObjectURL(file[0]);
        //for (var n = 0; n < img_files.files.length; n++) {
        //  //console.log(img_files.files[n], file[0])
        //  if (img_files.files[n].name == file[0].name) {
        //    console.log('duplicate')
        //    url = img_urls[n];
        //  }
        //}
        break;
      case 'img_size':
        if (!$('.toIcon').is(':checked')) $('.upload-preview .image').removeClass('spaced');
        $('.upload-preview .image').removeClass('mini tiny small medium large big huge massive fluid visibility-hidden image').addClass($(this).val() + ' image')
        break;
      default:
        url = $(this).val();
        $('.upload-preview .image').removeClass('visibility-hidden')
        console.log(url)
        break;
    }
    $('.upload-preview .image').attr('src', url).on('load', function () {
      $('.insertImg.modal').modal('refresh');
    })
    $('.upload-preview .image').addClass('ui')

    if ($('.upload-preview img.ui').parent().is('.ui.placeholder')) {
      $('.upload-preview img.ui').unwrap();
    }
  })

  $('input[name=alignment]').on('change', function () {
    var id = $(this).attr('id');
    var val = $(this).val();
    $('input[name=alignment] + .buttons label').removeClass('active')
    $('label[for=' + id + ']').addClass('active')
    $('.upload-preview img.ui').removeClass('right left floated centered');
    $('.upload-preview img.ui').addClass(val);
  })

  $('.checkbox:has(.toIcon)').checkbox({
    onChecked: function () {
      console.log($(this).parent('.button'), 'onChecked called');
      $('.upload-preview img.ui').addClass('spaced')
      $(this).parent('.button').addClass('fluid')
      $('.dropdown:has(#font_v_align)').removeClass('hidden')
    },
    onUnchecked: function () {
      console.log('onUnchecked called');
      $('.upload-preview img.ui').removeClass('spaced')
      $('.upload-preview img.ui').removeClass('top middle bottom aligned');
      $(this).parent('.button').removeClass('fluid')
      $('.dropdown:has(#font_v_align)').addClass('hidden')
    }
  })

  $('.dropdown:has(#font_v_align)').dropdown({
    onChange: function (val, txt, $choice) {
      $('.upload-preview img.ui').removeClass('top middle bottom aligned');
      $('.upload-preview img.ui').addClass(val);
    }
  })

  $('.insertImg .actions .primary.button').on('click', function () {
    var url = $('.upload-preview .image').attr('src');
    //if (img_urls.indexOf(url) < 0 && document.getElementById('upload_type').value == 'file') {
    //  img_files.items.add(document.getElementById("img_file").files[0]);
    //  img_urls.push(url);
    //  document.getElementById(img_input).files = img_files.files;
    //  $('#' + img_replace).val(img_urls.join(','));
    //  console.log(document.getElementById(img_input).files)
    //  console.log($('#' + img_replace).val());
    //}

    var img = "&zwnj;" + $('.upload-preview img.ui').wrap('<p/>').parent().html() + "&zwnj;";
    $('.upload-preview img.ui').unwrap();
    document.getElementById("image_file").value = "";
    $('#file-name').val();
    console.log(img);
    doRestore();
    console.log(savedSelection)
    document.execCommand("insertHTML", false, img);
    $('.insertImg.modal').modal('hide')
  })
  function check_img() {
    //console.log(img_urls)
    var now_exist = $('#article-edit .ui.image').map(function () { return $(this).attr("src"); }).get();
    //var not_exist = img_urls.filter((i) => { return now_exist.indexOf(i) < 0 });
    //console.log(not_exist)
    $('#uploaded_img .ui.image').each(function (i, el) {
      //console.log(i, el);
      if (now_exist.indexOf($(el).children('img').attr('src')) < 0) {
        if ($(el).children('.ribbon').length == 0) {
          $(el).append("<a class='ui red ribbon label'>閒置</a>");
        }
      } else {
        $(el).children('.ribbon').remove();
      }
    })
    ////img_urls.forEach(function (el, i) {
    ////  if (not_exist.indexOf(el) >= 0) {
    ////    img_urls = img_urls.filter((j) => { return j != el });
    ////    img_files.items.remove(i);
    ////  }
    ////})
    //document.getElementById(img_input).files = img_files.files;
    $('#' + img_replace).val(img_urls.join(','));
  }

  $('.dropdown:has(#font_size)').dropdown()
  $('.dropdown:has(#font_name)').dropdown()

  $('#font_name').on('change', function () {
    console.log($(this).val())
    var sel = window.getSelection();
    var c = sel.anchorNode;
    var pn = sel.parentNode;
    console.log(c, pn)
    if (pn != $(this).val() && $(this).val() != '')
    document.execCommand('fontName', false, $(this).val());
  })

  function surroundSelection(element) {
    if (window.getSelection) {
      var sel = window.getSelection();
      if (sel.rangeCount) {
        var range = sel.getRangeAt(0).cloneRange();
        range.surroundContents(element);
        sel.removeAllRanges();
        sel.addRange(range);
      }
    }
  }

  $('#font_size').on('change', function () {
    var $el = $(this);
    console.log($el.val())
    var sel = window.getSelection();
    var c = sel.anchorNode;
    var pn = sel.parentNode;
    console.log(c, pn)
    if (pn != $el.val() && $el.val() != '') {
      //var f = document.createElement('font');
      //surroundSelection(f)
    document.execCommand('fontSize', false, '1');
    var childs = $('#article-edit').find('*');
    childs.filter((el) => { return sel.toString().indexOf($(childs[el]).text()) != -1 }).each(function (i) {
      var s = $(this).attr('size')
      if (s) {
        $(this).removeAttr('size')
        console.log('change')
        $(this).css('font-size', $el.val());
      }
    })}
  })



  $('.tbcell_amount').on('change', function () {
    console.log('tb')

    var r = $('#tb_row').val();
    var c = $('#tb_col').val();
    var $rth = $('#tb_th_row');
    var $cth = $('#tb_th_col');
    var $fth = $('#tb_th_footer');
    var $fw = $('#tb_th_full_width');

    $('#preview-tb tr').remove();

    if ($fth.is(':checked')) { if ($('#preview-tb').find('tfoot').length == 0) $('#preview-tb').append('<tfoot></tfoot>') }
    else $('#preview tfoot').remove();

    if ($fw.is(':checked') && !$fw.parent().hasClass('hidden'))
      $('#preview-tb thead, #preview-tb tfoot').addClass('full-width')
    else $('#preview-tb thead, #preview-tb tfoot').removeClass('full-width')

    for (var x = 0; x < r; x++) {
      var rowcells = $('<tr></tr>');
      for (var y = 0; y < c; y++) {
        if ((x == 0 && !(!$rth.is(':checked') && $cth.is(':checked'))) || (x + 1 == r && $fth.is(':checked')))
          rowcells.append($('<th></th>', { text: '預覽文字' }))
        else rowcells.append($('<td></td>', { text: '預覽文字' }))
      }
      if (x == 0 && !(!$rth.is(':checked') && $cth.is(':checked'))) $('#preview-tb thead').append(rowcells)
      else if (x + 1 == r && $fth.is(':checked')) $('#preview-tb tfoot').append(rowcells)
      else $('#preview-tb tbody').append(rowcells)
    }
  })

  $('.tb-option').on('click', function () {
    var $el = $(this);
    var id = $el.attr('id')
    var cl = id.replace(/^tb_/g, '').replace('_', ' ');
    console.log(cl)
    if ($el.hasClass('pad')) {
      if ($el.is(':checked') && cl != 'normal') {
        $('#preview-tb').removeClass('compact very padded');
        $('#preview-tb').addClass(cl)
      }
      else {
        $('#preview-tb').removeClass('compact very padded');
      }
    } else if ($el.is(':checked')) {
      $('#preview-tb').addClass(cl)
    } else $('#preview-tb').removeClass(cl)
  })

  $('.tb-th-option').on('click', function () {
    var $el = $(this);
    var r = $('#tb_row').val();
    var c = $('#tb_col').val();
    var $rth = $('#tb_th_row');
    var $cth = $('#tb_th_col');
    var $fth = $('#tb_th_footer');
    var $fw = $('#tb_th_full_width');

    $('#preview-tb tr').remove();

    if ($rth.is(':checked') && $cth.is(':checked'))
      $fw.parent().removeClass('hidden');
    else $fw.parent().addClass('hidden');

    if ($fth.is(':checked')) { if ($('#preview-tb').find('tfoot').length == 0) $('#preview-tb').append('<tfoot></tfoot>') }
    else $('#preview-tb tfoot').remove();

    if ($fw.is(':checked') && !$fw.parent().hasClass('hidden'))
      $('#preview-tb thead, #preview-tb tfoot').addClass('full-width')
    else $('#preview-tb thead, #preview-tb tfoot').removeClass('full-width')

    for (var x = 0; x < r; x++) {
      var rowcells = $('<tr></tr>');
      for (var y = 0; y < c; y++) {
        if ((x == 0 && !(!$rth.is(':checked') && $cth.is(':checked'))) || (x + 1 == r && $fth.is(':checked')))
          rowcells.append($('<th></th>', { text: '預覽文字' }))
        else rowcells.append($('<td></td>', { text: '預覽文字' }))
      }
      if (x == 0 && !(!$rth.is(':checked') && $cth.is(':checked'))) $('#preview-tb thead').append(rowcells)
      else if (x + 1 == r && $fth.is(':checked')) $('#preview-tb tfoot').append(rowcells)
      else $('#preview-tb tbody').append(rowcells)
    }

    if ($cth.is(':checked')) {
      console.log('欄col')
      $('#preview-tb').removeClass('basic')
      $('#preview-tb').addClass('definition')
    } else if ($rth.is(':checked')) {
      console.log('列row')
      $('#preview-tb').removeClass('basic definition')
    } else {
      $('#preview-tb').removeClass('definition')
      $('#preview-tb').addClass('basic')
    }
  })

  $('.inserTable .blue.button').on('click', function () {
    doRestore();

    $('#preview-tb th, #preview-tb td').empty();
    var table = $('#preview-tb').clone().removeAttr('id')[0]
    var t = table.outerHTML.toString();
    document.execCommand('insertHTML', false, t);

    $('.inserTable.modal').modal('hide');
  })

  $('.insertVideo .content .dropdown').dropdown({
    onChange: function (value, text) {
      console.log(value)
      $('.insertVideo .content .format_url').html(value);
    }
  });

  $('.insertVideo .actions .primary.button').on('click', function () {
    doRestore();
    var video = $('.insertVideo .content .ui.embed').clone()[0];
    //console.log(video);
    var vid = "&zwnj;" + video.outerHTML.toString() + "&zwnj;";
    document.execCommand('insertHTML', false, vid);
    $('.insertVideo.modal').modal('hide');
  })

  $('.insertVideo #video_id').on('change', function () {
    var val = $(this).val();
    var $sel = $('#video_type').val();
    if ($sel == 'https://youtu.be/') {
      var isYoutube = val.match(/(?:http:|https:|)\/\/(www\.)?(?:youtube\.com|youtu\.be)\/?(?:watch\?|embed)?(^|\/|v=)?([a-z0-9_-]{11})/i);
      if (isYoutube != null) {
        var match = val.match(/(^|\/|v=)?([a-z0-9_-]{11})/i);
        if (match != null) {
          var final = match[0].replace(/(\/|v=)/i, '');
          $(this).val(final);
          if (checkYoutubeValid(final)) {
            var setting = {};
            setting.source = 'youtube';
            setting.id = final;
            console.log(setting);
            $('.insertVideo .content .ui.embed').attr('data-id', final);
            $('.insertVideo .content .ui.embed').attr('data-source', 'youtube');
            $('.insertVideo .content .ui.embed').attr('contenteditable', 'false');
            $('.insertVideo .content .ui.embed').embed(setting);
          }
        }
      } else if (val.match(/^[a-z0-9_-]{11}$/i).length > 0) {
        console.log(val.match(/^[a-z0-9_-]{11}$/i)[0])
        if (checkYoutubeValid(val)) {
          var setting = {};
          setting.source = 'youtube';
          setting.id = val;
          console.log(setting);
          $('.insertVideo .content .ui.embed').attr('data-id', val);
          $('.insertVideo .content .ui.embed').attr('data-source', 'youtube');
          $('.insertVideo .content .ui.embed').attr('contenteditable', 'false');
          $('.insertVideo .content .ui.embed').embed(setting);
        }
      }
    } else {
      var isVimeo = val.match(/(?:http:|https:|)\/\/(?:player.|www.)?vimeo\.com\/(?:video\/|embed\/|watch\?\S*v=|v\/)?(\d*)/i);
      var isVimeoId = val.match(/^\d+$/i);
      if (isVimeo != null) {
        var match = val.match(/\/(?:video\/|embed\/|watch\?\S*v=|v\/)?(\d+)/i);
        if (match != null) {
          var final = match[0].replace(/\/(?:video\/|embed\/|watch\?\S*v=|v\/)?/i, '');
          $(this).val(final);
          console.log(match, final);
          var setting = {};
          setting.source = 'vimeo';
          setting.id = final;
          console.log(setting);
          $('.insertVideo .content .ui.embed').attr('data-id', final);
          $('.insertVideo .content .ui.embed').attr('data-source', 'vimeo');
          $('.insertVideo .content .ui.embed').attr('contenteditable', 'false');
          $('.insertVideo .content .ui.embed').embed(setting);
        }
      } else if (isVimeoId != null) {
        console.log(val.match(/^\d+$/i)[0])
        var setting = {};
        setting.source = 'vimeo';
        setting.id = val;
        console.log(setting);
        $('.insertVideo .content .ui.embed').attr('data-id', val);
        $('.insertVideo .content .ui.embed').attr('data-source', 'vimeo');
        $('.insertVideo .content .ui.embed').attr('contenteditable', 'false');
        $('.insertVideo .content .ui.embed').embed(setting);
      }

      //regex reference: https://regexr.com/4lrm3 and https://regexr.com/3nsop
      //youtube url valid check reference: https://gist.github.com/tonY1883/a3b85925081688de569b779b4657439b
    }
  });
  symbols_init();
  symbol_popup();
}

function checkYoutubeValid(id) {
  var img = new Image();
  var valid = true;
  img.src = "http://img.youtube.com/vi/" + id + "/mqdefault.jpg";
  img.onload = function () {
    valid = checkThumbnail(this.width);
  }
  return valid;
}

function checkThumbnail(width) {
  if (width === 120) {
    console.log('Error: video not found!');
    return false;
  }
}

$('.newading.modal .primary.button').on('click', function () {
  doRestore();
  if (window.getSelection) {
    var vid_url = $('.newading input[type=radio][name$=personal_ad]:checked + label .ui.ad .ui.embed').attr('data-id');
    var vid_type = $('.newading input[type=radio][name$=personal_ad]:checked + label .ui.ad .ui.embed').attr('data-source');
    var title = $('.newading input[type=radio][name$=personal_ad]:checked + label .ui.ad .content .header').html();
    var meta = $('.newading input[type=radio][name$=personal_ad]:checked + label .ui.ad .content .meta').html();
    var img = $('.newading input[type=radio][name$=personal_ad]:checked + label .ui.ad .image .image').attr('src');
    var href = $('.newading input[type=radio][name$=personal_ad]:checked + label .ui.ad .image a').attr('data-href')
    var html = $("<div />").append($("<div />", {
      class: 'ui centered medium rectangle test ad',
      'data-text': '廣告預留區',
      'data-id': vid_url,
      'data-source': vid_type,
      'data-header': title,
      'data-meta': meta,
      'data-img': img,
      'data-href': href
    })).html();

    console.log({
      'data-id': vid_url,
      'data-source': vid_type,
      'data-header': title,
      'data-meta': meta,
      'data-img': img,
      'data-href': href
    })

    if ($('.newading input[type=radio][name$=personal_ad]:checked + label').html() != "") {
      var el = $('.newading input[type=radio][name$=personal_ad]:checked + label').children('.card').clone().css('display', 'table')[0];
      //html = el.outerHTML.replace('data-href', 'href');
    }
    document.execCommand('insertHTML', false, "&zwnj;<div class='ui basic secondary placeholder center aligned segment' contenteditable='false'> <span class='ui mini text' style='padding-bottom: 0.6rem;'>廣告(請繼續閱讀本文)</span>" + html + "</div>&zwnj;")
  }
  $('.newading.modal').modal('hide')
})

$('.addlink.modal .primary.button').on('click', function () {
  var text = $('.addlink.modal #link_text').val();
  var url = $('.addlink.modal #link_url').val();
  doRestore();
  if (window.getSelection) {
    sel = window.getSelection();
    console.log(sel.toString())
    if (sel.toString().length > 0 && sel.toString() == text) {
      document.execCommand('CreateLink', false, url);
    } else {
      var atag = $('<a></a>', { text: text, href: url, target: '_blank' });
      var html = atag.wrap('<p/>').parent().html();
      console.log(html)
      document.execCommand('insertHTML', false, html)
    }
  } $('.addlink.modal').modal('hide')
})

$('.addlink.modal').modal({
  onShow: function () {
    doSave();
    console.log(savedSelection)
  }
})


function symbol_init() {
  $('.symbols.modal .segment .button').on('click', function () {
    doRestore();
    var sel, range, html = $(this).children('i').html();
    if (window.getSelection) {
      // IE9 and non-IE
      console.log(window.getSelection().toString())
      document.execCommand('insertHTML', false, html)
    } else if (document.selection && document.selection.type != "Control") {
      // IE < 9
      document.selection.createRange().pasteHTML(html);
    }
    $('.symbols.modal').modal('hide')
  })
}

function symbols_init() {
  var li2 = [
    8211, 8212, 8216, 8217, 8220, 8221,
    8230, 12289, 12290, 12296, 12297, 12298,
    12299, 12300, 12301, 12302, 12303, 12304,
    12305, 12308, 12309, 65281, 65288, 65289,
    65292, 65294, 65306, 65307, 65311
  ]
  //————————————————
  //版权声明：本文为CSDN博主「COCO56」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
  //原文链接：https://blog.csdn.net/COCO56/article/details/87618925

  for (var i = 0; i < li2.length; i++) {
    var sym = '&#' + li2[i].toString();
    var icon = $('<i></i>', { html: sym, class: "icon" })
    var tooltip = $('<i></i>', { class: 'ui big icon', html: sym }).wrap('<p/>').parent().html()
      + '<small>' + '&amp;#' + li2[i].toString() + '</small>';
    var btn = $('<div></div>', {
      class: "ui mini basic icon button",
      'data-variation': 'mini',
      'data-position': 'bottom center',
      'data-html': tooltip
    }).append(icon)
    $('.symbols.modal .segment[data-tab=first]').append(btn)
  }

  for (var i = 8704; i < 8960; i++) {
    var sym = '&#' + i.toString();
    var icon = $('<i></i>', { html: sym, class: "icon" })
    var tooltip = $('<i></i>', { class: 'ui big icon', html: sym }).wrap('<p/>').parent().html()
      + '<small>' + '&amp;#' + i.toString() + '</small>';
    var btn = $('<div></div>', {
      class: "ui mini basic icon button",
      'data-variation': 'mini',
      'data-position': 'bottom center',
      'data-html': tooltip
    }).append(icon)
    $('.symbols.modal .segment[data-tab=second]').append(btn)
  }

  for (var i = 9632; i < 9728; i++) {
    var sym = '&#' + i.toString();
    var icon = $('<i></i>', { html: sym, class: "icon" })
    var tooltip = $('<i></i>', { class: 'ui big icon', html: sym }).wrap('<p/>').parent().html()
      + '<small>' + '&amp;#' + i.toString() + '</small>';
    var btn = $('<div></div>', {
      class: "ui mini basic icon button",
      'data-variation': 'mini',
      'data-position': 'bottom center',
      'data-html': tooltip
    }).append(icon)
    $('.symbols.modal .segment[data-tab=third]').append(btn)
  }

  for (var i = 8592; i < 8704; i++) {
    var sym = '&#' + i.toString();
    var icon = $('<i></i>', { html: sym, class: "icon" })
    var tooltip = $('<i></i>', { class: 'ui big icon', html: sym }).wrap('<p/>').parent().html()
      + '<small>' + '&amp;#' + i.toString() + '</small>';
    var btn = $('<div></div>', {
      class: "ui mini basic icon button",
      'data-variation': 'mini',
      'data-position': 'bottom center',
      'data-html': tooltip
    }).append(icon)
    $('.symbols.modal .segment[data-tab=third]').append(btn)
  }

  for (var i = 9984; i < 10175; i++) {
    var sym = '&#' + i.toString();
    var icon = $('<i></i>', { html: sym, class: "icon" })
    var tooltip = $('<i></i>', { class: 'ui big icon', html: sym }).wrap('<p/>').parent().html()
      + '<small>' + '&amp;#' + i.toString() + '</small>';
    var btn = $('<div></div>', {
      class: "ui mini basic icon button",
      'data-variation': 'mini',
      'data-position': 'top center',
      'data-html': tooltip
    }).append(icon)
    $('.symbols.modal .segment[data-tab=third]').append(btn)
  }

  symbol_init();
  $('.symbols.modal .tabular.menu .item').tab()
}

async function symbol_popup() {
  await $('.symbols.modal').modal({ inverted: true });
  console.log('popup')
  $('.symbols.modal .segment .button').popup();
}


var saveSelection, restoreSelection;

if (window.getSelection && document.createRange) {
  saveSelection = function (containerEl) {
    var range = window.getSelection().getRangeAt(0);
    var preSelectionRange = range.cloneRange();
    preSelectionRange.selectNodeContents(containerEl);
    preSelectionRange.setEnd(range.startContainer, range.startOffset);
    var start = preSelectionRange.toString().length;

    return {
      start: start,
      end: start + range.toString().length
    }
  };

  restoreSelection = function (containerEl, savedSel) {
    var charIndex = 0, range = document.createRange();
    range.setStart(containerEl, 0);
    range.collapse(true);
    var nodeStack = [containerEl], node, foundStart = false, stop = false;

    while (!stop && (node = nodeStack.pop())) {
      if (node.nodeType == 3) {
        var nextCharIndex = charIndex + node.length;
        if (!foundStart && savedSel.start >= charIndex && savedSel.start <= nextCharIndex) {
          range.setStart(node, savedSel.start - charIndex);
          foundStart = true;
        }
        if (foundStart && savedSel.end >= charIndex && savedSel.end <= nextCharIndex) {
          range.setEnd(node, savedSel.end - charIndex);
          stop = true;
        }
        charIndex = nextCharIndex;
      } else {
        var i = node.childNodes.length;
        while (i--) {
          nodeStack.push(node.childNodes[i]);
        }
      }
    }

    var sel = window.getSelection();
    sel.removeAllRanges();
    sel.addRange(range);
  }
}
else if (document.selection && document.body.createTextRange) {
  saveSelection = function (containerEl) {
    var selectedTextRange = document.selection.createRange();
    var preSelectionTextRange = document.body.createTextRange();
    preSelectionTextRange.moveToElementText(containerEl);
    preSelectionTextRange.setEndPoint("EndToStart", selectedTextRange);
    var start = preSelectionTextRange.text.length;

    return {
      start: start,
      end: start + selectedTextRange.text.length
    }
  };

  restoreSelection = function (containerEl, savedSel) {
    var textRange = document.body.createTextRange();
    textRange.moveToElementText(containerEl);
    textRange.collapse(true);
    textRange.moveEnd("character", savedSel.end);
    textRange.moveStart("character", savedSel.start);
    textRange.select();
  };
}

$('.newading.modal .tabular.menu .item').tab();

var savedSelection;

function doSave() {
  savedSelection = saveSelection(document.getElementById("article-edit"));
  $('.addlink.modal #link_text').val(window.getSelection().toString());
}

function doRestore() {
  if (savedSelection) {
    restoreSelection(document.getElementById("article-edit"), savedSelection);
  }
}
// reference: http://jsfiddle.net/WeWy7/3/

//init();
