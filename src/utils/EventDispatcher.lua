local EventDispatcher = {};

-- 此模块用以为一个对象（表）添加消息分发的功能。
local wt = {__mode = "k"};

-- 单个event的监听者列表
function EventDispatcher:getEventListeners(event)
	local el = self.listeners[event];
	if el==nil then
		el = {};						-- [listener] = "onEventXXX"
		setmetatable(el, wt);			-- 键（listener）为弱引用；这样不调用removeEventListener也不会内存泄漏
		self.listeners[event] = el;
	end
	return el;
end;

-- 将对象与回调函数名添加为某事件的监听者
function EventDispatcher:addEventListener(event, listener, callbackname)
	local lns = self:getEventListeners(event);
	lns[listener] = callbackname;
end;

-- 移除监听
function EventDispatcher:removeEventListener(event, listener)
	local lns = self:getEventListeners(event);
	lns[listener] = nil;
end;

-- 发布事件；所有监听了此事件的对象都会被调用其添加事件监听时所传递的函数名。
function EventDispatcher:dispatchEvent(event, data)
	local lns = self:getEventListeners(event);
	local temp = {};
	for k,v in pairs(lns) do
		temp[k] = v;
	end
	for k,v in pairs(temp) do
		local func = k[v];
		if func~=nil then
			func(k, event, data)
		else
			-- 直接忽略掉忘记调用removeEventListener的对象。
			lns[k] = nil;
		end
	end
end;

-- 调用此函数以为一个对象添加事件发布的功能。
function EventDispatcher:subclass(t)
	t.listeners = {};
	for k,v in pairs(EventDispatcher) do
		t[k] = v;
	end
end

return EventDispatcher;
