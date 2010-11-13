require 'serialport'

class BalloonReceiver
  
  attr_reader :port, :baudrate, :bitlength, :stopbit
  
  def initialize
    @port = 0
    @baudrate = 115200
    @bitlength = 8
    @stopbit = 1
    
    clean_logs
  end
  
  def clean_logs
    `rm log/*`
  end

  def serial_port
    @serial_port ||= SerialPort.new(0, 115200, 8, 1, SerialPort::NONE)
  end

  def go
    buffer = ""
    
    begin
      while true do
        log.write(c = serial_port.getc)
        
        buffer += c
    
        if c == "\n"
          log.flush
          
          BalloonFix.create_from_csv(buffer)
          
          buffer = "" 
        end
      end

    ensure
      log.close
      serial_port.close
    end
  end
  
  def log
    @f ||= File.new("./log/launch-#{Time.now.strftime("%Y%m%d%H%M%S")}.log", "w")    
  end
end
  
