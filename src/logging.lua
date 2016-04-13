function info(message)
    print("[INFO] " .. message)
end

function warning(message)
    print("[WARNING] " .. message)
end

function error(message)
    print("[ERROR] " .. message)
    error("Exiting program...")
end