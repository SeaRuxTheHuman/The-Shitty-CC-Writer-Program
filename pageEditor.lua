local tTable={}
local running = true
local xSize, ySize = term.getSize()

local function dDebug()

term.setTextColor(colors.black)
for i = 1,#localKeys do
term.setCursorPos(xSize/2, i)
term.write(localKeys[i][1])
sleep(1)
end



--[[
term.setCursorPos(xSize/2,1)
term.write(localKeys[5][2])
]]--

end

local function readyStuff()
    paintutils.drawFilledBox(1,1,xSize,ySize, colors.lightBlue)
    paintutils.drawFilledBox(math.floor(xSize/2-12),1,xSize/2+12,ySize, colors.white)

    term.setCursorPos(xSize-6, 1)
    term.setTextColor(colors.gray)
    term.setBackgroundColor(colors.lightGray)
    term.write(' Finish')

    term.setTextColor(colors.black)
    term.setBackgroundColor(colors.white)
    --dDebug()
end

local function fillTable()
    for i = 1,21 do
      table.insert(tTable, {})
        for j = 1,25 do
         table.insert(tTable[i], ' ')
        end
    end
end

fillTable()

local function writeChar(sString)
    local sString = tostring(sString)
    if string.len(sString) > 1 then
        error('too many characters')
        --printError('too Many Characters')
    end

    local trX,y=term.getCursorPos()

    x = trX-12

    for i = 1,y do
      if tTable[i] == nil then
          table.insert(tTable,{})
      end
    end

    for i = 1,x do
        if tTable[y][i] == nil then
            table.insert(tTable,{})
        end
    end
    if trX<39 and trX>12 then
        if tTable[y][x] ~= nil then
            table.remove(tTable[y],x)
        end
        table.insert(tTable[y],x,sString)
        term.write(sString)
    end

    if trX>37 then
        term.setCursorPos(trX-25,y+1)
    end
end

local function getReadyTable()
  local readyPage = {}
  term.setTextColor(colors.orange)
  term.setCursorPos(math.floor(xSize/2-12),1)

  for i = 1,#tTable do
    writing = table.concat(tTable[i])
    table.insert(readyPage, writing)
  end
  return readyPage
end

local function savePageTable()
  y=1
  local fileDir='temp.tst'

  if fs.exists(fileDir) == true then
    fs.delete(fileDir)
  else
  end

  file = fs.open(fileDir, 'w')

  for i = 1,#tTable do
      writing = table.concat(tTable[i])
      file.writeLine(writing)
      y=y+1
  end
  file.close()
end

local function printReadyTable()
  local lTable = getReadyTable()
  paintutils.drawFilledBox(math.floor(xSize/2-12),1,xSize/2+12,ySize, colors.white)
  term.setTextColor(colors.green)
  term.setCursorPos(math.floor(xSize/2-12),1)
  for i=1,#lTable do
    term.write(lTable[i])
    term.setCursorPos(math.floor(xSize/2-12),i)
  end

  sleep(0.7)

  term.setTextColor(colors.black)
  term.setCursorPos(math.floor(xSize/2-12),1)
  for i=1,#lTable do
    for x=1,lTable[i] do
      term.write(lTable[x])
    end
    term.setCursorPos(math.floor(xSize/2-12),i)
  end

end

local function printerPrintReadyTable()
  local printer = peripheral.find('printer')
  local lTable = getReadyTable()
  for i=1,#lTable do
    printer.write(lTable[i])
    printer.setCursorPos(1,i)
  end
end

local function PrintMenu()
paintutils.drawBox(xSize/2-11,ySize/2-3,xSize/2+11,ySize/2+5, colors.gray)
paintutils.drawFilledBox(xSize/2-10,ySize/2-2,xSize/2+10,ySize/2+4,colors.lightGray)
  term.setTextColor(colors.white)
  term.setCursorPos(xSize/2-4,ySize/2-1)
  term.write('print to:')
  term.setCursorPos(xSize/2-8,ySize/2)
  term.setTextColor(colors.black)
  term.write('Printer[P] ')
  term.setTextColor(colors.yellow)
  term.write('File[F]')
  term.setCursorPos(xSize/2-6,ySize/2+1)
  term.setTextColor(colors.orange)
  term.write('Both[B] ')
  term.setTextColor(colors.red)
  term.write('Exit[E]')
  term.setCursorPos(xSize/2-4,ySize/2+3)
  term.setTextColor(colors.white)
  term.write('(push Key)')

  local event = {os.pullEvent('char')}
  if event[2] == 'p' or event[2] == 'P' then
    printReadyTable()
    printerPrintReadyTable()
  elseif event[2] == 'f' or event[2] == 'F' then
    savePageTable()
    printReadyTable()
  elseif event[2] == 'b' or event[2] == 'B' then
    printReadyTable()
    savePageTable()
    printerPrintReadyTable()
  elseif event[2] == 'e' or event[2] == 'E' then
    running = false
  else
    sleep(0.1)
  end
  --sleep(30)
end
readyStuff()

local shift = false
wW,hH = xSize/2-13, 1

---------------------------------LOOP STARTS HERE
while running do
 local event,valA,valB,valC=os.pullEvent()
  if event == 'mouse_click' then --mouse click
      if valB > xSize-6 and valC == 1 then
        PrintMenu()
      else

      if valB > xSize/2-13 and valB < xSize/2+12 then
        term.setCursorPos(valB,valC)
        term.write(string.char(127))
        sleep(0.1)
        if tTable[valC][valB-12] ~= nil then
          term.setCursorPos(valB,valC)
          term.write(tostring(tTable[valC][valB-12]))
        end
        term.setCursorPos(valB,valC)
        wW,hH = valB,valC
      end
      end

  elseif event == 'char' then --key click
    writeChar(valA)


  elseif event == 'key' then

    if keys.getName(valA) == 'enter' then
        term.setCursorPos(wW,hH+1)
        wW,hH=wW,hH+1
    elseif keys.getName(valA) == 'backspace' then
        local xN,yN = term.getCursorPos()
        term.setCursorPos(xN-1,yN)
        writeChar(' ')
        term.setCursorPos(xN-1,yN)
    else
    end

  else
  end
end
---------------------------------LOOP ENDS HERE



term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.setCursorPos(1,1)
term.clear()
