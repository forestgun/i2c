#require "i2c"
require_relative 'i2c'
#require "i2c/backends/i2c-dev"

#@lsm303 = ::I2C.create('/dev/i2c-1')
@lsm303 = I2C::Dev.create('/dev/i2c-1')
puts "Hemos creado el objeto @lsml303"
puts "Objeto #{@lsm303.class}"
puts " y vamos a realizar una prueba de lectura"
puts @lsm303.read(0x5D, 0x2B)
puts @lsm303.read(0x5D, 0x2C)
puts " Ahora vamos a realizar una prueba de escritura"
@lsm303.write(0x5D, 0x20, 0xe0)
pust " Finalizo escritura e iniciamos otra lectura"
puts @lsm303.read(0x5d, 0x2b)
puts @lsm303.read(0x5d, 0x2c)
