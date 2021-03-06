--- CFrameInstance
--

local t = require(script.Parent.t)
local ObjectValueUtil = require(script.Parent.ObjectValueUtil)
local IsModelWithPrimaryPart = require(script.Parent.IsModelWithPrimaryPart)


local CFrameInstance = {}

local isValidCFrameInstance = t.union(
	t.instanceIsA("CFrameValue"),
	t.instanceIsA("Vector3Value"),
	t.instanceIsA("BasePart"),
	t.instanceIsA("Attachment"),
	IsModelWithPrimaryPart
)

CFrameInstance.Check = function(value)
	local instanceSuccess, instanceErrMsg = t.Instance(value)
	if not instanceSuccess then
		return false, instanceErrMsg or ""
	end

	local _value, reduceObjectMessage = ObjectValueUtil.Reduce(value)
	if _value == false then
		return false, reduceObjectMessage
	end
	value = _value

	return isValidCFrameInstance(value)
end


CFrameInstance.Get = function(instance)
	if instance:IsA("ObjectValue") then
		instance = instance.Value
	end

    if instance:IsA("CFrameValue") then
        return instance.Value
    elseif instance:IsA("Vector3Value") then
        return CFrame.new(instance.Value)
    elseif instance:IsA("BasePart") then
        return instance.CFrame
	elseif instance:IsA("Attachment") then
		return instance.WorldCFrame
	elseif instance:IsA("Model") then
		return instance:GetPrimaryPartCFrame()
    end

    return nil, "Unable to get CFrame from Object!"
end


CFrameInstance.CheckAndGet = function(value)
	local success, message
		= CFrameInstance.Check(value)
	if success == false then
		return false, message
	end

	return CFrameInstance.Get(value)
end


return CFrameInstance