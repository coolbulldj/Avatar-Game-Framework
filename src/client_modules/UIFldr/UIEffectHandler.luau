local TweenService = game:GetService("TweenService")

local UIEffects = {}

function UIEffects.MoveFrame(frame, EndPosition, TweenTime, yield)
	local Tween = TweenService:Create(frame, TweenInfo.new(TweenTime or 0.5), { Position = EndPosition })

	Tween:Play()

	if not yield then
		task.spawn(function()
			Tween.Completed:Wait()
			Tween:Destroy()
		end)
		return
	end

	Tween.Completed:Wait()
	Tween:Destroy()
end

return UIEffects
