local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local AssetsFldr = ReplicatedStorage.Assets
local AnimationFldr = AssetsFldr.Animations

local AnimationHandler = {}

local LoadedAnimationInstances = {}

function AnimationHandler.LoadAnimationInstances(ids)
	for _, id in ids do
		local AnimIns = Instance.new("Animation")

		AnimIns.AnimationId = id

		AnimIns.Parent = AnimationFldr

		ContentProvider:PreloadAsync({ AnimIns })

		LoadedAnimationInstances[id] = AnimIns
	end
end

function AnimationHandler.PlayAnimation(Rig, Id, Looped)
	local Humanoid = Rig:FindFirstChild("Humanoid")

	local Animator: Animator = Humanoid:FindFirstChild("Animator")

	local AnimationInstance = LoadedAnimationInstances[Id]

	if not AnimationInstance then
		warn("couldn't find animation instance for animation id, " .. tostring(Id))
		return
	end

	local Animation = Animator:LoadAnimation(AnimationInstance)

	Animation.Looped = Looped

	Animation:Play()
end

function AnimationHandler.EndAllAnimations(Rig)
	local Humanoid = Rig:FindFirstChild("Humanoid")

	local Animator: Animator = Humanoid:FindFirstChild("Animator")
	print("ending all animations")
	for _, track in pairs(Animator:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

return AnimationHandler
