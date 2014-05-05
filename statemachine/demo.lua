dofile("statemachine.lua")

sm = stateManager:new(true)
firstState = state:new("first state", {function () print("demo") end})
