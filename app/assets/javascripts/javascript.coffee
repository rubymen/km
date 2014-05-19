$('#toogle_chardin').click ->
  $('body').chardinJs 'start'

$('#toogle_gremlins').click ->
  gremlins.createHorde().gremlin(gremlins.species.clicker().positionSelector(->
    $list = $("body")
    offset = $list.offset()
    [
      parseInt(Math.random() * $list.outerWidth() + offset.left)
      parseInt(Math.random() * ($list.outerHeight() + $("#info").outerHeight()) + offset.top)
    ]
  )).gremlin(gremlins.species.formFiller()).gremlin(todoCreator = ->
    return  if Math.random() < .9
    e = $.Event("keypress",
      which: 13
    )
    $(document.activeElement).trigger e
    return
  ).gremlin(gremlins.species.scroller()).mogwai(gremlins.mogwais.gizmo()).mogwai(gremlins.mogwais.fps()).strategy(gremlins.strategies.distribution().delay(1).distribution([
    0.3
    0.3
    0.3
    0.1
  ])).before(->
    console.profile "gremlins"
    return
  ).after(->
    console.profileEnd()
    return
  ).unleash nb: 1000
