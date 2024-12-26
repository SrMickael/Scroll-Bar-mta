# Scroll Bar OOP para MTA:SA

## Descrição
Este script implementa uma **barra de rolagem reutilizável** em Lua, usando Programação Orientada a Objetos (OOP) para o MTA:SA. A barra é projetada para ser usada em diferentes interfaces, como menus ou listas, com personalização completa e desempenho otimizado.

---

## Recursos

- **Reutilizável:** Crie múltiplas barras de rolagem em uma interface.
- **Callback Customizável:** Função executada apenas quando o valor mudar.
- **Desempenho Otimizado:** Evita chamadas desnecessárias ao callback.
- **Design Flexível:** Personalize dimensões, cores e intervalos de valores.
- **Fácil Integração:** Pronto para uso em projetos existentes.

---

## Exemplo de Uso

```lua
-- Criando duas barras de rolagem
local scrollBars = {
    ScrollBar:new(400, 300, 20, 200, 40, 0, 100, function(value)
        outputChatBox("Barra 1: Valor = " .. value)
    end),
    ScrollBar:new(450, 300, 20, 200, 40, 0, 50, function(value)
        outputChatBox("Barra 2: Valor = " .. value)
    end),
}

-- Renderizando as barras
function renderScrollBars()
    for _, scrollBar in ipairs(scrollBars) do
        scrollBar:render()
    end
end
addEventHandler("onClientRender", root, renderScrollBars)

-- Detectando clique e movimento do mouse
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
```

---

## API da Classe ScrollBar

### `ScrollBar:new(x, y, width, height, cursorHeight, minValue, maxValue, onValueChange)`
Cria uma nova instância de barra de rolagem.

- `x, y`: Posição da barra na tela.
- `width, height`: Dimensões da barra.
- `cursorHeight`: Altura do cursor.
- `minValue, maxValue`: Valores mínimo e máximo.
- `onValueChange`: Callback executado quando o valor muda.

### Métodos

- **`render()`**: Renderiza a barra de rolagem na tela.
- **`onClick(button, state, mx, my)`**: Detecta cliques no cursor.
- **`onCursorMove(mx, my)`**: Move o cursor com o mouse.
- **`getCurrentValue()`**: Retorna o valor atual da barra.

---

## Requisitos

- MTA:SA.
- Configuração de eventos: `onClientRender`, `onClientClick`, `onClientCursorMove`.

---

## Licença
Este projeto está licenciado sob a [MIT License](LICENSE).
