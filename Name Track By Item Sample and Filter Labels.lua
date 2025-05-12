function capitalize_words(str)
  return (str:gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
  end))
end

function parse_sample_name(name)
  -- Удалим путь и расширение файла
  name = name:match("([^\\/]+)%.%w+$") or name

  -- Разбиваем по "_"
  local parts = {}
  for part in name:gmatch("[^_]+") do
    table.insert(parts, part)
  end

  local label = parts[1] or ""
  local instrument = ""
  local characteristic = ""

  -- Список известных инструментов
  local known_instruments = {
    -- Drums & Percussion
    "kick", "snare", "rim", "clap", "hats", "hat", "cymbal", "crash", "ride", "tom", "toms",
    "perc", "percussion", "shaker", "conga", "bongo", "timbale", "cowbell", "drums", "drumloop",
  
    -- Bass
    "bass", "sub", "808", "reese", "lowend",
  
    -- Synths & Keys
    "synth", "lead", "pad", "pluck", "arp", "keys", "piano", "epiano", "rhodes", "organ", "bell", "chord", "melody", "melodic", "synthloop",
  
    -- Guitars & Strings
    "guitar", "electric", "acoustic", "pluck", "strum", "riff", "strings", "violin", "cello", "harp",
  
    -- Brass & Wind
    "brass", "trumpet", "trombone", "sax", "saxophone", "flute", "horn",
  
    -- FX & One-Shots
    "fx", "impact", "transition", "sweep", "rise", "drop", "glitch", "noise", "texture", "cinematic", "hit", "boom", "whoosh", "drone",
  
    -- Vocals
    "vocal", "vox", "chant", "phrase", "shout", "adlib", "hook", "acapella", "speech", "choir", "talk", "sing",
  
    -- World & Organic
    "kalimba", "koto", "sitar", "banjo", "dulcimer", "djembe", "tabla", "didgeridoo", "flamenco", "ethnic", "folk", "world",
  
    -- Genre/Usage Specific
    "loop", "one", "oneshot", "top", "beat", "groove", "stem", "sample", "dry", "wet"
  }
  
  -- Ищем инструмент
  for i = 2, #parts do
    for _, keyword in ipairs(known_instruments) do
      if parts[i]:lower():find(keyword) then
        if parts[i+1] and parts[i+1]:match("^[a-z]+$") then
          instrument = parts[i] .. " " .. parts[i+1]
        else
          instrument = parts[i]
        end
        break
      end
    end
    if instrument ~= "" then break end
  end

  -- Характеристика звука (последнее осмысленное слово)
  for i = #parts, 2, -1 do
    if not parts[i]:match("^[A-G]#?b?$") and not tonumber(parts[i]) then
      characteristic = parts[i]
      break
    end
  end

  return capitalize_words(instrument), capitalize_words(characteristic), capitalize_words(label)
end

-- === Основной код ===
reaper.Undo_BeginBlock()

local num_tracks = reaper.CountSelectedTracks(0)
if num_tracks == 0 then
  reaper.ShowMessageBox("Select a Track", "Error", 0)
else
  for i = 0, num_tracks - 1 do
    local track = reaper.GetSelectedTrack(0, i)
    local item = reaper.GetTrackMediaItem(track, 0)
    if item then
      local take = reaper.GetActiveTake(item)
      if take and not reaper.TakeIsMIDI(take) then
        local source = reaper.GetMediaItemTake_Source(take)
        local filename = reaper.GetMediaSourceFileName(source, "")
        local instrument, characteristic, label = parse_sample_name(filename)

        local new_name = string.format("%s - %s - %s", instrument, characteristic, label)
        reaper.GetSetMediaTrackInfo_String(track, "P_NAME", new_name, true)
      end
    end
  end
end

reaper.Undo_EndBlock("Переименовать треки: инструмент - характер - автор", -1)
