﻿
SetTitleMatchMode, 2


parameterValues := Array()
parameterValues["Численность_населения"] := ["низкая", "средняя", "высокая"] 
parameterValues["Площадь"] := ["малая", "средняя", "большая"] 
parameterValues["Климат"] := ["тропический","умеренный", "смешанный"]
parameterValues["Инфраструктура"] := ["хорошо_развита", "слабо_развита"]
parameterValues["Море"] := ["да", "нет"]
parameterValues["Горы"] := ["да", "нет"]
parameterValues["Качество_образования"] := ["низкое", "среднее", "высокое"]





APP_PATH := "E:\anies_\"
EXCEL_TABLE_NAME := "EXCEL71"

F5::main(true, 25) 
F6::main(false, 25)

;F6::getMenuItems()
F7::getTitleText()
;F6::chooseParameter(parameters)
F4::getResult()
F12::selectExcelTable()

main(title, count) {
	t := title
	arrayOfParameters := getCustomArrayOfParameters()
	for i, parameters in arrayOfParameters {
		launch(t, parameters)
		Sleep, 700

		t := false
	}
	n := count - arrayOfParameters.Count()
	Loop, % n 
	{
		parameters := getRandomParameters()
		launch(false, parameters)
	}
	MsgBox, Конец

}
; title - вывести заголовок в экселе, true или false
launch(title, parameters) {
	allParameters := []

	WinActivate, ANIES
	Send, {F9}
	
	;Sleep, 7000
	while not WinExist("Anies") {
	}
	WinActivate, Anies
	ControlFocus, OK, Anies

	;ControlFocus, OK, Anies
	if ErrorLevel {
		Sleep, 7000
		ControlFocus, OK, Anies
	}
	
	

	Send, {Enter}
	while not WinExist("Разделы") {
	}
	ControlFocus, Далее, Разделы
	Send, {Enter}
	
	while not WinExist("Найдено") {
		if WinExist("Вопрос"){
			allParameters.Push(chooseParameter(parameters))
		} 
	}
	orderOfParameters := getOrderOfParameters(allParameters)
	;debugPrintResult(orderOfParameters)


	WinActivate, ANIES
	Send, {F8}

	Sleep, 700
	result := getResult()
	facts := getFacts()
	
	;debugPrintResult(result[1])
	;debugPrintHypothesisOrder(result[2])
	;debugPrintResult(facts)
	if WinExist("Найдено") {
		WinClose, Найдено

	}

	selectExcelTable()
	if title {
		for i, e in orderOfParameters  
		{
			Send, %e%
			Send, {Tab}
			;Sleep, 50
		}
		for i, e in result[2] 
		{
			Send, %e%
			Send, {Tab}
			;Sleep, 50
		}
		Send, {Enter}
	}
	for i, e in orderOfParameters  
	{
		if facts[e] = {
			MsgBox, Такого параметра не существует
		}
		Send, % facts[e]
		Send, {Tab}
		;Sleep, 50
	}
	for i, e in result[2]  
	{
		if result[1][e] = {
			MsgBox, Такого параметра не существует
		}
		Send, % result[1][e]
		Send, {Tab}
		;Sleep, 50
	}
	Send, {Enter}

	
}


getOrderOfParameters(parameters) {
	order := []
	for index, element in parameters
	{
		for i, e in element[2] 
		{
			order.Push(e)
		}
	}

	
	return order
}


selectExcelTable() {
	global EXCEL_TABLE_NAME
	WinActivate, Excel
	ControlFocus, %EXCEL_TABLE_NAME%, Excel

}

getResult() {
	global APP_PATH
	
	result := {}
	order := []
	
	FileRead, text, %APP_PATH%\result.txt 
	if ErrorLevel {
		MsgBox, Ошибка при считывании файла результатов
		Exit
	}
	Loop, parse, text, "="
	{
		s := Trim(A_LoopField, "`r`n")
		tmp := []
   		Loop, parse, s, `n
		{	
			tmp[A_Index] := Trim(A_LoopField,"`r`n")
		}
		result[tmp[1]] := tmp[2]
		order.Push(tmp[1])
	} 
	
	order := sortArray(order)
	return [result, order]

}

getFacts() {
	global APP_PATH
	
	facts := {}
	
	FileRead, text, %APP_PATH%\facts.txt 
	if ErrorLevel {
		MsgBox, Ошибка при считывании файла результатов
		Exit
	}
	Loop, parse, text, "="
	{
		s := Trim(A_LoopField, "`r`n")
		tmp := []
   		Loop, parse, s, `n
		{	
			tmp[A_Index] := Trim(A_LoopField,"`r`n")
		}
		facts[tmp[1]] := tmp[2]
	} 
	return facts


}

debugPrintResult(result) {
	for index, element in result
	{
		MsgBox, % "." index ":" element "." 
	}

}

debugPrintHypothesisOrder(order) {
	for index, element in order
	{
		MsgBox, % "." index ". : ." element "." 
	}

}


chooseParameter(parameters) {
	SetControlDelay, 700
	if not WinExist("Вопрос") {
		MsgBox, окна Вопрос не существует
		Exit
	}
	WinActivate, Вопрос
	title := getTitleText()
	menuValues := getMenuValues()
	

	if(parameters[title] = ) {
		MsgBox, Такого параметра нет
		Exit
	}
	values := parameters[title]["values"]
	confidence := parameters[title]["confidence"]
	if(values = ) {
		MsgBox, Значения параметра не заданы
		Exit
	}
	if(values = ) {
		MsgBox, Значение уверенности не задано
		Exit
	}
	setMenuItems(values)
	setTrackBar(confidence)
	ControlFocus, все, Вопрос
	Sleep, 200
	Send, {Enter}	

	return [title, menuValues]
}

setMenuItems(values) {
	for index, value in values
	{
		setMenuItem(value)
	}
}

setMenuItem(value) {
	items := getMenuItems()
	ControlFocus, TCheckListBox1, Вопрос
	Control, Choose, % items[value], TCheckListBox1, Вопрос
	Send, {Space}
}

getMenuValues() {
	ControlGet, list, List, ,TCheckListBox1, Вопрос
   	values := []
	Loop, Parse, list, `n, 
	{
		values.Push(A_LoopField)

	}
	return values
}

getMenuItems() {
	ControlGet, list, List, ,TCheckListBox1, Вопрос
   	map := {}
	Loop, Parse, list, `n, 
	{
		map[A_LoopField] := A_Index

	}
	return map
}

getTitleText() {
	ControlGetText, text, TEdit2, Вопрос
	return text
}

setTrackBar(n) {
	ControlFocus, TTrackBar1, Вопрос
	value := 0
	while Abs(value) < Abs(n) and value <= 1 and value >=-1 {
		if (n > 0) {
			Send, {right}
			value +=  0.05
		} else {	
			Send, {left}
			value -=  0.05
		}
	}
	

}



sortArray(arr,options="") {	; specify only "Flip" in the options to reverse otherwise unordered array items

	if	!IsObject(arr)
		return	0
	new :=	[]
	if	(options="Flip") {
		While	(i :=	arr.MaxIndex()-A_Index+1)
			new.Insert(arr[i])
		return	new
	}
	For each, item in arr
		list .=	item "`n"
	list :=	Trim(list,"`n")
	Sort, list, %options%
	Loop, parse, list, `n, `r
		new.Insert(A_LoopField)
	return	new

}



getRandomParameters() {
	parameters := Array()
	global parameterValues
	for k, v in parameterValues 
	{
		
		count := v.Count()
		Random, a, 1, count	
		Random, b, 2, 20
		c := Round(b*0.05, 2) 
		;MsgBox, % c
		parameters[k] := {"values": [v[a]],"confidence": c}
		;parameters[k]["values"] := [v[a]]
		;parameters[k]["confidence"] := b*0.05
  		
	}

	;for k, v in parameters
	;{
	;	MsgBox, % k
	;}
	return parameters
}






getCustomArrayOfParameters() {
	p1 := Array()
	p1["Численность_населения"] := {"values": ["высокая"], "confidence": 0.9}
	p1["Площадь"] := {"values": ["большая"], "confidence": 0.8}
	p1["Климат"] := {"values": ["смешанный"], "confidence": 0.8}
	p1["Инфраструктура"] := {"values": ["хорошо_развита"], "confidence": 0.9}
	p1["Море"] := {"values": ["да"], "confidence": 0.7}
	p1["Горы"] := {"values": ["да"], "confidence": 0.9}
	p1["Качество_образования"] := {"values": ["среднее"], "confidence": 0.7}
	

	return []
}

