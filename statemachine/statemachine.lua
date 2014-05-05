local state = {}
local state_mt = {__index = state}

function state:new(new_id, new_wrap)
  local new_inst = {id = new_id, wrap = {func = new_wrap[1]}, orig}
  self.orig = self.wrap
  setmetatable(new_inst, state_mt)
  return new_inst
end

function state:getName()
  return self.id
end

function state:update()
  self.wrap.func()
end

local stateManager = {}
local stateManager_mt = {__index = stateManager}
function stateManager:new(isDebugMode)
  local new_inst = {running = true, selected = 1, list = {}, previousState = 1, debugMode = isDebugMode}
  setmetatable(new_inst, stateManager_mt)
  return new_inst
end

function stateManager:debugModeOn(isDebugMode)
  self.debugMode = isDebugMode
  if self.debugMode == true then
    print("# of states "  .. #self.list)
  end
end
function stateManager:rollback()
  temp = self.selected
  self.selected = self.previousState
  self.previousState = temp
  if self.debugMode == true then print("rolled back to " .. self.list[self.selected]:getName() .. " state...") end
end
function stateManager:add(new_state)
  table.insert(self.list, new_state)
end

function stateManager:nextState()
  self.previousState = self.selected
  if #self.list > self.selected then
    self.selected = self.selected + 1
  else
    self.selected = 1
  end
  if self.debugMode == true then print("changed to " .. self.list[self.selected]:getName() .. " state...") end
end

function stateManager:changeStateTo(new_selected)
  self.previousState = self.selected
  if type(new_selected) == "number" then
    if new_selected > #self.list or new_selected < 1 then
      if self.debugMode then print("invalid state number...") end
    else
      self.selected = new_selected
      if self.debugMode == true then print("changed to " .. self.list[self.selected]:getName() .. " state...") end
    end
  elseif type(new_selected) == "string" then
    for i = 1, #self.list do
      if self.list[i]:getName() == new_selected then
            self.selected = i
        if self.debugMode == true then print("changed to " .. self.list[self.selected]:getName() .. " state...") end
            break
      else
            if i == #self.list then
              if self.debugMode == true then print("can't find state id...") end
            end
      end
    end
  else
    if self.debugMode == true then print("unknown type...") end
  end
end

function stateManager:run()
  self:changeStateTo(1)
  if #self.list >= 1 then
    while self.running do
      self.list[self.selected]:update()
    end
  else
    if self.debugMode == true then print("state list empty...") end
  end
end
function stateManager:stop()
  self.running = false
  if self.debugMode == true then print("state machine has stopped running") end
end
