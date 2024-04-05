/*******************************************************************************  
* Copyright (C), 2000-2010, Electronic Technology Co., Ltd.  
* 文件名: utils.em  
* 作  者: 张垒  
* 版  本: 0.1 
* 日  期: 2010-3-12
*******************************************************************************/  
  
/*******************************************************************************  
* 函数名称: InsertSysTime  
* 说明:     插入当前系统时间  
* 输入参数: 无   
* 输出参数: 无  
* 返回值:   无  
* 其它:     时间格式如：2010-3-12 9:42:44  
*******************************************************************************/  
macro InsertSysTime()   
{   
    hbufCur = GetCurrentBuf();   
    LocalTime = GetSysTime(1)   
  
    Year = LocalTime.Year   
    Month = LocalTime.Month   
    Day = LocalTime.Day   
    Time = LocalTime.time   
  
    SetBufSelText (hbufCur, "@Year@-@Month@-@Day@ @Time@")   
}   
  
/*******************************************************************************  
* 函数名称: InsertFileHeader  
* 说明:     在当前文件上插入文件头注释  
*******************************************************************************/  
macro InsertFileHeader()   
{   
    hbuf = GetCurrentBuf()   
  
    ProgEnvInfo = GetProgramEnvironmentInfo ()   
    Author = "张 垒"	//ProgEnvInfo.UserName   
  
    LocalTime = GetSysTime(1)   
    Year = LocalTime.Year   
    Month = LocalTime.Month   
    Day = LocalTime.Day   
  
    szBufName = GetBufName (hbuf)   
    Len = strlen(szBufName)   
    FileName = ""  
    if( 0 != Len)   
    {   
        cch = Len   
        while ("\\" !=  szBufName[cch])   
        {   
            cch = cch - 1   
        }   
  
        while(cch < Len)   
        {   
            cch = cch + 1   
            FileName = Cat(FileName, szBufName[cch])   
        }   
    }   
  
    lnFirst = 0   
    InsBufLine(hbuf, lnFirst++, "/*******************************************************************************")   
    InsBufLine(hbuf, lnFirst++, "* Copyright (C), 2010-@Year@,  Electronic Technology Co., Ltd.")   
    InsBufLine(hbuf, lnFirst++, "* 文件名:	@FileName@")   
    InsBufLine(hbuf, lnFirst++, "* 作  者:	@Author@")   
    InsBufLine(hbuf, lnFirst++, "* 版  本:")   
    InsBufLine(hbuf, lnFirst++, "* 日  期:	@Year@-@Month@-@Day@     //完成日期")   
    InsBufLine(hbuf, lnFirst++, "* 说  明:		// 用于详细说明此程序文件完成的主要功能，与其他模块")   
    InsBufLine(hbuf, lnFirst++, "*                  	// 或函数的接口，输出值、取值范围、含义及参数间的控")   
    InsBufLine(hbuf, lnFirst++, "*                  	// 制、顺序、独立或依赖等关系")   
    InsBufLine(hbuf, lnFirst++, "* 修订历史:		// 修改历史记录列表，每条修改记录应包括修改日期、修改")   
    InsBufLine(hbuf, lnFirst++, "*				// 者及修改内容简述")   
    InsBufLine(hbuf, lnFirst++, "*    1. 时间:		@Year@-@Month@-@Day@")   
    InsBufLine(hbuf, lnFirst++, "*       修订者:	@Author@")   
    InsBufLine(hbuf, lnFirst++, "*       修订内容:	创建")   
    InsBufLine(hbuf, lnFirst++, "*    2.")   
    InsBufLine(hbuf, lnFirst++, "* 其它:			// 其它内容的说明")   
    InsBufLine(hbuf, lnFirst++, "*******************************************************************************/")   
  
    SetBufIns (hbuf, lnFirst,0)   
    Len = strlen(FileName)   
    if(("h" == tolower(FileName[Len-1])) && ("." == FileName[Len-2]))   
    {   
        FileName = toupper(FileName)   
        FileName[Len-2] = "_"  
        szDef = "_"  
        szDef = Cat(szDef,FileName)   
        szDef = Cat(szDef,"_")   
  
        ProgEnvInfo = GetProgramEnvironmentInfo ()   
        Editor = "张 垒"		//ProgEnvInfo.UserName   
  
        hwnd = GetCurrentWnd()   
        lnFirst = GetWndSelLnFirst(hwnd)   
        LocalTime = GetSysTime(1)   
  
        Year = LocalTime.Year   
        Month = LocalTime.Month   
        Day = LocalTime.Day   
        Time = LocalTime.time   
        hbuf = GetCurrentBuf()   
        InsBufLine(hbuf,lnFirst++,"#ifndef @szDef@")   
        InsBufLine(hbuf,lnFirst++,"#define @szDef@")   
        InsBufLine(hbuf,lnFirst++,"")   
        InsBufLine(hbuf,lnFirst++,"")   
        InsBufLine(hbuf,lnFirst++,"")   
        InsBufLine(hbuf,lnFirst++,"#endif /* ifndef @szDef@.@Year@-@Month@-@Day@ @Time@ @Editor@ */")   
    }   
    SaveBuf (hbuf)   
}   
  
/*******************************************************************************  
* 函数名称: InsertFunctionHeader  
* 说明:     插入函数的头注释  
*******************************************************************************/  
macro InsertFunctionHeader()   
{   
    hbuf = GetCurrentBuf()   
    lnFirst = GetBufLnCur(hbuf)   
    FuncName = GetCurSymbol()
    InsBufLine(hbuf, lnFirst++, "/*******************************************************************************")   
    InsBufLine(hbuf, lnFirst++, "* 函数名称:	@FuncName@")   
    InsBufLine(hbuf, lnFirst++, "* 函数功能:")   
    InsBufLine(hbuf, lnFirst++, "* 输入参数:")   
    InsBufLine(hbuf, lnFirst++, "*			")   
    InsBufLine(hbuf, lnFirst++, "* 输出参数:")   
    InsBufLine(hbuf, lnFirst++, "* 返回值:")   
    InsBufLine(hbuf, lnFirst++, "* 其它:")   
    InsBufLine(hbuf, lnFirst++, "*******************************************************************************/")   
  
    SaveBuf (hbuf)   
}

// 兼容双字节字符
macro SuperCursorLeft()
{
	//// moveleft
	hwnd = GetCurrentWnd();
	hbuf = GetCurrentBuf();
	if (hbuf == 0)
	        stop;   // empty buffer
	        
	ln = GetBufLnCur(hbuf); 
	ipos = GetWndSelIchFirst(hwnd);

	if(GetBufSelText(hbuf) != "" || (ipos == 0 && ln == 0))   // 第0行或者是选中文字,则不移动
	{
	   SetBufIns(hbuf, ln, ipos); 
	   stop;
	}
	  
	if(ipos == 0) 
	{
	   preLine = GetBufLine(hbuf, ln-1);
	   SetBufIns(hBuf, ln-1, strlen(preLine)-1);
	}
	else 
	{
	   SetBufIns(hBuf, ln, ipos-1); 
	}

	///// IsComplexCharacter
	pos = GetWndSelIchFirst(hwnd);	//当前位置
	ln = GetBufLnCur(hbuf);		//当前行数
	text = GetBufLine(hbuf, ln);	//得到当前行
	len = strlen(text);		//得到当前行长度
	//从头计算汉字字符的个数
	ret = 0;
	if(pos > 0) 
	{
	   i=pos;
	   count=0;
	   while(AsciiFromChar(text[i-1]) >= 160)
	   {  
	    i = i - 1;
	    count = count+1;
	    if(i == 0)  
	     break;
	   }
	   if((count/2)*2!=count && count!=0)
			ret = 1;
	}

	if (ret)
	{
		//// moveleft
		hwnd = GetCurrentWnd();
		hbuf = GetCurrentBuf();
		if (hbuf == 0)
		        stop;   // empty buffer
		        
		ln = GetBufLnCur(hbuf); 
		ipos = GetWndSelIchFirst(hwnd);

		if(GetBufSelText(hbuf) != "" || (ipos == 0 && ln == 0))   // 第0行或者是选中文字,则不移动
		{
		   SetBufIns(hbuf, ln, ipos); 
		   stop;
		}
		  
		if(ipos == 0) 
		{
		   preLine = GetBufLine(hbuf, ln-1);
		   SetBufIns(hBuf, ln-1, strlen(preLine)-1);
		}
		else 
		{
		   SetBufIns(hBuf, ln, ipos-1); 
		}
	}
}

macro SuperCursorRight()
{
	//// moveright
	hwnd = GetCurrentWnd();
	hbuf = GetCurrentBuf();
	if (hbuf == 0)
	        stop;   // empty buffer
	ln = GetBufLnCur(hbuf); 
	ipos = GetWndSelIchFirst(hwnd);
	totalLn = GetBufLineCount(hbuf); 
	text = GetBufLine(hbuf, ln);  

	if(GetBufSelText(hbuf) != "")   //选中文字
	{
	   ipos = GetWndSelIchLim(hwnd);
	   ln = GetWndSelLnLast(hwnd);
	   SetBufIns(hbuf, ln, ipos); 
	   stop;
	}

	if(ipos == strlen(text)-1 && ln == totalLn-1) // 末行 
	   stop;      

	if(ipos == strlen(text)) 
	{ 
	   SetBufIns(hBuf, ln+1, 0);
	}
	else 
	{
	   SetBufIns(hBuf, ln, ipos+1); 
	}

	///// IsComplexCharacter
	pos = GetWndSelIchFirst(hwnd);	//当前位置
	ln = GetBufLnCur(hbuf);		//当前行数
	text = GetBufLine(hbuf, ln);	//得到当前行
	len = strlen(text);		//得到当前行长度
	//从头计算汉字字符的个数
	ret = 0;
	if(pos > 0) 
	{
	   i=pos;
	   count=0;
	   while(AsciiFromChar(text[i-1]) >= 160)
	   {  
	    i = i - 1;
	    count = count+1;
	    if(i == 0)  
	     break;
	   }
	   if((count/2)*2!=count && count!=0)
			ret = 1;
	}

	if (ret)
	{
		//// moveright
		hwnd = GetCurrentWnd();
		hbuf = GetCurrentBuf();
		if (hbuf == 0)
		        stop;   // empty buffer
		ln = GetBufLnCur(hbuf); 
		ipos = GetWndSelIchFirst(hwnd);
		totalLn = GetBufLineCount(hbuf); 
		text = GetBufLine(hbuf, ln);  

		if(GetBufSelText(hbuf) != "")   //选中文字
		{
		   ipos = GetWndSelIchLim(hwnd);
		   ln = GetWndSelLnLast(hwnd);
		   SetBufIns(hbuf, ln, ipos); 
		   stop;
		}

		if(ipos == strlen(text)-1 && ln == totalLn-1) // 末行 
		   stop;      

		if(ipos == strlen(text)) 
		{ 
		   SetBufIns(hBuf, ln+1, 0);
		}
		else 
		{
		   SetBufIns(hBuf, ln, ipos+1); 
		}
	}
}

macro SwitchCppAndHpp()
{
	hwnd = GetCurrentWnd()
	hCurOpenBuf = GetCurrentBuf()
	if (hCurOpenBuf == 0)// empty buffer
		stop 

	// 文件类型临时缓冲区
	strFileExt = NewBuf("strFileExtBuf")
	ClearBuf(strFileExt)
	
	// 头文件
	index_hpp_begin = 0 								// 头文件开始索引
	AppendBufLine(strFileExt, ".h")
	AppendBufLine(strFileExt, ".hpp")
	AppendBufLine(strFileExt, ".hxx")
	index_hpp_end = GetBufLineCount(strFileExt) 		// 头文件结束索引
	
	// 源文件
	index_cpp_begin = index_hpp_end 					// 源文件开始索引
	AppendBufLine(strFileExt, ".c")
	AppendBufLine(strFileExt, ".cpp")
	AppendBufLine(strFileExt, ".cc")
	AppendBufLine(strFileExt, ".cx")
	AppendBufLine(strFileExt, ".cxx")
	index_cpp_end = GetBufLineCount(strFileExt)			// 源文件结束索引

	curOpenFileName = GetBufName(hCurOpenBuf)
	curOpenFileName = ParseFilenameWithExt(curOpenFileName) 	// 获得不包括路径的文件名
	curOpenFileNameWithoutExt = ParseFilenameWithoutExt(curOpenFileName)
	curOpenFileNameLen = strlen(curOpenFileName)
	//Msg(cat("current opened no ext filename:", curOpenFileNameWithoutExt))

	isCppFile = 0 										// 0：未知 1：头文件 2：源文件，默认未知扩展名
	curOpenFileExt = "" 								// 当前打开文件的扩展名
	index = index_hpp_begin 
	// 遍历文件，判断文件类型
	while(index < index_cpp_end)	
	{
		curExt = GetBufLine(strFileExt, index) 
		if(isFileType(curOpenFileName, curExt) == True)// 匹配成功
		{
			if (index < index_hpp_end)
				isCppFile = 1 							// 当前打开文件是头文件
			else
				isCppFile = 2 							// 源文件
			break 
		}
		index = index + 1 
	}// while(index < index_cpp_end)
	
	// 调试
	// AppendBufLine(debugBuf, isCppFile)

	index_replace_begin = index_hpp_begin 
	index_replace_end = index_hpp_end 
	
	if (isCppFile == 1)									// 当前打开文件是头文件			
	{
		index_replace_begin = index_cpp_begin 
		index_replace_end = index_cpp_end 
	}
	else if(isCppFile == 2)								// 当前打开文件是源文件
	{
		index_replace_begin = index_hpp_begin 
		index_replace_end = index_hpp_end 
	}
	else												// 未知类型
	{
		index_replace_begin = 9999 					
		index_replace_end = index_replace_begin 		// 下面循环不会执行
	}
	
	index = index_replace_begin 
	while(index < index_replace_end)
	{
		destExt = GetBufLine(strFileExt, index) 
		// 尝试当前目标扩展名是否能够打开
		destFilename = AddFilenameExt(curOpenFileNameWithoutExt, destExt)
		//Msg(destFilename)
		hCurOpenBuf = OpenBuf(destFilename)
		if(hCurOpenBuf != hNil)
		{
			SetCurrentBuf(hCurOpenBuf)
			break 
		}
		else
		{
			//Msg("打开失败")
		}
	
		index = index + 1 
	}
	CloseBuf(strFileExt)							// 关闭缓冲区
}
macro ParseFilenameWithExt(longFilename)
{
	shortFilename = longFilename
	len = strlen(longFilename)-1
	if(len > 0)
	{
		while(True)
		{
			if(strmid(longFilename, len, len+1) == "\\")
				break

			len = len - 1
			if(len <= 0)
				break 
		}
	}
	shortFilename = strmid(longFilename, len+1, strlen(longFilename))
	
	return shortFilename
}
macro ParseFilenameWithoutExt(longFilename)
{
	shortFilename = longFilename
	len = strlen(longFilename)
	dotPos = len
	if(len > 0)
	{
		while(True)
		{
			len = len - 1
			if(strmid(longFilename, len, len+1) == ".")
			{
				dotPos = len
				break
			}
			if(len <= 0)
				break 
		}
	}
	shortFilename = strmid(longFilename, 0, dotPos)
	
	return shortFilename
}
macro AddFilenameExt(filename, ext)
{
	return cat(filename, ext)
}
macro isFileType(shortFilename, ext)
{
	extLen = strlen(ext)
	lastExtFilename = strmid(shortFilename, strlen(shortFilename)-extLen, strlen(shortFilename))
	if(toupper(lastExtFilename) == toupper(ext))
		return True

	return False
}