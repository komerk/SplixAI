local function NilToQuestionMark(value)
	if value == nil then
		return '?'
	else
		return value
	end
end

oProtoSPLIX = Proto('splix', 'splix Protocol')
oWebsocketMask = Field.new("websocket.mask")
oWebsocketPayload = Field.new("websocket.payload")

function stub(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
end
						  
function client_1(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 1), string.format('Direction: %d', oTvbData(1, 1):uint()))
	oSubtree:add(oTvbData(2, 2), string.format('X Coordinate: %d', oTvbData(2, 2):uint()))
	oSubtree:add(oTvbData(4, 2), string.format('Y Coordinate: %d', oTvbData(4, 2):uint()))
end

function client_2(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1), string.format('Username: %s', oTvbData(1):string()))
end

function client_3(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 1), string.format("Color: %d", oTvbData(1, 1):uint()))
	oSubtree:add(oTvbData(2, 1), string.format("Pattern: %d", oTvbData(2, 1):uint()))
end

function client_6(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 1), string.format("Size: %d", oTvbData(1, 1):uint()))
end

function server_2(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 2), string.format("X: %d", oTvbData(1, 2):uint()))
	oSubtree:add(oTvbData(3, 2), string.format("Y: %d", oTvbData(3, 2):uint()))
	oSubtree:add(oTvbData(5, 2), string.format("ID: %d", oTvbData(5, 2):uint()))
end

function server_3(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 2), string.format("X: %d", oTvbData(1, 2):uint()))
	oSubtree:add(oTvbData(3, 2), string.format("Y: %d", oTvbData(3, 2):uint()))
	oSubtree:add(oTvbData(5, 2), string.format("Width: %d", oTvbData(5, 2):uint()))
	oSubtree:add(oTvbData(7, 2), string.format("Height: %d", oTvbData(7, 2):uint()))
	oSubtree:add(oTvbData(9, 1), string.format("Color: %d", oTvbData(9, 1):uint()))
	oSubtree:add(oTvbData(10, 1), string.format("Pattern: %d", oTvbData(10, 1):uint()))
end

function server_4(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 2), string.format("ID: %d", oTvbData(1, 2):uint()))
	for i=3,oTvbData:len()-3,4
	do
		oSubtree:add(oTvbData(i, 2), string.format("X[%d]: %d", i/4, oTvbData(i, 2):uint()))
		local j = i + 2
		oSubtree:add(oTvbData(j, 2), string.format("Y[%d]: %d", i/4, oTvbData(j, 2):uint()))
	end
end

function server_5(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 2), string.format("ID: %d", oTvbData(1, 2):uint()))
	if oTvbData():len() < 7 then
		return
	end
	
	oSubtree:add(oTvbData(3, 2), string.format("X: %d", oTvbData(3, 2):uint()))
	oSubtree:add(oTvbData(5, 2), string.format("Y: %d", oTvbData(5, 2):uint()))
end

local tColors = {[-1]="none",[0]='red',[1]='red2',[2]='pink',[3]='pink2',[4]='purple',[5]='blue',[6]='blue2',[7]='green',[8]='green2',[9]='leaf',[10]='yellow',[11]='orange',[12]='gold'}
local colors_count = 13
function server_6(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	local x = oTvbData(1, 2):uint()
	local y = oTvbData(3, 2):uint()
	local width = oTvbData(5, 2):uint()
	oSubtree:add(oTvbData(1, 2), string.format("X: %d", x))
	oSubtree:add(oTvbData(3, 2), string.format("Y: %d", y))
	oSubtree:add(oTvbData(5, 2), string.format("Width: %d", width))
	oSubtree:add(oTvbData(7, 2), string.format("Height: %d", oTvbData(7, 2):uint()))
	for i = 9,oTvbData():len()-1,1
	do
		oSubtree:add(oTvbData(i, 1), string.format("Color [%d, %d]: %s", x + ((i - 9) % width), y + ((i - 9) / width), tColors[(oTvbData(i, 1):uint() - 2) % colors_count]))
	end
end

function server_7(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 2), string.format("ID: %d", oTvbData(1, 2):uint()))
end

function server_8(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 2), string.format("ID: %d", oTvbData(1, 2):uint()))
	oSubtree:add(oTvbData(3), string.format("Username: %d", oTvbData(3):string()))
end

function server_9(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 4), string.format("Score: %d", oTvbData(1, 4):uint()))
	oSubtree:add(oTvbData(5, 2), string.format("Kills: %d", oTvbData(5, 2):uint()))
end

function server_10(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 2), string.format("Rank: %d", oTvbData(1, 2):uint()))
end

function server_11(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 2), string.format("Players count: %d", oTvbData(1, 2):uint()))
	-- TODO: Parse the rest of the packet
end

function server_12(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 2), string.format("Map size: %d", oTvbData(1, 2):uint()))
end

function server_13(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 4), string.format("Blocks count: %d", oTvbData(1, 4):uint()))
	oSubtree:add(oTvbData(5, 2), string.format("Kills count: %d", oTvbData(5, 2):uint()))
	oSubtree:add(oTvbData(7, 2), string.format("Rank: %d", oTvbData(5, 2):uint()))
	oSubtree:add(oTvbData(9, 4), string.format("Time lived (in second): %d", oTvbData(9, 4):uint()))
	oSubtree:add(oTvbData(13, 4), string.format("Time ranked #1(in second): %d", oTvbData(13, 4):uint()))
	oSubtree:add(oTvbData(17, 1), string.format("Death type: %d", oTvbData(17, 1):uint()))
	oSubtree:add(oTvbData(18), string.format("Killed by: %s", oTvbData(18):string()))
end

function server_14(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	initial_x_chunk = oTvbData(1, 1):uint() * 20
	oSubtree:add(oTvbData(1, 1), string.format("Initial x chunk: %d", initial_x_chunk))
	
	
	for i = 2,oTvbData():len()-1,1
	do
		local n = i - 2
		for bit=0,7,1
		do
			local chunk_seq_number = 8 * n + bit
			
			local x_chunk = initial_x_chunk + (chunk_seq_number / 80) % 80
			local y_chunk = chunk_seq_number % 80
			local x_block = x_chunk * 7.5
			local y_block = y_chunk * 7.5
			
			local temp = oTvbData(i, 1):uint()
			temp = bit32.rshift(temp, bit)
			temp = bit32.band(temp, 1)
			oSubtree:add(oTvbData(i, 1), string.format("Block [%d, %d]: %d", x_block, y_block, temp))
		end
	end
end

function server_15(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 2), string.format("ID: %d", oTvbData(1, 2):uint()))
	oSubtree:add(oTvbData(3, 1), string.format("Color: %d", oTvbData(3, 1):uint()))
	oSubtree:add(oTvbData(4, 1), string.format("Pattern: %d", oTvbData(4, 1):uint()))
end

function server_20(oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	oSubtree:add(oTvbData(1, 1), string.format("Honk size: %d", oTvbData(1, 1):uint()))
end
	
tFunctions = {["client"]={[1]={'UPDATE_DIR', client_1},
						  [2]={'SET_USERNAME', client_2},
						  [3]={'SKIN', client_3},
						  [4]={'READY', stub},
						  [5]={'REQUEST_CLOSE', stub},
						  [6]={'HONK', client_6},
						  [7]={'PING', stub},
						  [8]={'REQUEST_MY_TRAIL',stub}},
						  
			  ["server"]={[1]={'UPDATE_BLOCKS', stub},
						  [2]={'PLAYER_POS', server_2},
						  [3]={'FILL_AREA', server_3},
						  [4]={'SET_TRAIL', server_4},
						  [5]={'PLAYER_DIE', server_5},
						  [6]={'CHUNK_OF_BLOCKS', server_6},
						  [7]={'REMOVE_PLAYER', server_7},
						  [8]={'PLAYER_NAME', server_8},
						  [9]={'MY_SCORE', server_9},
						  [10]={'MY_RANK', server_10},
						  [11]={'LEADERBOARD', server_11},
						  [12]={'MAP_SIZE', server_12},
						  [13]={'YOU_DED', server_13},
						  [14]={'MINIMAP', server_14},
						  [15]={'PLAYER_SKIN', server_15},
						  [16]={'EMPTY_TRAIL_WITH_LAST_POS', stub},
						  [17]={'READY', stub},
						  [18]={'PLAYER_HIT_LINE', stub},
						  [19]={'REFRESH_AFTER_DIE', stub},
						  [20]={'PLAYER_HONK', server_20},
						  [21]={'PONG', stub}}}

function oProtoSPLIX.dissector(oTvbData, oPinfo, oTreeItemRoot)
	
	oTvbData = ByteArray.tvb(oWebsocketPayload().range:bytes(), "Splix")
	
	if oTvbData:len() < 1 then
		return
	end
	
	local uiCommand = oTvbData(0, 1):uint()

	local side = ""
	if oWebsocketMask().value then
		side = "client"
	else
		side = "server"
	end

	local sCommand = NilToQuestionMark(tFunctions[side][uiCommand][1])
	
	oPinfo.cols.protocol = 'splix'
	oPinfo.cols.info = sCommand .. string.format("(%s)", side)
	local oSubtree = oTreeItemRoot:add(oProtoSPLIX, oTvbData(), 'splix Protocol data')
	oSubtree:add(oTvbData(0, 1), string.format('Command: %d (%s)', uiCommand, sCommand))
	
	tFunctions[side][uiCommand][2](oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	
	return oTvbData:len()
end

register_postdissector(oProtoSPLIX)
