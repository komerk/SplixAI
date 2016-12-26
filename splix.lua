----------------------------------------
-- script-name: dns_dissector.lua
--
-- author: Hadriel Kaplan <hadrielk at yahoo dot com>
-- Copyright (c) 2014, Hadriel Kaplan
-- This code is in the Public Domain, or the BSD (3 clause) license if Public Domain does not apply
-- in your country.
--
-- Version: 2.1
--
-- Changes since 2.0:
--   * fixed a bug with default settings
--   * added ability for command-line to overide defaults
--
-- Changes since 1.0:
--   * made it use the new ProtoExpert class model for expert info
--   * add a protocol column with the proto name
--   * added heuristic dissector support
--   * added preferences settings
--   * removed byteArray2String(), and uses the new ByteArray:raw() method instead
--
-- BACKGROUND:
-- This is an example Lua script for a protocol dissector. The purpose of this script is two-fold:
--   * To provide a reference tutorial for others writing Wireshark dissectors in Lua
--   * To test various functions being called in various ways, so this script can be used in the test-suites
-- I've tried to meet both of those goals, but it wasn't easy. No doubt some folks will wonder why some
-- functions are called some way, or differently than previous invocations of the same function. I'm trying to
-- to show both that it can be done numerous ways, but also I'm trying to test those numerous ways, and my more
-- immediate need is for test coverage rather than tutorial guide. (the Lua API is sorely lacking in test scripts)
--
-- OVERVIEW:
-- This script creates an elementary dissector for DNS. It's neither comprehensive nor error-free with regards
-- to the DNS protocol. That's OK. The goal isn't to fully dissect DNS properly - Wireshark already has a good
-- DNS dissector built-in. We don't need another one. We also have other example Lua scripts, but I don't think
-- they do a good job of explaining things, and the nice thing about this one is getting capture files to
-- run it against is trivial. (plus I uploaded one)
--
-- HOW TO RUN THIS SCRIPT:
-- Wireshark and Tshark support multiple ways of loading Lua scripts: through a dofile() call in init.lua,
-- through the file being in either the global or personal plugins directories, or via the command line.
-- See the Wireshark USer's Guide chapter on Lua (http://www.wireshark.org/docs/wsug_html_chunked/wsluarm.html).
-- Once the script is loaded, it creates a new protocol named "MyDNS" (or "MYDNS" in some places).  If you have
-- a capture file with DNS packets in it, simply select one in the Packet List pane, right-click on it, and
-- select "Decode As ...", and then in the dialog box that shows up scroll down the list of protocols to one
-- called "MYDNS", select that and click the "ok" or "apply" button.  Voila`, you're now decoding DNS packets
-- using the simplistic dissector in this script.  Another way is to download the capture file made for
-- this script, and open that - since the DNS packets in it use UDP port 65333 (instead of the default 53),
-- and since the MyDNS protocol in this script has been set to automatically decode UDP port 65333, it will
-- automagically do it without doing "Decode As ...".
--
----------------------------------------
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
	oSubtree:add(oTvbData(17, 1), string.format("Dead type: %d", oTvbData(17, 1):uint()))
	oSubtree:add(oTvbData(18), string.format("Killed by: %s", oTvbData(18):string()))
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
						  [3]={'FILL_AREA', stub},
						  [4]={'SET_TRAIL', stub},
						  [5]={'PLAYER_DIE', stub},
						  [6]={'CHUNK_OF_BLOCKS', stub},
						  [7]={'REMOVE_PLAYER', server_7},
						  [8]={'PLAYER_NAME', server_8},
						  [9]={'MY_SCORE', server_9},
						  [10]={'MY_RANK', server_10},
						  [11]={'LEADERBOARD', server_11},
						  [12]={'MAP_SIZE', server_12},
						  [13]={'YOU_DED', server_13},
						  [14]={'MINIMAP', stub},
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
	oPinfo.cols.info = sCommand
	local oSubtree = oTreeItemRoot:add(oProtoSPLIX, oTvbData(), 'splix Protocol data')
	oSubtree:add(oTvbData(0, 1), string.format('Command: %d (%s)', uiCommand, sCommand))
	
	tFunctions[side][uiCommand][2](oTvbData, oPinfo, oTreeItemRoot, oSubtree)
	
	return oTvbData:len()
end

register_postdissector(oProtoSPLIX)
