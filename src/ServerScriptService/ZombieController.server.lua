-- Services
local ServerStorage = game:GetService("ServerStorage")

-- Constants
local ENEMY_POPULATION = 3

-- Members
local enemies:Folder = ServerStorage.Enemies
local zombie:Model = enemies:FindFirstChild("Zombie")
local spawnedEnemies = workspace.SpawnedEnemies

local function spawnZombie()
	-- Clona o zombie
	local zombieCloned = zombie:Clone()

	-- Move o zombie para o workspace
	zombieCloned.Parent = spawnedEnemies
end

-- Adiciona os primeiros inimigos no mundo
for count=1, ENEMY_POPULATION do
	spawnZombie()
end

-- Inicia a tarefa de verificação a cada 1 segundo para controlar a população de inimigos
while true do
	local population = #spawnedEnemies:GetChildren()
	if population < ENEMY_POPULATION then
		print("Spawned")
		spawnZombie()
	end
	
	wait(1)
end
