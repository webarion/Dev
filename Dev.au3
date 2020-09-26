#include-Once

#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <GUITreeView.au3>
#include <GUIScrollBars.au3>
#include <ScrollBarConstants.au3>
#include <ComboConstants.au3>
#include <GuiStatusBar.au3>
#include <WinAPIDiag.au3>

; # О БИБЛИОТЕКЕ # ==============================================================================================================
; Название .........: Dev
; Текущая версия ...: 1.1.0
; AutoIt Версия ....: 3.3.14.5
; Описание .........: Помощник разработчика
; Автор ............: Webarion
; Сылки: ...........: http://webarion.ru, http://f91974ik.bget.ru
; Примечание .......: В сборке есть решения других авторов IIuOHeP и @Chimp
; ===============================================================================================================================
; # ABOUT THE LIBRARY # =========================================================================================================
; Name .............: Dev
; Version ..........: 1.1.0
; AutoIt Version ...: 3.3.14.5
; Description ......: Developer assistant
; Author ...........: Webarion
; Shortcuts: .......: http://webarion.ru, http://f91974ik.bget.ru
; Note .............: The build contains solutions by other authors IIuOHeP and @Chimp
; ===============================================================================================================================

#Region Пример. Example
;~ ; Использовать только во время тестирования и  разработки скриптов. В релизах лучше удалить, либо закомментировать.
;~ ; Use only during testing and script development. In releases, it is better to delete or comment out.

;~ #include <Dev.au3>; Dev.au3 переместить в папку AutoIt\Include.    Move Dev.au3 to the AutoIt\Include folder.

;~ Local $sText = '12345' ; Строка. String
;~ Local $aArray1[4] = [1, 2, 3, 4] ; Одномерный массив. One-dimensional array
;~ Local $aArray2[4][2] = [[1, 2], [3, 4], [5, 6], [7, 8]] ; Двумерный массив. Two-dimensional array
;~ Local $aArray3[3][2][4] = [[[1, 2, 3, 4], [5, 6, 7, 8]], [[9, 10, 11, 12], [13, 14, 15, 16]], [[17, 18, 19, 20], [21, 22, 23, 24]]] ; Трёхмерный массив. Three-dimensional array.
;~ Local $aArray4[3][2][5][1][7] ; Пятимерный массив. Five-dimensional array

;~ Local $tStructTest = DllStructCreate('int;char[5];boolean;int')
;~ DllStructSetData($tStructTest, 1, 12)
;~ DllStructSetData($tStructTest, 2, '12345')
;~ DllStructSetData($tStructTest, 3, True)
;~ DllStructSetData($tStructTest, 4, 99)

;~ _P($sText)
;~ _P($sText, 2)
;~ _P($aArray1)
;~ _P($aArray1, 1)
;~ _P($aArray2)
;~ _P($aArray2, 1)
;~ _P($aArray3)
;~ _P($aArray4)
;~ _P($tStructTest, 'int;char[5];boolean;int')
;~ _O($sText, 1, 2, 3, $sText)
#EndRegion Пример. Example


; #ФУНКЦИЯ# ====================================================================================================================
; Описание ...: Помогает быстро вывести информацию, при диагностировании скриптов.
; Параметры ..: $vData - Данные, которые нужно показать. Строка, массив или структура
;             : $vMode - Способ вывода:
;             :		Если $vMode = 0 (без параметра) Строку выводит в консоль, массив показывает в форме.
;             :		Если $vMode = 1 Строку, а также одномерный и двухмерный массив выводит в консоль.
;             :		Если $vMode = 2 Строку показывает во всплывающем сообщении.
;             :   Если $vData структура, то в $vMode возможно указать схему структуры, например: _P($tStruct, 'int;dword')
; Автор ......: Webarion
; Версия .....: 1.1.0
; ===============================================================================================================================
; #FUNCTION# ====================================================================================================================
; Description : helps you quickly display information when diagnosing scripts.
; Parameters .: $vData - Data to show. String, array, or structure
;             : $vMode - output method:
;             : If $vMode = 0 (without parameter) Outputs a string to the console, and displays an array in the form.
;             : If $vMode = 1 String, it outputs a one-dimensional and two-dimensional array to the console.
;             : If $vMode = 2, It shows the string in the pop-up message.
;             : If $vData is a structure, it is possible to specify the structure schema in $vMode, for example: _P($tStruct, 'int;dword')
; Author ......: Webarion
; Version .....: 1.1.0
; ===============================================================================================================================
Func _P($vData, $vMode = 0)
	If IsArray($vData) Then
		If UBound($vData, 0) > 2 Then
			_ArrayView($vData)
			Return
		EndIf
		If Not $vMode Then
			_ArrayDisplayConsole($vData)
		Else
			_ArrayDisplay($vData)
		EndIf
	ElseIf VarGetType($vData) = VarGetType(DllStructCreate('byte')) Then
		If Not $vMode Then $vMode = ''
		_WinAPI_DisplayStruct($vData, $vMode)
	Else
		If $vMode = 2 Then
			MsgBox(0, '', $vData)
		Else
			ConsoleWrite($vData & @CR)
		EndIf
	EndIf
EndFunc   ;==>_P


; #ФУНКЦИЯ. FUNCTION# ===========================================================================================================
; Описание ...: Через пробел, выводит в консоль строку с указанными переменными
; Параметры ..: $vT0, ... $vT9 - строковые или числовые переменные
; Пример: _O(1,2,3) - выводит: 1 2 3
; Ограничение : можно указать до 9 переменных

; Description : separated by a space, outputs a string with the specified variables to the console
; Parameters .: $vT0, ... $vT9 - string or numeric variables
; Example ....: _O(1,2,3) - outputs: 1 2 3
; Limit ......: you can specify up to 9 variables
; ===============================================================================================================================
Func _O($vT0 = '', $vT1 = '', $vT2 = '', $vT3 = '', $vT4 = '', $vT5 = '', $vT6 = '', $vT7 = '', $vT8 = '', $vT9 = '')
	If $vT0 Then ConsoleWrite($vT0)
	If $vT1 Then ConsoleWrite(' ' & $vT1)
	If $vT2 Then ConsoleWrite(' ' & $vT2)
	If $vT3 Then ConsoleWrite(' ' & $vT3)
	If $vT4 Then ConsoleWrite(' ' & $vT4)
	If $vT5 Then ConsoleWrite(' ' & $vT5)
	If $vT6 Then ConsoleWrite(' ' & $vT6)
	If $vT7 Then ConsoleWrite(' ' & $vT7)
	If $vT8 Then ConsoleWrite(' ' & $vT8)
	If $vT9 Then ConsoleWrite(' ' & $vT9)
	ConsoleWrite(@CRLF)
EndFunc   ;==>_O


#Region _ArrayDisplayConsole
; #ФУНКЦИЯ. FUNCTION# ====================================================================================================
; Описание ...: Показывает в консоли 1D и 2D массив
; Автор ......: IIuOHeP

; Description : Displays a 1D and 2D array in the console
; Author .....: IIuOHeP
; ========================================================================================================================
Func _ArrayDisplayConsole($Array, $ViewStAndCol = 1, $separator = "|")
	If Not IsArray($Array) Then ConsoleWrite("! It not $Array" & @CRLF)
	If UBound($Array, 0) > 2 Then ConsoleWrite("! Array > 2D not supported" & @CRLF)
	If UBound($Array, 0) = 1 Then ;Array 1D
		For $index = 0 To UBound($Array) - 1
			If Not IsArray($Array[$index]) Then
				If $ViewStAndCol = 0 Then
					ConsoleWrite($Array[$index] & @CRLF)
				Else
					ConsoleWrite('Str_' & $index & @TAB & $separator & $Array[$index] & @CRLF)
				EndIf
			Else
				If $ViewStAndCol = 0 Then
					ConsoleWrite("$Array_" & UBound($Array[$index], 0) & "D" & @CRLF)
				Else
					ConsoleWrite('Str_' & $index & @TAB & "$Array_" & UBound($Array[$index], 0) & "D" & @CRLF)
				EndIf
			EndIf
		Next
		ConsoleWrite('---------------------------------' & @CRLF)
	ElseIf UBound($Array, 0) = 2 Then ;Array 2D
		Dim $ArrayStringLen[UBound($Array, 1)][UBound($Array, 2)]
		Dim $ArrayStringLenMax[2][UBound($Array, 2)]
		For $CIndex = 0 To UBound($Array, 2) - 1 Step 1
			Local $Temp = 0
			Local $tempSIndex = 0
			Local $TempSamm = 0
			For $SIndex = 0 To UBound($Array, 1) - 1 Step 1
				If IsArray($Array[$SIndex][$CIndex]) Then $Array[$SIndex][$CIndex] = "$Array_" & UBound($Array[$SIndex][$CIndex], 0) & "D"
				$Array[$SIndex][$CIndex] = StringReplace($Array[$SIndex][$CIndex], @TAB, ChrW(172))
				If $Temp < StringLen($Array[$SIndex][$CIndex]) Then
					$tempSIndex = $SIndex
					$Temp = StringLen($Array[$SIndex][$CIndex])
				EndIf
				$TempSamm += StringLen($Array[$SIndex][$CIndex])
			Next
			If $Temp = $TempSamm / UBound($Array, 1) Then
				$ArrayStringLenMax[0][$CIndex] = $Temp
				$ArrayStringLenMax[1][$CIndex] = -1
			Else
				$ArrayStringLenMax[0][$CIndex] = $Temp
				$ArrayStringLenMax[1][$CIndex] = $tempSIndex
			EndIf
			For $SIndex = 0 To UBound($Array, 1) - 1 Step 1
				If $SIndex <> $ArrayStringLenMax[1][$CIndex] Then
					Local $difference = ($ArrayStringLenMax[0][$CIndex] + 1) / 8
					Local $difference2 = $difference - ($ArrayStringLenMax[0][$CIndex] - StringLen($Array[$SIndex][$CIndex])) / 8
					If $difference - Floor($difference) > 0 Then $difference = Floor($difference) + 1
					$difference = $difference - Floor($difference2)
					For $IndexDeff = 0 To $difference - 1 Step 1
						$Array[$SIndex][$CIndex] = $Array[$SIndex][$CIndex] & @TAB
					Next
				Else
					Local $StringLen = StringLen($Array[$SIndex][$CIndex]) + 1
					If IsFloat($StringLen / 8) = 0 Then
					Else
						$Array[$SIndex][$CIndex] = $Array[$SIndex][$CIndex] & @TAB
					EndIf
				EndIf
			Next
		Next
		If $ViewStAndCol = 1 Then
			Local $Result = ">" & @TAB
			For $SIndex = 0 To UBound($Array, 2) - 1 Step 1
				$Result = $Result & $separator & "Col_" & $SIndex
				$difference = ($ArrayStringLenMax[0][$SIndex] + 1) / 8
				If $difference - Floor($difference) > 0 Then $difference = Floor($difference) + 1
				For $IndexDeff = 0 To $difference - 1 Step 1
					$Result = $Result & @TAB
				Next
			Next
			ConsoleWrite($Result & $separator & @CRLF)
		EndIf
		For $CIndex = 0 To UBound($Array, 1) - 1 Step 1
			If $ViewStAndCol = 0 Then
				$Result = $separator
			Else
				$Result = "Str_" & $CIndex & @TAB & $separator
			EndIf
			For $SIndex = 0 To UBound($Array, 2) - 1 Step 1
				$Result = $Result & $Array[$CIndex][$SIndex] & $separator
			Next
			ConsoleWrite($Result & @CRLF)
		Next
		ConsoleWrite('---------------------------------' & @CRLF)
	EndIf

EndFunc   ;==>_ArrayDisplayConsole
#EndRegion _ArrayDisplayConsole

#Region _ArrayView
; #ФУНКЦИЯ. FUNCTION# ====================================================================================================
; Описание ...: Показывает многомерный массив
; Автор ......: @Chimp

; Description : Shows a multidimensional array
; Author .....: @Chimp
; ========================================================================================================================
Func _ArrayView(ByRef $_aInput)
	; Автор: @Chimp
	If Not IsArray($_aInput) Then Return SetError(1, 0, 0) ; if error set @Error and return 0
	Local $iGUIwidth = 900
	Local $iGUIheight = 600
	Local $iTreeWidth = 150
	Local $iCombosZone = 60
	Local $hGui = GUICreate("Array viewer", $iGUIwidth, $iGUIheight)
	Local $StatusBar = _GUICtrlStatusBar_Create($hGui), $iStatusBarheight = 23
	Local $aSubscripts[64][4] ; It holds IDs of controls
	; - creates all ComboBox in an embedded window. All controls are hidden at startup.
	; - Only the necessary combo will be shown at run time. One combo for each dimension
	Local $hSubscriptSelectors = GUICreate('', $iGUIwidth - $iTreeWidth - 6, $iCombosZone - 2, $iTreeWidth + 4, 2, BitOR($WS_CHILD, $WS_HSCROLL), -1, $hGui)
	; GUISetBkColor(0xEEFFEE)
	For $i = 0 To 63 ; Create the labels
		$aSubscripts[$i][0] = GUICtrlCreateLabel('D' & $i + 1, ($i * 60) + 8, 1)
		GUICtrlSetFont(-1, 10, 0, 0, "Courier new")
		GUICtrlSetState(-1, $GUI_HIDE) ; Labels will be hidden at startup.
		$aSubscripts[$i][1] = GUICtrlCreateLabel('[', ($i * 60), 18)
		GUICtrlSetFont(-1, 13, 800)
		GUICtrlSetState(-1, $GUI_HIDE)
		$aSubscripts[$i][3] = GUICtrlCreateLabel(']', ($i * 60) + 50, 18)
		GUICtrlSetFont(-1, 13, 800)
		GUICtrlSetState(-1, $GUI_HIDE)
	Next
	For $i = 0 To 63 ; Create the ComboBox (creates separatelly from labels so that ControlIDs of ComboBaxes has it's own sequence)
		GUICtrlSetState(-1, $GUI_HIDE) ; ComboBox will be hidden at startup.
		If $i < 2 Then ; all the content of the first 2 dimensions is already shown in the listview (no need of ComboBox)
			$aSubscripts[$i][2] = GUICtrlCreateCombo("---", ($i * 60) + 8, 17, 40, -1, $CBS_DROPDOWNLIST)
			GUICtrlSetState(-1, $GUI_DISABLE)
		Else
			$aSubscripts[$i][2] = GUICtrlCreateCombo("0", ($i * 60) + 8, 17, 40, -1, $CBS_DROPDOWNLIST)
		EndIf
		GUICtrlSetFont(-1, 8, 800)
		GUICtrlSetState(-1, $GUI_HIDE) ; ComboBox hidden at startup.
	Next
	GUISwitch($hGui) ; back to main window
	; Create the TreeView structure
	Local $hTree = GUICtrlCreateTreeView(2, 2, $iTreeWidth - 2, $iGUIheight - 4 - $iStatusBarheight, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
	Local $hRoot = _GUICtrlTreeView_Add($hTree, 0, "Root") ; first insert the root key in treeview
	_ArrayTraverse($_aInput, $hTree, $hRoot) ; Search for SubArrays (array in array)
	; Create the ListView
	Local $idListview = GUICtrlCreateListView('', $iTreeWidth + 2, $iCombosZone + 2, $iGUIwidth - $iTreeWidth - 4, $iGUIheight - $iCombosZone - 4 - $iStatusBarheight, Default, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_GRIDLINES))
	; If Array has many dimensions, and so all ComboBoxes doesn't fit in window, this allows to scroll
	GUIRegisterMsg($WM_HSCROLL, "WM_HSCROLL")
	_GUIScrollBars_Init($hSubscriptSelectors, 60 * UBound($_aInput, 0), 0)
	GUISetState(@SW_SHOW, $hGui)
	GUISetState(@SW_SHOW, $hSubscriptSelectors)
	; Main Loop until the user exits.
	; -------------------------------
	Local $sLastWholeKey, $sWholeKey, $vContent, $bRebuild
	While 1
		Local $Msg = GUIGetMsg()
		Switch $Msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($hGui)
				ExitLoop
			Case $aSubscripts[2][2] To $aSubscripts[63][2] ; some ComboBox has changed
				_ArrayDisplayByLayer($vContent, $idListview, $aSubscripts, False)
		EndSwitch
		;
		$sWholeKey = _GUICtrlTreeView_GetTree($hTree, _GUICtrlTreeView_GetSelection($hTree))
		If $sLastWholeKey <> $sWholeKey Then ; clicked on a new KeyPath or (again) on the one already selected?
			GUISetCursor(15, 1) ; set cursor to "wait"
			; Adapt the TreePath to the array access syntax
			Local $sElement = _TreePathParser($sWholeKey) ; address of main array or subarray to peek
			_GUICtrlStatusBar_SetText($StatusBar, StringReplace($sWholeKey, '|', '->') & ' --> ' & $sElement) ; show the 'address' of selected element on statusbar
			$vContent = Execute(_TreePathParser($sWholeKey))
			_ArrayDisplayByLayer($vContent, $idListview, $aSubscripts, True)
			_GUICtrlTreeView_ClickItem($hTree, _GUICtrlTreeView_GetSelection($hTree))
			$sLastWholeKey = $sWholeKey ; keep track of already clicked KeyPath so we will not redraw the same Array if clicked again
			GUISetCursor() ; cursor back to default
		EndIf
		;
	WEnd
	Return SetError(0, 0, 1) ; if no errors return 1
EndFunc   ;==>_ArrayView

Func _ArrayDisplayByLayer(ByRef $_aInput, ByRef $idListview, ByRef $aSubscripts, $bRebuild = False)
	Opt('GUIOnEventMode', 1) ; Disable GUIGetMsg() so is not fired while redrawing ComboBoxes.
	Local $sTarghet = '$_aInput[$y]'
	Local $iDimensions = UBound($_aInput, 0)
	Local $iRows = UBound($_aInput, 1)
	Local $iColumnsCount, $iColumns = UBound($_aInput, 2)
	Local $sSubscripts = ''
	; Clear the ListView
	_GUICtrlListView_DeleteAllItems($idListview)
	If $bRebuild Then ; (Re)Create the ListView
		$iColumnsCount = _GUICtrlListView_GetColumnCount($idListview)
		If $iColumnsCount Then
			For $i = $iColumnsCount To 1 Step -1
				_GUICtrlListView_DeleteColumn($idListview, $i - 1)
			Next
		EndIf
		; Hide and clear all ComboBox
		For $i = 0 To 63
			GUICtrlSetState($aSubscripts[$i][0], $GUI_HIDE) ; Header
			GUICtrlSetState($aSubscripts[$i][1], $GUI_HIDE) ; '['
			GUICtrlSetState($aSubscripts[$i][2], $GUI_HIDE) ; ComboBox Handle
			GUICtrlSetData($aSubscripts[$i][2], '') ; clear ComboBox items
			GUICtrlSetState($aSubscripts[$i][3], $GUI_HIDE) ; ']'
		Next
		; (Re)Build the ListView's frame
		If $iDimensions = 1 Then
			$iColumns = 1
		Else
			$iColumns = UBound($_aInput, 2) ; nr. of columns in the ListView (second dimension)
			$sTarghet &= '[$x]'
		EndIf
		_GUICtrlListView_AddColumn($idListview, 'Row')
		For $i = 1 To $iColumns
			_GUICtrlListView_AddColumn($idListview, 'Col ' & $i - 1, 100)
		Next
		For $i = 0 To $iDimensions - 1 ; Show only necessary ComboBox (one for each dimension)
			GUICtrlSetState($aSubscripts[$i][0], $GUI_SHOW) ; Header
			GUICtrlSetState($aSubscripts[$i][1], $GUI_SHOW) ; '['
			GUICtrlSetState($aSubscripts[$i][2], $GUI_SHOW) ; ComboBox Handle
			GUICtrlSetState($aSubscripts[$i][3], $GUI_SHOW) ; ']'
			If $i > 1 Then
				$sTarghet &= '[0]' ; dimensions over the second all setting to 0 (begin showing first lyer)
				$sSubscripts = ""
				For $iSubscript = 0 To UBound($_aInput, $i + 1) - 1
					$sSubscripts &= $iSubscript & '|'
				Next
				GUICtrlSetData($aSubscripts[$i][2], StringTrimRight($sSubscripts, 1))
				ControlFocus('', '', $aSubscripts[$i][2])
				ControlSend('', '', $aSubscripts[$i][2], 0)
			EndIf
		Next
	Else ; Just refill the listview with data from the Array dimension selected by ComboBoxes
		; Create the 'dimension' string
		$sTarghet &= '[$x]'
		For $i = 2 To $iDimensions - 1
			$sTarghet &= '[' & GUICtrlRead($aSubscripts[$i][2]) & ']'
		Next
		$iColumns = UBound($_aInput, 2)
	EndIf
	For $y = 0 To $iRows - 1
		GUICtrlCreateListViewItem('', $idListview)
		_GUICtrlListView_SetItemText($idListview, $y, '[' & $y & ']', 0) ; row number
		For $x = 0 To $iColumns - 1
			Local $vCellContent = Execute($sTarghet)
			If IsArray($vCellContent) Then
				_GUICtrlListView_SetItemText($idListview, $y, '{array}', $x + 1)
			Else
				_GUICtrlListView_SetItemText($idListview, $y, $vCellContent, $x + 1)
			EndIf
		Next
	Next
	Opt('GUIOnEventMode', 0) ; reenable GUIGetMsg()
EndFunc   ;==>_ArrayDisplayByLayer

Func _ArrayTraverse(ByRef $aMyArray, ByRef $hTree, $hParent)
	#cs
		since this is a recursive Function, the same Func runs many times, self called from within itself.
		The variables declared as Global at the top of the script are able to be accessed from any instance of the function,
		whereas the variable declared (as Local) within the function may be different for each instance of the function.
	#ce
	If Not IsArray($aMyArray) Then Return SetError(1, 0, -1)
	; we have to know how many nested for-next loops we need
	; that is one loop for each dimension
	Local $iDimensions = UBound($aMyArray, 0) ; number of nested for-next loops
	Local $sArrayPointer = "$aMyArray", $sElement
	For $i = 0 To $iDimensions - 1
		$sArrayPointer &= '[$aLoops[' & $i & '][2]]'
	Next
	; -----------------------------------------------------------------------------------
	; This is a nested For-Next loops simulator with variable depth of nested loops
	; pass a 2D zero based array[n][3]
	; with as  many records as nested loops needed
	; as following:
	;
	; Example; For $i = start To end
	;                   -----    ---
	; [n][0] = Start value
	; [n][1] = End value
	; [n][2] = actual loop counter (at startup is = to Start value [n][0])
	;
	; --- Initializes custom nested For-Next loops --------------------------------------
	Local $aLoops[$iDimensions][3] ; nr of nested loops is $iDimensions
	For $i = 0 To $iDimensions - 1
		$aLoops[$i][0] = 0 ; Start value
		$aLoops[$i][1] = UBound($aMyArray, $i + 1) - 1 ; End value
		$aLoops[$i][2] = $aLoops[$i][0] ; actual loop counter
	Next
	; -----------------------------------------------------------------------------------
	Local $x, $vContent
	Do
		$vContent = Execute($sArrayPointer)
		If IsArray($vContent) Then
			; here there is a Nested array, populate the TreeView with a child element
			$sElement = ""
			For $i = 0 To $iDimensions - 1
				$sElement &= '[' & $aLoops[$i][2] & ']'
			Next
			Local $hNode = _GUICtrlTreeView_AddChild($hTree, $hParent, $sElement)

			; recursive call for this nested array to search if there are any further nested arrays
			_ArrayTraverse($vContent, $hTree, $hNode) ; <-- recursive call
		EndIf
		; -------------------------------------------------------------------------------
		$x = UBound($aLoops) - 1
		$aLoops[$x][2] += 1
		While ($aLoops[$x][2] > $aLoops[$x][1]) ; check if and which nested loops are out of bound
			$aLoops[$x][2] = $aLoops[$x][0] ;     reset the counter of this loop ($x)
			$x -= 1 ;                             check next outer nest
			If $x < 0 Then ExitLoop ;             if we have finished all nested loops then Exit
			$aLoops[$x][2] += 1 ;                 when a deeper loop complete, increment the outer one
		WEnd
	Until $x < 0 ; If no more nested loops then exit
EndFunc   ;==>_ArrayTraverse

; Tree Path to Subscript
Func _TreePathParser($Input)
	Local $sReturn = '$_aInput'
	Local $aSubArrays = StringSplit($Input, '|', 3)
	If UBound($aSubArrays) > 1 Then
		For $i = 1 To UBound($aSubArrays) - 1
			$sReturn &= $aSubArrays[$i]
			If $i < UBound($aSubArrays) - 1 Then $sReturn = '(' & $sReturn & ')'
		Next
	EndIf
	Return $sReturn
EndFunc   ;==>_TreePathParser

; this will allow the scrolling of window containing ComboBoxes (if number of Combo doesn't fit in window)
; see _GUIScrollBars_Init() in the Help of AutoIt
Func WM_HSCROLL($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $lParam
	Local $iScrollCode = BitAND($wParam, 0x0000FFFF)
	Local $iIndex = -1, $iCharX, $iPosX
	Local $iMin, $iMax, $iPage, $iPos, $iTrackPos
	For $x = 0 To UBound($__g_aSB_WindowInfo) - 1
		If $__g_aSB_WindowInfo[$x][0] = $hWnd Then
			$iIndex = $x
			$iCharX = $__g_aSB_WindowInfo[$iIndex][2]
			ExitLoop
		EndIf
	Next
	If $iIndex = -1 Then Return 0
	; ; Get all the horizontal scroll bar information
	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_HORZ)
	$iMin = DllStructGetData($tSCROLLINFO, "nMin")
	$iMax = DllStructGetData($tSCROLLINFO, "nMax")
	$iPage = DllStructGetData($tSCROLLINFO, "nPage")
	; Save the position for comparison later on
	$iPosX = DllStructGetData($tSCROLLINFO, "nPos")
	$iPos = $iPosX
	$iTrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")
	#forceref $iMin, $iMax
	Switch $iScrollCode
		Case $SB_LINELEFT ; user clicked left arrow
			DllStructSetData($tSCROLLINFO, "nPos", $iPos - 1)
		Case $SB_LINERIGHT ; user clicked right arrow
			DllStructSetData($tSCROLLINFO, "nPos", $iPos + 1)
		Case $SB_PAGELEFT ; user clicked the scroll bar shaft left of the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $iPos - $iPage)
		Case $SB_PAGERIGHT ; user clicked the scroll bar shaft right of the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $iPos + $iPage)
		Case $SB_THUMBTRACK ; user dragged the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $iTrackPos)
	EndSwitch
	; // Set the position and then retrieve it.  Due to adjustments
	; //   by Windows it may not be the same as the value set.
	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)
	;// If the position has changed, scroll the window and update it
	$iPos = DllStructGetData($tSCROLLINFO, "nPos")
	If ($iPos <> $iPosX) Then _GUIScrollBars_ScrollWindow($hWnd, $iCharX * ($iPosX - $iPos), 0)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_HSCROLL
#EndRegion _ArrayView