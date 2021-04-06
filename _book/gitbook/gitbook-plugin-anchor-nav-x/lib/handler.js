require(["gitbook", "jquery"], function(gitbook, $) {
  function handler(e, config) {
    var toolTipMode = config['anchor-navigation-ex'].toolTipMode;
    function handlerClickTooltip() {
      var $toolTip = $('#anchor-navigation-ex-navbar .fa')
      var $list = $('#anchor-navigation-ex-navbar ul')

      $toolTip.on('click', function() {
        $toolTip.toggleClass('fa-plus-circle fa-minus-circle')
        $list.toggleClass('tooltip-show')
      })
    }
    
    function handlerHoverTooltip() {
      var $toolTip = $('#anchor-navigation-ex-navbar .fa')
      var $list = $('#anchor-navigation-ex-navbar ul')

      $toolTip.on('mouseenter', function() {
        $list.addClass('tooltip-show')
        $toolTip.addClass('fa-plus-circle')
      })
    
      $toolTip.on('mouseleave', function() {
        $list.removeClass('tooltip-show')
        $toolTip.removeClass('fa-plus-circle')
      })
    }

    if (toolTipMode == 'click')  {
      handlerClickTooltip();
    } else {
        handlerHoverTooltip();
    }
  }

    gitbook.events.bind('page.change', function (e) {
      var config = gitbook.state.config.pluginsConfig
      console.log('change', e)
      handler(e, config)
    })
})