// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//  require jquery_ujs
//= require bootstrap
//= require_tree .

$(function(){
  var ajax_url      = '/ajax'
  var ajax_vote_url = '/ajax/vote'

  var controller = {

    switch_to : function(panel_id) {
      $('#panel-' + panel_id).show().siblings().hide();
    },

    vote_handler : function(key) {
      // switch to processing panel
      controller.switch_to('processing');

      // send vote request to the server
      jQuery.getJSON(ajax_vote_url, {id:key}, function(data){
        var sum = 0;
        for(var i in data) sum += data[i].count

        for(var i in data) {
          controller.progress_bars[data[i].id]
                      .set_width(data[i].count, sum)
        }

        controller.switch_to('results');
      });
    },

    on_load : function(votes) {
      // add voting buttons
      (function(){
        var cont = $('#panel-vote #voting-buttons');

        for(var i in votes) {
          (function(index){
            return $(document.createElement('button'))
              .text(index)
              .addClass('btn')
              .addClass('btn-primary')
              .click(function() {
                controller.vote_handler(index)
              })
              .appendTo(cont)
          })(votes[i].id);
        }
      })();

      // generate progress bars
      for(var i in votes) {
        var bar = 
        $(document.createElement('div'))
        .addClass('row')
        .append(
          $(document.createElement('div'))
          .addClass('span1')
          .text(votes[i].id)
        )
        .append(
          $(document.createElement('div'))
          .addClass('span9')
          .addClass('progress')
          .append(
            $(document.createElement('div'))
            .addClass('bar')
          )
        )
        .append(
          $(document.createElement('div'))
          .addClass('span2')
          // .text('' + 100+'*'+votes[i]+'/'+sum)
        )
        .appendTo( $('#panel-results #result-container') )

        if(bar.set_width) alert('Redefining set_width');

        bar.set_width = function(amount, sum) {
          $('.progress > .bar', this).attr('style',
            'width:' + Math.floor(100 * amount / sum) + '%')

          $('div:last', this).text( amount )
        }

        this.progress_bars[votes[i].id] = bar
      }


      // switch to vote panel
      this.switch_to('vote');
    },

    progress_bars : {}
  };

  // setup ajax
  $('body').ajaxError(function(ev, req, opt, error) {
    alert('Error requesting ' + opt.url + ': ' + error);
  });

  // query server status
  jQuery.getJSON(ajax_url, function(data){
    controller.on_load(data);
  });

  // attach ui handlers
  $('#button-vote-again').click(function() {
    controller.switch_to('vote');
  });

  $('#source-link').tooltip();
});

