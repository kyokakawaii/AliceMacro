#Requires AutoHotkey v2.0

#UseHook True

SetKeyDelay -1, -1
Thread "Interrupt", 0

down_time := 250
up_time := 25

ready := 0
Toggle := 1

#HotIf ready
RButton::
{
    While GetKeyState("RButton", "P") {
        Send "{LButton down}"
        Sleep down_time
        Send "{LButton up}"
        Sleep up_time
    }
}

^1:: {
    ExitApp
}

ChangeOnDownTime(GuiCtrl, *)
{
    global down_time
    try {
        down_time := Integer(GuiCtrl.Value)
    }
    catch as err {
        return 
    }
}

ChangeOnUpTime(GuiCtrl, *)
{
    global up_time
    try {
        up_time := Integer(GuiCtrl.Value)
    }
    catch as err {
        return 
    }
}

ClickOnStart(*)
{
    global ready
    ready := 1
    WriteSettings()
    MsgBox "已开始待机，长按右键即可连点"
}

ClickOnQuit(*)
{
    ExitApp
}

LoadSettings()
{
    global down_time
    global up_time
    down_time := IniRead("AliceSettings.ini", "section1", "down_time")
    up_time := IniRead("AliceSettings.ini", "section1", "up_time")
}

WriteSettings()
{
    IniWrite(down_time, "AliceSettings.ini", "section1", "down_time")
    IniWrite(up_time, "AliceSettings.ini", "section1", "up_time")
}

if !A_IsAdmin {
    MsgBox "请以管理员身份运行"
    ExitApp
}

SetWorkingDir A_ScriptDir
try {
    LoadSettings()
}
catch as err {
    WriteSettings()
}

AliceGui := Gui(, "爱丽丝连点器")
AliceGui.Add("Text",, "按下时间(ms)")
AliceGui.Add("Edit", " w360", down_time).OnEvent("Change", ChangeOnDownTime)
AliceGui.Add("Text",, "抬起时间(ms)")
AliceGui.Add("Edit", " w360", up_time).OnEvent("Change", ChangeOnUpTime)
AliceGui.Add("Button", "Default w80 XP+100 YP+40", "开始待机").OnEvent("Click", ClickOnStart)
AliceGui.Add("Button", "Default w80 XP+100", "退出").OnEvent("Click", ClickOnQuit)
AliceGui.Show()
