local _, class = UnitClass("player")
local colour1 = RAID_CLASS_COLORS[class]-- or {colorStr = "F788D2"}
local dBefore, dAfter, hBefore, hAfter, tBefore, tAfter;

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")

local function prettifyNumber(n) 
  n = math.floor(n+0.5) -- round to nearest whole number
-- credit to Richard Warburton (http://richard.warburton.it)
-- via http://lua-users.org/wiki/FormattingNumbers
  local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
  return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

local function combatStarted()
  dBefore = GetStatistic(197)
  hBefore = GetStatistic(198)
  tBefore = GetTime()
end

local function combatFinished()
  dAfter = GetStatistic(197)
  hAfter = GetStatistic(198)
  tAfter = GetTime()
  local damage = dAfter - dBefore
  local healing = hAfter - hBefore
  if damage == 0 and healing == 0 then return end -- don't report random mob aggro
  local time = tAfter - tBefore
  local dps = damage / time
  local hps = healing / time
  print("meep: |c"..colour1.colorStr..prettifyNumber(dps).."|r DPS |c"..colour1.colorStr..prettifyNumber(hps).."|r HPS")
end

local function eventHandler(self, event, ...)
  if event == "ADDON_LOADED" then
    if ... == "meep" then
      print("|c"..colour1.colorStr.."meep|r loaded!")
    end
  elseif event == "PLAYER_REGEN_DISABLED" then
    combatStarted()
  else
    combatFinished()
  end
end

frame:SetScript("OnEvent", eventHandler)