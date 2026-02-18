
# 🎲 fpgadado

Projeto em **Verilog HDL** para geração de um **dado eletrônico** com display de 7 segmentos controlado por FPGA.

Este repositório contém a implementação de um módulo Verilog sintetizável para a plataforma **Tang Nano 1K**, baseado no FPGA **GW1NZ-LV1** da Gowin Semiconductor. O projeto faz uso de uma sequência pseudoaleatória gerada por um **LFSR (Linear Feedback Shift Register)** para simular um dado de seis faces, exibindo o valor no display de 7 segmentos. Ao pressionar um botão físico ativo em nível baixo, o valor exibido é travado por **5 segundos** antes de voltar a atualizar de forma rápida.

## 🧩 Descrição do Projeto

O sistema foi desenvolvido seguindo princípios de projeto digital em FPGA com linguagem Verilog HDL, abordando:

- Geração de sequência pseudoaleatória com **LFSR**
- Detecção de borda para botão ativo em nível baixo
- Divisor de frequência para atualização visual do display
- Temporização de 5 segundos para manter o valor selecionado
- Conversão de valor binário para padrão de 7 segmentos (cátodo comum)

## 📁 Estrutura

- `dice.v` – módulo principal do dado eletrônico
- `README.md` – documentação do projeto
- Arquivos de síntese e restrições para Gowin FPGA Designer

## 🔌 Interface de Entradas/Saídas

| Sinal     | Direção | Descrição                                |
|-----------|---------|------------------------------------------|
| `clk`     | input   | Clock principal (27 MHz)                 |
| `btn_n`   | input   | Botão de seleção (ativo em nível baixo)  |
| `seg[6:0]`| output  | Saída para display de 7 segmentos        |

## 🚀 Como Usar

1. Abra o projeto no **Gowin FPGA Designer Education**.
2. Importe o arquivo Verilog e o arquivo de restrições de pinos.
3. Faça a síntese, place-and-route e gere o bitstream.
4. Programe a placa **Tang Nano 1K**.
5. Pressione o botão físico para congelar o valor do dado por 5 segundos.

## 📌 Observações

- O valor apresentado no display segue a convenção de lógica para displays **de cátodo comum** (segmento alto = LED aceso).
- A sequência é pseudoaleatória; não é criptograficamente aleatória, mas suficiente para aplicações lúdicas ou didáticas.

## 📝 Referências

- FPGA GW1NZ-LV1 da Gowin Semiconductor  
- Verilog HDL e princípios de síntese lógica  
- Técnicas de detecção de borda e divisores de frequência

---

## 📜 Licença

Este projeto está disponível sob a licença permissiva de código aberto.


