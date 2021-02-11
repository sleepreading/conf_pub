' Usage:  cscript PinItem.vbs /item:<path to exe> [/taskbar] [/?]

Option Explicit

Dim blnPinned
Dim blnTaskbar
Dim i
Dim intOpMode
Dim objWshShell
Dim objFSO
Dim objShell
Dim strPath
Dim strArguments
Dim strOptionsMessage
Const CONST_ERROR               = 0
Const CONST_WSCRIPT             = 1
Const CONST_CSCRIPT             = 2
Const CONST_SHOW_USAGE          = 3
Const CONST_PROCEED             = 4
Const CONST_STRING_NOT_FOUND    = -1
Const CONST_FOR_READING         = 1
Const CONST_FOR_WRITING         = 2
Const CONST_FOR_APPENDING       = 8
Const CONST_Success             = 0
Const CONST_Failure             = 1
Const TRISTATE_USE_DEFAULT      = -2
Const TRISTATE_TRUE             = -1
Const TRISTATE_FALSE            = 0
blnTaskbar = False

Set objWshShell = CreateObject("Wscript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("Shell.Application")

For i = 0 to Wscript.arguments.count - 1
    ReDim Preserve arrArguments(i)
    arrArguments(i) = Wscript.arguments.item(i)
Next

Select Case intChkProgram()
    Case CONST_CSCRIPT
        'Do Nothing
    Case CONST_WSCRIPT
        WScript.Echo "Please run this script using CScript." & vbCRLF & _
            "This can be achieved by" & vbCRLF & _
            "1. Using ""CScript MODIFYUSERS.vbs arguments"" for Windows 95/98 or" & VbCrLf & _
            "2. Changing the default Windows Scripting Host setting to CScript" & vbCRLF & _
            "    using ""CScript //H:CScript //S"" and running the script using" & vbCRLF & _
            "    ""MODIFYUSERS.vbs arguments"" for Windows NT."
        WScript.Quit
    Case Else
        WScript.Quit
End Select

Err.Clear()
intOpMode = intParseCmdLine(arrArguments, strPath, blnTaskbar, strOptionsMessage)

If Err.Number Then
    Wscript.Echo "Error 0X" & CStr(Hex(Err.Number)) & " occurred in parsing the command line."
    If Err.Description <> "" Then
        Wscript.Echo "Error description: " & Err.Description & "."
    End If
    'WScript.quit
End If

Select Case intOpMode
    Case CONST_SHOW_USAGE
        Call ShowUsage()
        WScript.quit
    Case CONST_PROCEED
        'Do nothing.
    Case CONST_ERROR
        WScript.quit
    Case Else
        Wscript.Echo "Error occurred in passing parameters."
End Select

' WScript.Echo strOptionsMessage
blnPinned = PinItem(strPath, blnTaskbar)
' WScript.Echo "Item pinned: " & CStr(blnPinned)

If blnPinned Then
    WScript.Quit(0)
Else
    WScript.Quit(1)
End If

Private Function intChkProgram()

    ON ERROR RESUME NEXT
    Dim i
    Dim j
    Dim strFullName
    Dim strCommand

    strFullName = WScript.FullName
    If Err.Number then
        Wscript.Echo "Error 0x" & CStr(Hex(Err.Number)) & " occurred."
        If Err.Description <> "" Then
            Wscript.Echo "Error description: " & Err.Description & "."
        End If
        intChkProgram =  CONST_ERROR
        Exit Function
    End If

    i = InStr(1, strFullName, ".exe", 1)
    If i = 0 Then
        intChkProgram =  CONST_ERROR
        Exit Function
    Else
        j = InStrRev(strFullName, "\", i, 1)
        If j = 0 Then
            intChkProgram =  CONST_ERROR
            Exit Function
        Else
            strCommand = Mid(strFullName, j+1, i-j-1)
            Select Case LCase(strCommand)
                Case "cscript"
                    intChkProgram = CONST_CSCRIPT
                Case "wscript"
                    intChkProgram = CONST_WSCRIPT
                Case Else       'should never happen
                    Wscript.Echo "An unexpected program is used to run this script."
                    Wscript.Echo "Only CScript.Exe or WScript.Exe can be used to run this script."
                    intChkProgram = CONST_ERROR
            End Select
        End If
    End If

End Function

Private Function intParseCmdLine(arrArguments, strPath, blnTaskbar, strOptionsMessage)

    ON ERROR RESUME NEXT

    Dim i
    Dim strFlag
    Dim strSwitchValue
    
    strFlag = arrArguments(0)
    Err.Clear()

    If (strFlag = "") OR (strFlag="help") OR (strFlag="/h") OR (strFlag="\h") OR (strFlag="-h") _
        OR (strFlag = "\?") OR (strFlag = "/?") OR (strFlag = "?") OR (strFlag="h") Then
        intParseCmdLine = CONST_SHOW_USAGE
        Exit Function
    End If

    strOptionsMessage = strOptionsMessage & ""  & VbCrLf
    strOptionsMessage = strOptionsMessage & WScript.ScriptName  & VbCrLf
    strOptionsMessage = strOptionsMessage & ""  & VbCrLf
    strOptionsMessage = strOptionsMessage & "Command Line Options:"  & vbCrLf
    strOptionsMessage = strOptionsMessage & "======================================="  & VbCrLf

    For i = 0 to UBound(arrArguments)
        strFlag = Left(arrArguments(i), InStr(1, arrArguments(i), ":")-1)
        If Err.Number Then
            Err.Clear
            Select Case LCase(arrArguments(i))
                Case "/q"
                    blnQuiet = True
                    strOptionsMessage = strOptionsMessage & "Supress Console Output: " & blnQuiet & VbCrLf
                Case "/taskbar"
                    blnTaskbar = True
                    strOptionsMessage = strOptionsMessage & "Pin to Taskbar instead of Start Menu: " & blnTaskbar & VbCrLf
                Case Else
                    Wscript.Echo arrArguments(i) & " is not recognized as a valid input."
                    intParseCmdLine = CONST_ERROR
                    Exit Function
            End Select
        Else
            strSwitchValue = Right(arrArguments(i), Len(arrArguments(i))-(Len(strFlag)+1))
            Select Case LCase(strFlag)
                Case "/item"
                    strPath = strSwitchValue
                    strOptionsMessage = strOptionsMessage & "Item to pin to Start Menu or Taskbar: " & strPath & VbCrLf
                Case else
                    Wscript.Echo "Invalid flag " & strFlag & "."
                    Wscript.Echo "Please check the input and try again."
                    intParseCmdLine = CONST_ERROR
                    Exit Function
            End Select
        End If
    Next

    If (strPath = "") Then
        Wscript.Echo "The /item switch is required"
        Wscript.Echo "Please check the input and try again."
        intParseCmdLine = CONST_ERROR
        Exit Function
    End If

    intParseCmdLine = CONST_PROCEED

End Function

Function PinItem(strlPath, blnTaskbar)
    On Error Resume Next
    Dim colVerbs
    Dim itemverb
    Dim objFolder
    Dim objFolderItem
    Dim strFolder
    Dim strFile

    If objFSO.FileExists(strlPath) Then
        '***** Do nothing, folder exists
    Else
        '***** Folder does not exist
        PinItem = False
        WScript.Echo "File to pin does not exist."
        WScript.Echo "Please check the input and try again."
        Exit Function
    End If

    strFolder = objFSO.GetParentFolderName(strlPath)
    strFile = objFSO.GetFileName(strlPath)

    'WScript.Echo "Folder: " & strFolder
    'WScript.Echo "File: " & strFile

    Err.Clear
    Set objFolder = objShell.Namespace(strFolder)
    Set objFolderItem = objFolder.ParseName(strFile)

    ' ***** This code works on Vista/WS2008
    Set colVerbs = objFolderItem.Verbs

    If blnTaskbar Then
        For each itemverb in objFolderItem.verbs
            If Replace(itemverb.name, "&", "") = "Pin to Taskbar" Or InStr(itemverb.Name, "������������") Then itemverb.DoIt
        Next 
    Else
        For each itemverb in objFolderItem.verbs
            If Replace(itemverb.name, "&", "") = "Pin to Start Menu" Or InStr(itemverb.Name, "��������ʼ���˵�") Then itemverb.DoIt
        Next 
    End If

    If Err.Number = 0 Then
        PinItem = True
    Else
        PinItem = False
    End If
End Function

Sub ShowUsage()
    WScript.Echo "This script is used to Pin items to the Start Menu or Taskbar."
    WScript.Echo ""
    WScript.Echo "Usage: cscript " & WScript.ScriptName & " [options]"
    WScript.Echo ""
    WScript.Echo "Options:"
    WScript.Echo ""
    WScript.Echo " /item:<PathName>       Path of item to pin."
    WScript.Echo ""
    WScript.Echo " /taskbar               (Optional) Pin to Taskbar instead of Start Menu."
    WScript.Echo ""
    WScript.Echo " /?                     (Optional) Displays this help text."
    WScript.Echo ""
End Sub
