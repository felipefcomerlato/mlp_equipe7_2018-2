require "love.timer"

local input = ...

function testSleep(input)
  print("Thread com input = " .. input)
  love.timer.sleep(input)
end

testSleep(input)
