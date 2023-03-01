function pull(element)

	local _table = {}

	if (getElementType(element)) == 'object' then

		if (element:getData('amazing >> isAtm')) then

			table.insert(_table, 

				{
					'Ajuda',
					'assets/icons/atm.png',
					function()
						triggerServerEvent("buffer_infobank", localPlayer, localPlayer)  
						print("Coletando Informações...")
					end,
					true

				}

			);

			table.insert(_table, 

			{
				'Criar conta',
				'assets/icons/atm.png',
				function()
					if getElementData(localPlayer, "BufferAccount") == false then
						triggerServerEvent("buffer_createbank", localPlayer, localPlayer)  
					print("Criando Conta!")
					else
						print("Você ja possui uma conta!")
					end
				end,
				true

			}

			);

			table.insert(_table, 

			{
				'Ver Saldo',
				'assets/icons/atm.png',
				function()
					if getElementData(localPlayer, "BufferAccount") == true then
						local Saldo = getElementData(localPlayer, "BufferSaldo") or "nada"
						print("Você possui "..Saldo.." em sua conta bancaria!")
					else
						print("Você não possui uma conta no banco!")
					end
				end,
				true

			}

			);

		elseif (element:getData('amazing >> registradora')) then

				table.insert(_table, 
		
					{
		
						'Roubar',
						'assets/icons/revistar.png',
						function()
							--if exports["CPX_inventory"]:getItem(localPlayer, 31) >0 then
								triggerEvent("AC-RenderMinigame", localPlayer, "AC-RoubarRegistradora", localPlayer)
								triggerServerEvent("AC-RoubarRegistradora", localPlayer, localPlayer, 0)  
							--else
								exports.Infobox:addBox("error", "Você precisa de uma lockpick!")
							--end
						end,
						true
		
					}
					
		
				);
		end
	elseif (getElementType(element)) == 'ped' then
		if (element:getData('amazing >> pedsdrug')) then

		table.insert(_table, 
	
			{
	
				'Negociar Drogas',
				'assets/icons/revistar.png',
				function()
						--if exports["CPX_inventory"]:getItem(localPlayer, 31) >0 then
						triggerServerEvent("NegociarDrogas", localPlayer, localPlayer, 0)  
						--else
					--end
				end,
				true

			}
				
	
		);

	end
end
	table.insert(_table, {'Fechar', 'assets/icons/close.png', 

		function ()


		end,

	true});

	return _table;

end





--OBS: Obrigatório retornar uma tabela com 4 valores: (Nome do botão, Icone, Função, true~false "para fechar o painel ao clicar no botão".)

--EXEMPLO
--[[		

	table.insert(_table, {'Nome do botão', 'diretório do icone', 

		function ()

		-- código

		end,

	true});

]]

-- ELEMENT DATA (para ativar a interação com outros elementos)
-- "amazing >> haveInteraction"