local _, class = UnitClass('player')
local classColourTable = RAID_CLASS_COLORS[class]
local colour = classColourTable.colorStr
local dBefore, hBefore, tBefore

local frame = CreateFrame('Frame')
frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('PLAYER_REGEN_ENABLED')
frame:RegisterEvent('PLAYER_REGEN_DISABLED')

-- credit to Richard Warburton (http://richard.warburton.it)
-- via http://lua-users.org/wiki/FormattingNumbers
local function prettifyNumber (n)
  n = math.floor(n + 0.5)
  local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
  return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

local function combatStarted ()
  dBefore = GetStatistic(197)
  hBefore = GetStatistic(198)
  tBefore = GetTime()
end

local function combatFinished ()
  local dAfter = GetStatistic(197)
  local hAfter = GetStatistic(198)
  local tAfter = GetTime()

  local damage = dAfter - dBefore
  local healing = hAfter - hBefore

  if damage == 0 and healing == 0 then return end -- don't report random mob aggro
  local time = tAfter - tBefore

  local dps = damage / time
  local hps = healing / time

  print('meep: |c' .. colour .. prettifyNumber(dps) .. '|r DPS |c' .. colour .. prettifyNumber(hps) .. '|r HPS')
end

local eventHandlers = {
  ADDON_LOADED = function (addon)
    if addon ~= 'meep' then return end

    print('|c' .. colour .. 'meep|r loaded!')
  end,

  PLAYER_REGEN_DISABLED = combatStarted,
  PLAYER_REGEN_ENABLED = combatFinished
}

frame:SetScript('OnEvent', function (self, event, ...)
  eventHandlers[event](...)
end)
