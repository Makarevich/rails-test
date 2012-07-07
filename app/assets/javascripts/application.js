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
  var votes = [1, 4, 2, 4, 3];

  var controller = {

    switch_to : function(panel_id) {
      $('#panel-' + panel_id).show().siblings().hide();
    },

    vote_handler : function(key) {
      // store new vote
      votes[key]++;

      var sum = 0;
      for(var i = 0; i < votes.length; i++)
        sum += votes[i];

      // generate results
      for(var i = 0; i < votes.length; i++) {
        this.progress_bars[i].set_width(votes[i], sum);
      }

      this.switch_to('results');
    },

    on_load : function() {
      // add voting buttons
      (function(){
        var w = Math.floor(12 / votes.length);

        var cont = $('#panel-vote #voting-buttons');

        for(var i = 0; i < votes.length; i++) {
          (function(index){
            return $(document.createElement('button'))
              .text(i+1)
              .addClass('btn')
              .addClass('btn-primary')
              .click(function() {
                controller.vote_handler(index)
              })
              .appendTo(cont)
          })(i);
        }
      })();

      // generate progress bars
      for(var i = 0; i < votes.length; i++) {
        var bar = 
        $(document.createElement('div'))
        .addClass('row')
        .append(
          $(document.createElement('div'))
          .addClass('span1')
          .text(i+1)
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

        this.progress_bars[i] = bar;
      }


      // switch to vote panel
      this.switch_to('vote');
    },


    progress_bars : new Array(votes.length)
  };

  controller.on_load();

  // attach handlers
  $('#button-vote-again').click(function() {
    controller.switch_to('vote');
  });
});

