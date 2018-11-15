-- thread.lua
local input = ...

function test(input)
  a = 3
  a = a + input

  print("dentro da funcao vou printar a: "..a)
  return a
end

print ("TO AQUI CARAIO")

print ("TO PRINTANDO O VALOR DO INPUT ".. input)

love.thread.getChannel( 'info' ):push(4)
love.thread.getChannel( 'info' ):push(test(input))

