local EventDispatcher = require "utils.EventDispatcher"

local sproto = require "sproto.sproto"
local sprotoparser = require "sproto.sprotoparser"

local function walk(config)
	local res = ""
	for k,v in ipairs(config) do
		res = res .. cc.FileUtils:getInstance():getStringFromFile(v).."\n"
	end
	return res
end

local GameClient = {
	proto = {
	    c2s = sprotoparser.parse(walk({
			"headers/c2s.sproto",
		})),
	    s2c = sprotoparser.parse(walk({
			"headers/s2c.sproto",
		}))
	},

	EVENT_CONNECTED = "EVENT_CONNECTED";
	EVENT_CONNECT_FAILED = "EVENT_CONNECT_FAILED";		-- 事件：连接失败
	EVENT_TRYING_NEXT_ADDR = "EVENT_TRYING_NEXT_ADDR";	-- 事件：连接失败，重连中
	EVENT_DISCONNECTED = "EVENT_DISCONNECTED";			-- 事件：断开连接，数据为disconnectByClient
	EVENT_PACKET = "EVENT_PACKET";						-- 事件：有网络数据包，数据为name, args
};

GameClient.host = sproto.new(GameClient.proto.s2c):host "package"
GameClient.request = GameClient.host:attach(sproto.new(GameClient.proto.c2s))

function GameClient:init()
	EventDispatcher:subclass(self)
	self.session = 0;
end

-- 连接时需要传入用户授权userAuth = {account="abc", pwd="123"}以完成登录过程。
function GameClient:connect(addr, port)
	if self.socket~=nil then
		print("calling skt:removeFromParent")
		self.socket:removeFromParent();
		self.socket = nil;
	end
    self.pendingResponses = {};

	local this = self;
	self.socket = lk.SocketNode:create(addr, port, function (eventType, data)
		if eventType=="packet" then
			this:onPacket(data);
		elseif eventType=="connected" then
			print("connected");
			this:onConnected();
		elseif eventType=="connectfailed" then
			print("connectfailed: "..tostring(data));
			this.socket = nil;
			this:onConnectFailed(data);
		elseif eventType=="disconnected" then
			print("disconnected: "..tostring(data));
			this.socket = nil;
			this:onDisconnected(data);
		end
	end);
	cc.Director:getInstance():getRunningScene():addChild(self.socket);
end

function GameClient:sendData(name, args)
	if self.socket==nil then
		return false;
	end
    self.session = self.session + 1
    local data, hasResponse = self.request(name, args, self.session)
    if hasResponse then
    	self.pendingResponses[self.session] = name;
    end

    self.socket:sendData(data, #data);
    print("GameClient:sendData:", name, self.session)
    return true;
end

-- sendRequest与sendData的不同之处在于，sendRequest通过回调函数获取服务器的RESPONCE，而不会通过EVENT_PACKET分发RESPONCE。
function GameClient:sendRequest(name, args, callback)
	if self.socket==nil then
		return false;
	end
    self.session = self.session + 1
    local data, hasResponse = self.request(name, args, self.session)
    if hasResponse then
    	self.pendingResponses[self.session] = callback;
    end

    self.socket:sendData(data, #data);
    print("GameClient:sendData:", name, self.session)
    return true;
end

-- 原样发送数据包。
function GameClient:sendRawData(data, size)
	if self.socket==nil then
		return false;
	end
	self.socket:sendData(data, size);
    return true;
end

function GameClient:dispatchPacket(t, name, args, session)
	local proc = t[name];
	if proc~=nil then
		proc(t, args, session);
	end
end

function GameClient:onPacket(data)
	local t, name, args = self.host:dispatch(data);
	local session = nil;
	if t=="RESPONSE" then
		local sname = self.pendingResponses[name];
		if sname~=nil then
			self.pendingResponses[name] = nil;
			if type(sname)=="string" then
				session = name;
				name = sname;
			else
				-- sname为回调函数
				sname(args);
				return ;
			end
		end
	end
    print("GameClient:onPacket", t, name)
    if args~=nil then
    	printtable(args)
    end
	-- 固定的Managers先监听消息。
    self:dispatchPacket(self, name, args, session);

    self:dispatchEvent(self.EVENT_PACKET, {name = name, args = args, session = session});
end

-- 添加为PacketListener之后，会自动查找t[name]来处理网络消息。
function GameClient:addPacketListener(t)
	function t:onPacket(event, data)
		local proc = self[data.name];
		if proc~=nil then
			proc(self, data.args, data.session);
		end
	end;
	self:addEventListener(self.EVENT_PACKET, t, "onPacket");
end

function GameClient:onConnected()
    self:dispatchEvent(self.EVENT_CONNECTED);
    print("GameClient:onConnected")
end

function GameClient:onConnectFailed(data)
    print("GameClient:onConnectFailed", data)
	local logonAddr = distConfig.logonAddr;
	if type(logonAddr)=="table" and self.curLogonAddrIdx~=nil and self.curLogonAddrIdx<(#logonAddr-1) then
		-- 尝试下一个连接地址。
    	self:dispatchEvent(self.EVENT_TRYING_NEXT_ADDR);
    	local this = self;
    	cc.Director:getInstance():getRunningScene():runAction(cc.Sequence:create({
    		cc.DelayTime:create(0.001),
    		cc.CallFunc:create(function()
    			this:connect();
    		end)
    	}));
	else
		-- 连接失败
    	self:dispatchEvent(self.EVENT_CONNECT_FAILED);
	end
end

function GameClient:onDisconnected(data)
    self:dispatchEvent(self.EVENT_DISCONNECTED);
    print("GameClient:onDisconnected", data)
end

function GameClient:getInstance()
	if self.singleton==nil then
		self.singleton = {};
		for k,v in pairs(GameClient) do
			self.singleton[k] = v;
		end
		self.singleton:init();
	end
	return self.singleton;
end

return GameClient
