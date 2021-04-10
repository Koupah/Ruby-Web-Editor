require_relative "../network/SocketServer"

class ConfigApplier
  def ConfigApplier.start(display)
    defaultBox(display, "Ruby Web Editor - Config Applier")

    configs = getAllConfigs()
    configs << "Return (None)"

    toApply = display.getScrollableSelectionInput("Which Config would you like to use?", configs)

    # Return if they select 'return'
    return if toApply == "Return (None)"

    config = Config.new(toApply)
    if !config.load(display)
      display.popup("Failed to apply that config!\nIt may be corrupted?")
      return
    end

    server = SocketServer.new(3369, config)
    server.start

    while server.clients.length == 0
      case display.getSelectionInput("Waiting for connection...\nRefresh to check for connection\nReturn if you wish to cancel", [{ text: "Refresh", value: 1 }, { text: "Cancel", value: 2 }])
      when 1
        next # just iterate to next loop of while
      when 2
        server.close
        return
      end
    end

    server.close

    display.popup("Successfully connected!\nYour config has been applied.")
  end
end
