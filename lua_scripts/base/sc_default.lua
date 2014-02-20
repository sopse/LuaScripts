﻿--
-- Cooldown Methods by Foereaper
--
-- player:SetLuaCooldown(seconds[, opt_id]) -- Sets the cooldown timer to X seconds, optionally a specific cooldown ID can be set. Default ID: 1
-- player:GetLuaCooldown([opt_id])          -- Returns cooldown or 0 if none, default cooldown checked is ID 1, unless other is specified.
--

local cooldowns = {};

function Player:SetLuaCooldown(seconds, opt_id)
    assert(type(self) == "userdata");
    seconds = assert(tonumber(seconds));
    opt_id = opt_id or 1;
    local guid, source = self:GetGUIDLow(), debug.getinfo(2, 'S').short_src;

    if (not cooldowns[guid]) then
        cooldowns[guid] = { [source] = {}; };
    end

    cooldowns[guid][source][opt_id] = os.clock() + seconds;
end
 
function Player:GetLuaCooldown(opt_id)
    assert(type(self) == "userdata");
    local guid, source = self:GetGUIDLow(), debug.getinfo(2, 'S').short_src;
    opt_id = opt_id or 1;

    if (not cooldowns[guid]) then
        cooldowns[guid] = { [source] = {}; };
    end

    local cd = cooldowns[guid][source][opt_id];
    if (not cd or cd < os.clock()) then
        cooldowns[guid][source][opt_id] = 0
        return 0;
    else
        return cooldowns[guid][source][opt_id] - os.clock();
    end
end

--
-- GossipSetText Methods by Rochet2
--
-- player:GossipMenuAddItem(0, "Text", 0, 0)
-- player:GossipMenuAddItem(0, "Text", 0, 0)
-- player:GossipSetText("Text")
-- player:GossipSendMenu(0x7FFFFFFF, creature)
--

local SMSG_NPC_TEXT_UPDATE = 384
local MAX_GOSSIP_TEXT_OPTIONS = 8

function Player:GossipSetText(text)
    data = CreatePacket(SMSG_NPC_TEXT_UPDATE, 100);
    data:WriteULong(0x7FFFFFFF)
    for i = 1, MAX_GOSSIP_TEXT_OPTIONS do
        data:WriteFloat(0)     -- Probability
        data:WriteString(text) -- Text
        data:WriteString(text) -- Text
        data:WriteULong(0)     -- language
        data:WriteULong(0)     -- emote
        data:WriteULong(0)     -- emote
        data:WriteULong(0)     -- emote
        data:WriteULong(0)     -- emote
        data:WriteULong(0)     -- emote
        data:WriteULong(0)     -- emote
    end
    self:SendPacketToPlayer(data)
end