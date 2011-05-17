class PanelHandler
  constructor: (@panel) ->
    

  toggle: ->
    if @panel.position().left is 0
      @panel.animate {"left": -@panel.width()}, 200
    else
      @panel.animate {"left":0}, 200
