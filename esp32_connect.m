function tcp_obj = esp32_connect(ip)
    port = 80; %1883
    try
        tcp_obj = tcpclient(ip, port);
    catch
        disp('ERROR: Could not connect to Robotat server.');
    end
end