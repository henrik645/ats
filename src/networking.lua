local settingsFilePath = "networkSettings"
os.loadAPI("apis/logging.lua")

function initialise() -- initialises the settings file
    if fs.exists(settingsFilePath) then
        settingsFile = fs.open(settingsFilePath)
        settings = textutils.unserialize(fs.readAll()) -- takes care of the serialized settings file
        fs.close(settingsFile)
    else
        logging.error("networking: could not find settings file")
    end
end

function sendMessage(modem, recipient, port, replyPort, data) -- sends a message on the network
    modem.transmit(port, replyPort, {
        recipient = recipient,
        port = port,
        replyPort = replyPort,
        data = data
    }
    )
end

function receiveMessage(modem, port, timeout) -- takes care of receiving a message
    modem.open(port)
    local timer = os.startTimer(timeout)
    local event, _, _, _, data, _ = os.pullEvent()
    
    if event == "timer" then
        return
    elseif event == "modem_message" then
        handleMessage(data)
    end
    os.cancelTimer(timer) -- makes sure the timer isn't running in the background
end

function handleMessage(message) -- handles a message if you want to catch it yourself
    if message.recipient == settings.nodeName then
        return message.data
    else
        return false
    end
end