OfflineBan = {}

OfflineBan.uid = ""
OfflineBan.did = ""
OfflineBan.ip = ""
OfflineBan.reason = ""
OfflineBan.time = ""

function OfflineBan:GetName()
    return "OFF-BAN"
end

function OfflineBan:OnOpen()
    if not self.main.adminPanel.isClient then return end

    self.main.adminPanel:CreateHeader("Offline ban")

    local accountID_inputField = self.main.adminPanel:CreateInputField("ID аккаунта", 30, CS.UnityEngine.UI.InputField.ContentType.IntegerNumber):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    local deviceID_inputField = self.main.adminPanel:CreateInputField("ID устройства", 30, CS.UnityEngine.UI.InputField.ContentType.Alphanumeric):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    local ip_inputField = self.main.adminPanel:CreateInputField("IP игрока", 30, CS.UnityEngine.UI.InputField.ContentType.Standard):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    
    local reason_inputField = self.main.adminPanel:CreateInputField("Причина", 30, CS.UnityEngine.UI.InputField.ContentType.Standard):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    local time_inputField = self.main.adminPanel:CreateInputField("Время (в минутах)", 30, CS.UnityEngine.UI.InputField.ContentType.IntegerNumber):GetComponent(typeof(CS.UnityEngine.UI.InputField))
    
    accountID_inputField.text = self.uid
    deviceID_inputField.text = self.did
    ip_inputField.text = self.ip
    reason_inputField.text = self.reason
    time_inputField.text = self.time

    local save_btn = self.main.adminPanel:CreateButton("Сохранить ввод"):GetComponent(typeof(CS.UnityEngine.UI.Button))
    local ban_btn = self.main.adminPanel:CreateButton("<color=red>Забанить</color>"):GetComponent(typeof(CS.UnityEngine.UI.Button))

    CS.UIManager.BindAction(save_btn.onClick, 
    function() 
        self:Save(accountID_inputField.text, deviceID_inputField.text, ip_inputField.text,
        reason_inputField.text, time_inputField.text)
    end)
    CS.UIManager.BindAction(ban_btn.onClick, 
    function() 
        self.main:SendToServer("BanUser", accountID_inputField.text, deviceID_inputField.text, ip_inputField.text, 
        reason_inputField.text, time_inputField.text)
    end)
end

-- CLIENT
function OfflineBan:Save(uid, did, ip, reason, time)
    self.uid = uid or ""
    self.did = did or ""
    self.ip = ip or ""
    self.reason = reason or ""
    self.time = time or ""
end

-- SERVER
function OfflineBan:BanUser(UID, DID, IP, reason, time, conn)
    if UID == nil or DID == nil or IP == nil or time == nil then return end
    UID = tonumber(UID)
    reason = reason or ""
    if UID == nil then return end

    CS.Config.BanUser(UID, {DID}, IP, reason, time)
    CS.Config.UpdateBans()

    self.main.adminPanel:ShowAdminMessage("<color=red>Вы успешно забанили игрока</color>", 3, CS.PlayerUtilities.GetServerPlayer(conn))
end

return OfflineBan