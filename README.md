lua-state-machine
=================

lua state machine taking advantage of first class functions.

example
=================
dofile("statemachine.lua")

sm = stateManager:new(true)
firstState = state:new("first state", {function () print("first") sm.nextState() end})
secondState = state:new("first state", {function () print("second") sm.stop() end})
sm.add(firstState)
sm.add(secondState)
sm.run()
=================
