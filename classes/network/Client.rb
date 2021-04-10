class Client
  def initialize(socket, config)
    @socket = socket
    @config = config
    @finished = false
  end

  def close
    @finished = true
    @listener.terminate if !@listener.nil?
  end

  def listen
    @listener = Thread.new {
      begin
        while !@finished
          first_byte = @socket.getbyte
          fin = first_byte & 0b10000000
          opcode = first_byte & 0b00001111

          raise ConnectionError.throw("Continuations are not supported!") unless fin

          raise "We only support opcode 1" unless opcode == 1

          second_byte = @socket.getbyte
          is_masked = second_byte & 0b10000000
          payload_size = second_byte & 0b01111111

          raise "All incoming frames should be masked according to the websocket spec" unless is_masked
          raise "We only support payloads < 126 bytes in length" unless payload_size < 126

          # STDERR.puts "Payload size: #{payload_size} bytes"

          mask = 4.times.map { @socket.getbyte }

          data = payload_size.times.map { @socket.getbyte }

          unmasked_data = data.each_with_index.map { |byte, i| byte ^ mask[i % 4] }

          received = unmasked_data.pack("C*").force_encoding("utf-8").inspect.gsub!(/\A"|"\Z/, "")

          # STDERR.puts "Converted to a string: #{received}"

          @config.networkHandler(received, self)
        end
      rescue ConnectionError => error
        puts "Connection Error! #{error.to_s}"
      rescue Exception => exception
        # This is falsely thrown and can be ignored, happens when the server is closed
      end
    }
  end

  # Credit for the message sending: https://blog.pusher.com/websockets-from-scratch/
  def send(message)
    # STDERR.puts "Sending message to client: #{message}"

    bytes = [129]
    size = message.bytesize

    bytes += if size <= 125
        [size]
      elsif size < 2 ** 16
        [126] + [size].pack("n").bytes
      else
        [127] + [size].pack("Q>").bytes
      end

    bytes += message.bytes
    data = bytes.pack("C*")
    @socket.write data
  end

  def close
    @finished = true
    @socket.close
  end
end
