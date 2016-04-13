local settings_file_path = "networkSettings"
os.loadAPI("apis/logging")

function initialise() -- initialises the settings file
    if fs.exists(settings_file_path) then
        settings_file = fs.open(settings_file_path)
        settings = textutils.unserialize(fs.readAll()) -- takes care of the serialized settings file
        fs.close(settings_file)
    else
        logging.error("networking: could not find settings file")
    end
end

function send_message(modem, recipient, port, replyPort, data) -- sends a message on the network
    modem.transmit(port, replyPort, {
        recipient = recipient,
        port = port,
        replyPort = replyPort,
        data = data
    }
    )
end

function receive_message(modem, port, timeout) -- takes care of receiving a message
    modem.open(port)
    local timer = os.startTimer(timeout)
    local event, _, _, _, data, _ = os.pullEvent()
    
    if event == "timer" then
        return
    elseif event == "modem_message" then
        handle_message(data)
    end
    os.cancelTimer(timer) -- makes sure the timer isn't running in the background
end

function handle_message(message) -- handles a message if you want to catch it yourself
    if message.recipient == settings.nodeName then
        return message.data
    else
        return false
    end
end