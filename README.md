🏧 - **System Bank**      
Um simples sistema de banco não profissional, porem semelhante aos bancos brasileiros. Não possui muitas funções porem é bom para estudos!

✨**Status:** *Finalizada* no dia *01/03/2023* as *15:27*.

🛑 - **Tasklist:**

- ✅ Vincular o sistema de interação ao banco  
- ✅ Adicionar tabela para a criação de demais bancos  
- ✅ Sistema de contas, criar e excluir contas  
- ✅ Saque e deposito
 
⚙️ - **Commands:**

*/sacar X* - Saca uma determinada quantidade escolhida pelo jogador                
*/depositar X* - Deposita uma determinada quantidade escolhida pelo jogador
*/deleteall* - Exclui todas as contas já criadas do servidor   
*/excluir* - Exclui a conta do jogador que executou o comando

🔨 - **Funcionalidade:**

Com o sistema de interação quando o jogador clicar em cima do banco que é criado atraves de uma tabela no "buffer_shared.lua" irá abrir uma pequena aba com três opções:

- 🎲 - *Criar conta;*  
- 🎲 - *Informações;*  
- 🎲 - *Fechar;*

🎮 - Quando o jogador clicar em *"Criar conta"* o sistema de interação irá 'triggar' para o buffer_bank o evento: "buffer_createbank" e sera setado por meio de elementData com conta criada e saldo zerado.

🎮 - Quando o jogador clicar em *"Informações"* o sistema de interação irá 'triggar' para o buffer_bank o evento: "buffer_infobank" e receberá no debugscript 3 por meio da função "print" todos os comandos que o sistema possui.

🎮 - Quando o jogador clicar em *"Fechar"* o sistema de interação receberá a informação e removerá os efeitos *DX*.

- *Mentoria de:*   
**@flashiie / getDiscover**

*getDiscover Community:* 
 https://discord.gg/tAYuJpAPRJ