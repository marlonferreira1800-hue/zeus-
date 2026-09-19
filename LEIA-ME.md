# Pixelbound — Jornada dos Seis Mundos

Jogo de plataforma feito no Godot 4.7. O herói precisa reunir a energia espalhada pelos mundos e alcançar a Cidadela Celeste para restaurar o Núcleo.

## Começo, meio e fim

| Fase | Mundo | Papel na história | Objetivo para abrir o portal |
| --- | --- | --- | --- |
| 1 | Vale Greenbyte | A energia do vale foi roubada. | 12 fragmentos e 4 slimes |
| 2 | Cavernas de Cristal | A trilha passa pelo subsolo. | 8 cristais e 2 slimes |
| 3 | Fortaleza das Engrenagens | O herói atravessa as máquinas. | 8 engrenagens e 3 slimes |
| 4 | Copa Esmeralda | O caminho sobe pela floresta. | 8 folhas e 3 slimes |
| 5 | Abismo de Brasa | A última barreira é uma região vulcânica. | 10 brasas e 3 slimes |
| 6 | Cidadela Celeste | O Núcleo é restaurado e a aventura termina. | 10 estrelas e 4 slimes |

Cada mundo tem cenário próprio, plataformas, perigos, inimigos, itens e portal. O portal mostra o que ainda falta quando está fechado. Ao perder todas as vidas, **Repetir esta fase** recomeça o mundo atual. As vidas voltam a três ao entrar no próximo mundo.

## Jogar

Abra `project.godot` no Godot 4.7 e pressione **F5** ou o botão **Executar projeto**.

Para jogar sem instalar o editor, abra `Pixelbound.exe` da pasta `Pixelbound-Windows` entregue junto com o projeto. A exportação para Windows 64 bits reúne o jogo e os recursos em um único executável.

Para jogar no navegador, use a pasta `Pixelbound-Web` e publique os arquivos em uma hospedagem estática. Ela contém `index.html`, `index.js`, `index.wasm` e `index.pck`. O WebAssembly do motor ocupa cerca de 40 MB; por isso, uma versão Web completa não consegue ficar em 21 MB sem remover o motor ou reduzir muito o conteúdo.

- **A/D** ou **setas**: mover
- **Espaço/W/seta para cima**: pular
- **Shift**: correr
- **Esc**: pausar
- **R**: repetir a fase após derrota

Os fundos das fases 2 a 6 estão em `assets/backgrounds/`. O Vale usa a arte original do jogo de referência, em `assets/pixelbound/`.

## Verificação

O teste `tests/smoke.gd` percorre as seis cenas, confere itens e inimigos, tenta os portais antes e depois dos objetivos, testa saltos e verifica vitória, dano e reinício.

```powershell
godot --headless --path . --script res://tests/smoke.gd
```
