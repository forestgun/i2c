# -*- coding: utf-8 -*-
# I2C - Linux i2c-dev backend. 
#
# Copyright (c) 2012 Christoph Anderegg <christoph@christoph-anderegg.ch>
# Copyright (c) 2008 Jonas Bähr, jonas.baehr@fs.ei.tum.de 
# This file may be distributed under the terms of the GNU General Public
# License Version 2.
#
module I2C
  class Dev
    # see i2c-dev.h
      I2C_SLAVE = 0x0703

    def self.create(device_path)
      puts "I2C-DEV.RB :: self.create(device_path)"
      raise Errno::ENOENT, "Device #{device_path} not found." unless File.exists?(device_path)
      @instances ||= Hash.new
      @instances[device_path] = Dev.new(device_path) unless @instances.has_key?(device_path)
      puts "I2C-DEV.RB :: self.create(#{device_path}) @instances.class => #{@instances.class}"
      @instances[device_path]
    end

    # sends every param, begining with +params[0]+
    # If the current param is a Fixnum, it is treated as one byte.
    # If the param is a String, this string will be send byte by byte.
    # You can use Array#pack to create a string from an array
    # For Fixnum there is a convinient function to_short which transforms
    # the number to a string this way: 12345.to_short == [12345].pack("s")
    def write(address, *params)
      data = String.new
      data.force_encoding("US-ASCII")
      params.each do |value|
        data << value
      end
      puts " write(address, *params) => write(#{address},#{data}) "
      @device.ioctl(I2C_SLAVE, address)
      #@device.ioctl(address)
      @device.syswrite(data)
    end

    # this sends *params as the write function and then tries to read
    # +size+ bytes. The result is a String which can be treated with
    # String#unpack afterwards
    def read(address, size, *params)
      ret = ""
      puts "Read(address, size) = read(#{address},#{size})"
      write(address, *params)
      ret = @device.sysread(size)
      pust " ret => #{ret}"
      return ret
    end

    # private
    def initialize(device_path)
      @device = File.new(device_path, 'r+')
      puts " initialize => @device.class = #{@device.class}"
      # change the sys* functions of the file object to meet our requirements
      class << @device
        alias :syswrite_orig :syswrite
        puts "var => #{var} => var.class = #{var.class}"
        puts "syswrite.class = #{syswrite.class}"
        puts "syswrite_orig.class = #{syswrite_orig.class}"
        puts "@device => #{@device} => @device.class = #{@device.class}"
        def syswrite(var)
          puts "def syswrite(var) => syswrite(#{var}) = syswrite.class = #{syswrite.class}"
          puts " syswrite_orig.class = #{syswrite_orig.class}"
	  begin
            syswrite_orig var
          rescue Errno::EREMOTEIO
            raise AckError, "No acknowledge received"
          end
        end
        alias :sysread_orig :sysread
        def sysread(var)
          begin
            sysread_orig var
          rescue Errno::EREMOTEIO
            raise AckError, "No acknowledge received"
          end
        end
      end # class
    end # initialize
  end
end
