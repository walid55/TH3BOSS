--[[ 
▀▄ ▄▀▀▄▄▀▀▄▄▀▀▄▄▀▀▄▄▀▀▄▄▀▀▄▄▀▀▄▀▄▄▀▀▄▄▀▀▄▄▀▀▄▄▀▀          
▀▄ ▄▀                                      ▀▄ ▄▀ 
▀▄ ▄▀    BY MOHAMMED HISHAM                ▀▄ ▄▀ 
▀▄ ▄▀   BY MOHAMMEDHISHAM (@TH3BOSS)      ▀▄ ▄▀ 
▀▄ ▄▀ JUST WRITED BY MOHAMMED HISHAM       ▀▄ ▄▀   
▀▄ ▄▀      ANTI BOT   : منع بوتات            ▀▄ ▄▀ 
▀▄▀▀▄▄▀▀▄▄▀▄▄▀▀▄▄▀▀▄▄▀▄▄▀▀▄▄▀▀▄▄▀▄▄▀▀▄▄▀▀▄▄▀▄▄▀▀
--]]
local function isAntiBotEnabled (chatId)
  local hash = 'bot:lock:'..chatId
  local lock = redis:get(hash)
  return lock
end
local function enableAntiBot (chatId)
local hash = 'bot:lock:'..chatId
redis:set(hash, true)
end
local function disableAntiBot (chatId)
local hash = 'bot:lock:'..chatId
redis:del(hash)
end
local function isABot (user)
  local binFlagIsBot = 4096
  local result = bit32.band(user.flags, binFlagIsBot)
  return result == binFlagIsBot
end

local function isABotBadWay (user)
  local username = user.username or ''
  return username:match("[Bb]ot$")
end
local function kickUser(userId, chatId)
local channel = 'channel#id'..chatId
local user = 'user#id'..userId
  channel_kick_user(channel, user, function (data, success, result)
    if success ~= 1 then
      print('I can\'t kick '..data.user..' but should be kicked')
    end
  end, {chat=chat, user=user})
end

local function mohammed (msg, matches)

  if matches[1] ~= 'chat_add_user' and matches[1] ~= 'chat_add_user_link' then
    if msg.to.type ~= 'chat' and msg.to.type ~= 'channel' then
      return nil
    end
  end

  local chatId = msg.to.id
  if matches[1] == 'lock bots' then
    enableAntiBot(chatId)
  return 'Bots has ☑️ been locked 🔒😽'
  end
  if matches[1] == 'open bots' then
    disableAntiBot(chatId)
  return 'Bots has ☑️ been unlocked 🔓😽'
  if matches[1] == 'chat_add_user' or matches[1] == 'chat_add_user_link' then
    local user = msg.action.user or msg.from
    if isABotBadWay(user) then
      print("It' a bot!")
      if isAntiBotEnabled(chatId) then
        print('bot is locked')
        local userId = user.id
        if not isBotAllowed(userId, chatId) then
          kickUser(userId, chatId)
        else
          print('')
        end
      end
    
  end
end

return {
  description = 'Anti bot create by Mustafa ip',
  usage = {
    '/bot lock: locked add bots to supergroup',
    '/bot unlock: unlock add bots to supergroup'
  },
  patterns = {
    '^(lock bots)$',
    '^(open bots)$',end
    '^!!tgservice (chat_add_user)$',
    '^!!tgservice (chat_add_user_link)$'
  },
  run = mohammed
}
