--[[
Copyright 2009 Quaiche of Dragonblight

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]

local f = CreateFrame("frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
f:RegisterEvent("ADDON_LOADED")

function f:ADDON_LOADED(event, addon)
	if addon:lower() ~= "simplegrouptell" then return end
	LibStub("tekKonfig-AboutPanel").new(nil, "SimpleGroupTell") -- Make first arg nil if no parent config panel
	self:UnregisterEvent("ADDON_LOADED"); self.ADDON_LOADED = nil
end

-- Pre-Hook the ChatFrameEditBox OnTextChanged script to change a /gr into something else
local orig = ChatFrameEditBox:GetScript("OnTextChanged")
local function ChatFrameEditBox_OnTextChanged(self, isUserInput, ...)
	if isUserInput ~= true then return end

	local message = string.match( self:GetText(), "^/gr (.*)" )
	if message then
		local channel = "/s "
		if IsInInstance() then channel = "/bg " end
		if GetNumRaidMembers() > 0 then channel = "/ra " end
		if GetNumPartyMembers() > 0 then channel = "/p " end

		self:SetText(channel..message)
		ChatEdit_ParseText(self, 0)
	end

	if orig then orig(self, isUserInput, ...) end
end
ChatFrameEditBox:SetScript("OnTextChanged", ChatFrameEditBox_OnTextChanged)

-- Including a proper slash handler as well for use with Macros.
SLASH_SIMPLEGROUPTELL1 = "/gr"
SlashCmdList.SIMPLEGROUPTELL = function(msg)
	local channel = "SAY"
	if IsInInstance() then channel = "BATTLEGROUND" end
	if GetNumRaidMembers() > 0 then channel = "RAID" end
	if GetNumPartyMembers() > 0 then channel = "PARTY" end
	SendChatMessage(msg, channel) 
end

