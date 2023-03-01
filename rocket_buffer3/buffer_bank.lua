bank = {}
function createBank()
    for k,v in pairs(cfg.banks) do
        local model, x, y, z, rx, ry, rz = unpack(v)
        bank[model] = createObject(model, x, y, z-0.35, rx, ry, rz)
        setElementFrozen(bank[model], true)
        setElementData(bank[model], "amazing >> haveInteraction", true)
        setElementData(bank[model], "amazing >> isAtm", true)
    end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), createBank)

-- == C R E A T E == --

function createAcoountBank(ply)
    print("Conta Criada com Sucesso!")
    setElementData(ply, "BufferAccount", true)
    setElementData(ply, "BufferSaldo", "0", true)
end
addEvent("buffer_createbank", true)
addEventHandler("buffer_createbank", root, createAcoountBank)

-- == I N F O S == --

function infoBank(ply)
    print("")
    print("/sacar [valor]")
    print("/depositar [valor]")
    print("/deleteall")
    print("/excluir")
end
addEvent("buffer_infobank", true)
addEventHandler("buffer_infobank", root, infoBank)

-- == S A C A R == --

function buffer_sacarBank(ply, command, amount)
    local Bank = getproxbank(ply, 2)
    local Saldo = getElementData(ply, "BufferSaldo") or "0"
    if Bank then
        if Saldo >= amount then
            setElementData(ply, "BufferSaldo", Saldo-amount)
            givePlayerMoney(ply, amount)
            print("Saque: R$"..amount.."")
        else
            print("Saldo insuficiente!")
        end
    end
end
addCommandHandler("sacar", buffer_sacarBank)

-- == D E P O S I T == --

function buffer_depositBank(ply, command, amount)
    local Bank = getproxbank(ply, 2)
    local Saldo = getElementData(ply, "BufferSaldo") or "0"
    if Bank then
        if getPlayerMoney(ply) > amount then
            setElementData(ply, "BufferSaldo", ""..Saldo+amount.."")
            takePlayerMoney(ply, amount)
            print("Deposito"..amount.."")
        else
            print("Sem dinheiro o suficiente!")
        end
    end
end
addCommandHandler("depositar", buffer_depositBank)

-- == R E M O V E == --

function buffer_removeBank(ply)
    print("Conta Removida com Sucesso!")
    setElementData(ply, "BufferAccount", false)
    setElementData(ply, "BufferSaldo", "0", false)
end
addCommandHandler("excluir", buffer_removeBank)

-- == D E L E T E  A L L == --

function delete_accounts(ply)
    print("Contas bancarias excluidas!")
    setElementData(root, "BufferAccount", true)
    setElementData(root, "BufferSaldo", "0", true)
end
addCommandHandler("deleteall", delete_accounts)








-- == F U N C O E S == --

-- Verifica se há banco proximo
function getproxbank(ply, distance)
	local x, y, z = getElementPosition (ply) 
    local dim = getElementDimension (ply)
	local dist = distance
	local id = false
    local players = getElementsByType("object")
    for i, v in ipairs (players) do 
        if ply ~= v then
            local pX, pY, pZ = getElementPosition (v) 
            local dimV = getElementDimension(v)
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < dist and dim == dimV then
                dist = getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)
                id = v
            end
        end
    end
    if id then
        return id
    else
        return false
    end
end