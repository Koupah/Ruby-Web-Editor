require "socket" # Provides TCPServer and TCPSocket classes
require "digest/sha1"
require_relative "Client"
require_relative "ConnectionError"

class SocketServer
  attr_reader :port

  def initialize(port, messageHandler = nil)
    @handler = messageHandler
    @server = TCPServer.new("localhost", (@port = port.to_i))
    @clients = []
    @closed = true
  end

  def start
    @closed = false
    Thread.new {
      while !@closed
        socket = @server.accept
        STDERR.puts "Incoming Request"

        if !handleHandshake(socket)
          next
        end

        client = Client.new(socket, @handler)
        @clients << client
        client.listen
      end
    }
    return self
  end

  def close
    @clients.each { |client| client.close }
    @clients.clear
    @closed = true
  end

  def handleHandshake(socket)
    http_request = ""
    while (line = socket.gets) && (line != "\r\n")
      http_request += line
    end

    if matches = http_request.match(/^Sec-WebSocket-Key: (\S+)/)
      websocket_key = matches[1]
      STDERR.puts "Websocket handshake detected with key: #{websocket_key}"
    else
      STDERR.puts "Aborting non-websocket connection"
      socket.close
      return false
    end

    response_key = Digest::SHA1.base64digest([websocket_key, "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"].join)
    STDERR.puts "Responding to handshake with key: #{response_key}"

    socket.write <<-eos
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: #{response_key}

eos
    return true
  end
end
