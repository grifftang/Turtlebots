--Main Receiver
function run(messageType)
	while true do
		id, msg = rednet.receive(messageType)

		adminId, adminMsg = rednet.receive("Admin")
		if adminMsg ~= "" then
			splitAdminMsg = split(adminMsg)
			--admin processing
		end
	end
end

function split(str)
        local inputs={}
        for s in string.gmatch(str, "([^"..";".."]+)") do
                table.insert(inputs, s)
        end
        return inputs
end

