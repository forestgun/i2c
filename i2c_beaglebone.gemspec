Gem::Specification.new do |s|
  s.name        = 'i2c_beaglebone'
  s.version     = '0.3.1'
  s.date        = '2013-08-19'
  s.summary     = "I2C access library (for Linux Beaglebone)."
  s.description = "Interface to I2C (aka TWI) implementations. Also provides abstractions for some I2c-devices. Created with the Raspberry Pi in mind."
  s.authors     = ["origin Christoph Anderegg forked @forestgun"]
  s.email       = 'fortes.movil@gmail.com'
  s.files       = ["lib/i2c.rb", 
  		   "lib/i2c/i2c.rb", 
		   "lib/i2c/backends/i2c-dev.rb", 
  		   "lib/i2c/drivers/mcp230xx.rb",
		   "test//mcp230xx_spec.rb",
		   "rules/88-i2c.rules"]
  s.extra_rdoc_files = ['README.rdoc']
  s.homepage    = 'https://github.com/forestgun/i2c_beaglebone'
end
