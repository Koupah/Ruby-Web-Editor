class ConnectionError < StandardError

    def initialize(message = nil) 
        super message == nil ? "Connection Error!" : message;
    end

    # I am java dev, I am used to throwing errors. We shall throw.
    def ConnectionError.throw(message = nil)
        return self.new message;
    end

end