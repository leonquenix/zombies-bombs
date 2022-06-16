-- Escuta os botões pressionados pelo jogador e então executa uma ação
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local dropBombRemoteEvent = game:GetService("ReplicatedStorage").DropBomb

-- Constant
local ACTION_KEY = Enum.KeyCode.F
local GAMEPAD_ACTION_KEY = Enum.KeyCode.ButtonR1
local CONTEXT = "DropBomb"

local function isDropBombAllowed()
	local bombsQuantity = #workspace.SpawnedBombs:GetChildren()
	if bombsQuantity > 0 then
		return false
	end
	
	return true
end


local function dropBomb()
	if not isDropBombAllowed() then
		return
	end
	
	dropBombRemoteEvent:FireServer()
end

local function handleDropBombInput(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		dropBomb()
	end
end

ContextActionService:BindAction(CONTEXT, handleDropBombInput, true, ACTION_KEY, GAMEPAD_ACTION_KEY)
ContextActionService:SetPosition(CONTEXT, UDim2.new(1, -70, 0, 10))
ContextActionService:SetTitle(CONTEXT, "Bomb!")