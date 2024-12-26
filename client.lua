

--[[ 
Script: Scroll Bar em OOP (Otimizado)
Objetivo: Evitar chamadas repetidas ao callback para o mesmo valor.
Autor: Mickael
Data: 26/12/2024
--]]

ScrollBar = {}
ScrollBar.__index = ScrollBar

-- Construtor da barra de rolagem
function ScrollBar:new(x, y, width, height, cursorHeight, minValue, maxValue, onValueChange)
    local self = setmetatable({}, ScrollBar)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.cursorHeight = cursorHeight
    self.minValue = minValue or 0
    self.maxValue = maxValue or 100
    self.value = 0 -- Posição entre 0 e 1
    self.isDragging = false
    self.onValueChange = onValueChange or function() end -- Callback ao mudar o valor
    self.lastValue = nil -- Valor anterior (para evitar callbacks repetidos)
    return self
end

-- Função para renderizar a barra
function ScrollBar:render()
    -- Desenhar o fundo da barra
    dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(50, 50, 50, 200))
    
    -- Calcular a posição do cursor
    local cursorY = self.y + (self.value * (self.height - self.cursorHeight))
    
    -- Desenhar o cursor
    dxDrawRectangle(self.x, cursorY, self.width, self.cursorHeight, tocolor(100, 200, 100, 255))
    
    -- Exibir o valor atual
    local currentValue = self:getCurrentValue()
    dxDrawText("Valor: " .. tostring(currentValue), self.x + self.width + 10, self.y, 0, 0, tocolor(255, 255, 255, 255), 1, "default-bold")
end

-- Função para calcular o valor atual baseado na posição
function ScrollBar:getCurrentValue()
    return math.floor(self.minValue + (self.value * (self.maxValue - self.minValue)))
end

-- Função para detectar clique do mouse
function ScrollBar:onClick(button, state, mx, my)
    if button == "left" then
        local cursorY = self.y + (self.value * (self.height - self.cursorHeight))
        if state == "down" and mx >= self.x and mx <= self.x + self.width and my >= cursorY and my <= cursorY + self.cursorHeight then
            self.isDragging = true
        elseif state == "up" then
            self.isDragging = false
        end
    end
end

-- Função para movimentar o cursor com o mouse
function ScrollBar:onCursorMove(mx, my)
    if self.isDragging then
        local relativeY = math.max(0, math.min(my - self.y, self.height - self.cursorHeight))
        self.value = relativeY / (self.height - self.cursorHeight)
        local currentValue = self:getCurrentValue()
        if currentValue ~= self.lastValue then
            self.lastValue = currentValue
            self.onValueChange(currentValue) -- Chama o callback apenas se o valor mudou
        end
    end
end

--[[ Exemplo de Uso ]]

-- Instâncias de barras de rolagem
local scrollBars = {
    ScrollBar:new(400, 300, 20, 200, 40, 0, 100, function(value)
        outputChatBox("Barra 1: Valor = " .. value)
    end),
    ScrollBar:new(450, 300, 20, 200, 40, 0, 50, function(value)
        outputChatBox("Barra 2: Valor = " .. value)
    end),
}

-- Função para renderizar todas as barras
function renderScrollBars()
    for _, scrollBar in ipairs(scrollBars) do
        scrollBar:render()
    end
end
addEventHandler("onClientRender", root, renderScrollBars)

-- Funções para eventos de clique e movimento do mouse
function handleClick(button, state, mx, my)
    for _, scrollBar in ipairs(scrollBars) do
        scrollBar:onClick(button, state, mx, my)
    end
end
addEventHandler("onClientClick", root, handleClick)

function handleCursorMove(_, _, mx, my)
    for _, scrollBar in ipairs(scrollBars) do
        scrollBar:onCursorMove(mx, my)
    end
end
addEventHandler("onClientCursorMove", root, handleCursorMove)

--[[ 
Notas:
1. A otimização evita múltiplas chamadas ao callback com o mesmo valor.
2. O `self.lastValue` armazena o último valor calculado.
3. O callback `onValueChange` será executado apenas quando o valor realmente mudar.
4. A estrutura continua modular e reutilizável.
--]]
