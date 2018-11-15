--main.lua
function love.load()
  t = love.thread.newThread("thread.lua")
  c1 = love.thread.newChannel()


  input = 0
  
  t:start(input)


  t:wait()
  local topo = love.thread.getChannel( 'info' ):pop()
  local segundo = love.thread.getChannel( 'info' ):pop()

  if topo and segundo then
  	print ("aaaaaaaaaa")
  	print ("tem que dar 7:   " .. topo+segundo)
  else
  	print("deu ruim")
  end
  
end