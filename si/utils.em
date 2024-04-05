/*******************************************************************************  
* Copyright (C), 2000-2010, Electronic Technology Co., Ltd.  
* �ļ���: utils.em  
* ��  ��: ����  
* ��  ��: 0.1 
* ��  ��: 2010-3-12
*******************************************************************************/  
  
/*******************************************************************************  
* ��������: InsertSysTime  
* ˵��:     ���뵱ǰϵͳʱ��  
* �������: ��   
* �������: ��  
* ����ֵ:   ��  
* ����:     ʱ���ʽ�磺2010-3-12 9:42:44  
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
* ��������: InsertFileHeader  
* ˵��:     �ڵ�ǰ�ļ��ϲ����ļ�ͷע��  
*******************************************************************************/  
macro InsertFileHeader()   
{   
    hbuf = GetCurrentBuf()   
  
    ProgEnvInfo = GetProgramEnvironmentInfo ()   
    Author = "�� ��"	//ProgEnvInfo.UserName   
  
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
    InsBufLine(hbuf, lnFirst++, "* �ļ���:	@FileName@")   
    InsBufLine(hbuf, lnFirst++, "* ��  ��:	@Author@")   
    InsBufLine(hbuf, lnFirst++, "* ��  ��:")   
    InsBufLine(hbuf, lnFirst++, "* ��  ��:	@Year@-@Month@-@Day@     //�������")   
    InsBufLine(hbuf, lnFirst++, "* ˵  ��:		// ������ϸ˵���˳����ļ���ɵ���Ҫ���ܣ�������ģ��")   
    InsBufLine(hbuf, lnFirst++, "*                  	// �����Ľӿڣ����ֵ��ȡֵ��Χ�����弰������Ŀ�")   
    InsBufLine(hbuf, lnFirst++, "*                  	// �ơ�˳�򡢶����������ȹ�ϵ")   
    InsBufLine(hbuf, lnFirst++, "* �޶���ʷ:		// �޸���ʷ��¼�б�ÿ���޸ļ�¼Ӧ�����޸����ڡ��޸�")   
    InsBufLine(hbuf, lnFirst++, "*				// �߼��޸����ݼ���")   
    InsBufLine(hbuf, lnFirst++, "*    1. ʱ��:		@Year@-@Month@-@Day@")   
    InsBufLine(hbuf, lnFirst++, "*       �޶���:	@Author@")   
    InsBufLine(hbuf, lnFirst++, "*       �޶�����:	����")   
    InsBufLine(hbuf, lnFirst++, "*    2.")   
    InsBufLine(hbuf, lnFirst++, "* ����:			// �������ݵ�˵��")   
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
        Editor = "�� ��"		//ProgEnvInfo.UserName   
  
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
* ��������: InsertFunctionHeader  
* ˵��:     ���뺯����ͷע��  
*******************************************************************************/  
macro InsertFunctionHeader()   
{   
    hbuf = GetCurrentBuf()   
    lnFirst = GetBufLnCur(hbuf)   
    FuncName = GetCurSymbol()
    InsBufLine(hbuf, lnFirst++, "/*******************************************************************************")   
    InsBufLine(hbuf, lnFirst++, "* ��������:	@FuncName@")   
    InsBufLine(hbuf, lnFirst++, "* ��������:")   
    InsBufLine(hbuf, lnFirst++, "* �������:")   
    InsBufLine(hbuf, lnFirst++, "*			")   
    InsBufLine(hbuf, lnFirst++, "* �������:")   
    InsBufLine(hbuf, lnFirst++, "* ����ֵ:")   
    InsBufLine(hbuf, lnFirst++, "* ����:")   
    InsBufLine(hbuf, lnFirst++, "*******************************************************************************/")   
  
    SaveBuf (hbuf)   
}

// ����˫�ֽ��ַ�
macro SuperCursorLeft()
{
	//// moveleft
	hwnd = GetCurrentWnd();
	hbuf = GetCurrentBuf();
	if (hbuf == 0)
	        stop;   // empty buffer
	        
	ln = GetBufLnCur(hbuf); 
	ipos = GetWndSelIchFirst(hwnd);

	if(GetBufSelText(hbuf) != "" || (ipos == 0 && ln == 0))   // ��0�л�����ѡ������,���ƶ�
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
	pos = GetWndSelIchFirst(hwnd);	//��ǰλ��
	ln = GetBufLnCur(hbuf);		//��ǰ����
	text = GetBufLine(hbuf, ln);	//�õ���ǰ��
	len = strlen(text);		//�õ���ǰ�г���
	//��ͷ���㺺���ַ��ĸ���
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

		if(GetBufSelText(hbuf) != "" || (ipos == 0 && ln == 0))   // ��0�л�����ѡ������,���ƶ�
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

	if(GetBufSelText(hbuf) != "")   //ѡ������
	{
	   ipos = GetWndSelIchLim(hwnd);
	   ln = GetWndSelLnLast(hwnd);
	   SetBufIns(hbuf, ln, ipos); 
	   stop;
	}

	if(ipos == strlen(text)-1 && ln == totalLn-1) // ĩ�� 
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
	pos = GetWndSelIchFirst(hwnd);	//��ǰλ��
	ln = GetBufLnCur(hbuf);		//��ǰ����
	text = GetBufLine(hbuf, ln);	//�õ���ǰ��
	len = strlen(text);		//�õ���ǰ�г���
	//��ͷ���㺺���ַ��ĸ���
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

		if(GetBufSelText(hbuf) != "")   //ѡ������
		{
		   ipos = GetWndSelIchLim(hwnd);
		   ln = GetWndSelLnLast(hwnd);
		   SetBufIns(hbuf, ln, ipos); 
		   stop;
		}

		if(ipos == strlen(text)-1 && ln == totalLn-1) // ĩ�� 
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

	// �ļ�������ʱ������
	strFileExt = NewBuf("strFileExtBuf")
	ClearBuf(strFileExt)
	
	// ͷ�ļ�
	index_hpp_begin = 0 								// ͷ�ļ���ʼ����
	AppendBufLine(strFileExt, ".h")
	AppendBufLine(strFileExt, ".hpp")
	AppendBufLine(strFileExt, ".hxx")
	index_hpp_end = GetBufLineCount(strFileExt) 		// ͷ�ļ���������
	
	// Դ�ļ�
	index_cpp_begin = index_hpp_end 					// Դ�ļ���ʼ����
	AppendBufLine(strFileExt, ".c")
	AppendBufLine(strFileExt, ".cpp")
	AppendBufLine(strFileExt, ".cc")
	AppendBufLine(strFileExt, ".cx")
	AppendBufLine(strFileExt, ".cxx")
	index_cpp_end = GetBufLineCount(strFileExt)			// Դ�ļ���������

	curOpenFileName = GetBufName(hCurOpenBuf)
	curOpenFileName = ParseFilenameWithExt(curOpenFileName) 	// ��ò�����·�����ļ���
	curOpenFileNameWithoutExt = ParseFilenameWithoutExt(curOpenFileName)
	curOpenFileNameLen = strlen(curOpenFileName)
	//Msg(cat("current opened no ext filename:", curOpenFileNameWithoutExt))

	isCppFile = 0 										// 0��δ֪ 1��ͷ�ļ� 2��Դ�ļ���Ĭ��δ֪��չ��
	curOpenFileExt = "" 								// ��ǰ���ļ�����չ��
	index = index_hpp_begin 
	// �����ļ����ж��ļ�����
	while(index < index_cpp_end)	
	{
		curExt = GetBufLine(strFileExt, index) 
		if(isFileType(curOpenFileName, curExt) == True)// ƥ��ɹ�
		{
			if (index < index_hpp_end)
				isCppFile = 1 							// ��ǰ���ļ���ͷ�ļ�
			else
				isCppFile = 2 							// Դ�ļ�
			break 
		}
		index = index + 1 
	}// while(index < index_cpp_end)
	
	// ����
	// AppendBufLine(debugBuf, isCppFile)

	index_replace_begin = index_hpp_begin 
	index_replace_end = index_hpp_end 
	
	if (isCppFile == 1)									// ��ǰ���ļ���ͷ�ļ�			
	{
		index_replace_begin = index_cpp_begin 
		index_replace_end = index_cpp_end 
	}
	else if(isCppFile == 2)								// ��ǰ���ļ���Դ�ļ�
	{
		index_replace_begin = index_hpp_begin 
		index_replace_end = index_hpp_end 
	}
	else												// δ֪����
	{
		index_replace_begin = 9999 					
		index_replace_end = index_replace_begin 		// ����ѭ������ִ��
	}
	
	index = index_replace_begin 
	while(index < index_replace_end)
	{
		destExt = GetBufLine(strFileExt, index) 
		// ���Ե�ǰĿ����չ���Ƿ��ܹ���
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
			//Msg("��ʧ��")
		}
	
		index = index + 1 
	}
	CloseBuf(strFileExt)							// �رջ�����
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