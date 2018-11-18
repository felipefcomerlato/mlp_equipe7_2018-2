socket = require "socket"

-- This is only test of paralellism use with love2d + Lua
function love.load()
  thread = love.thread.newThread("thread.lua")
  thread2 = love.thread.newThread("thread.lua")

  input_5 = 5
  input_4 = 4

  execution_start = socket.gettime() * 1000

  thread:start(input_4)
  thread2:start(input_5)
  thread:wait()
  thread2:wait()

  execution_time = socket.gettime() * 1000 - execution_start
  print(string.format("Tempo total de execucao: %.0f Milisegundos",
                        execution_time))
end
