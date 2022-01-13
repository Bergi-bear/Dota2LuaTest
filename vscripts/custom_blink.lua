custom_blink =class({})
function custom_blink:OnSpellStart()
	
	print("hellow world")
	local caster=self:GetCaster()
	local point = self:GetCursorPosition()
	FindClearSpaceForUnit(caster,point,true)
end