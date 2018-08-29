// I hate world glow. Lets remove it :)

local entity = FindMetaTable("Entity")
oldWorldGlow = oldWorldGlow or entity.SetRenderMode

function entity:SetRenderMode(renderMode)

	if table.HasValue({3,9}, renderMode) then renderMode = 0 end
	
	oldWorldGlow(self, renderMode)

end
