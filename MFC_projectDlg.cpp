
// MFC_projectDlg.cpp : implementation file
//

#include "stdafx.h"
#include "MFC_project.h"
#include "MFC_projectDlg.h"
#include "afxdialogex.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CMFC_projectDlg dialog




CMFC_projectDlg::CMFC_projectDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CMFC_projectDlg::IDD, pParent)
	, REDvalue(0)
	, GREENvalue(0)
	, BLUEvalue(0)
	
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CMFC_projectDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_R_SLIDER, REDCtrl);
	DDX_Slider(pDX, IDC_R_SLIDER, REDvalue);
	DDX_Control(pDX, IDC_G_SLIDER, GREENCtrl);
	DDX_Slider(pDX, IDC_G_SLIDER, GREENvalue);
	DDX_Control(pDX, IDC_B_SLIDER, BLUECtrl);
	DDX_Slider(pDX, IDC_B_SLIDER, BLUEvalue);
	DDX_Control(pDX, IDC_BMP, m_BMP_Ctrl);
	DDX_Control(pDX, IDC_createVid, Create_vid);
	DDX_Control(pDX, IDC_Freeze, Freeze_vid);
	
}

BEGIN_MESSAGE_MAP(CMFC_projectDlg, CDialogEx)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_CREATE_BMP, &CMFC_projectDlg::OnBnClickedCreateBmp)
	ON_WM_HSCROLL()
	ON_WM_TIMER()
	ON_BN_CLICKED(IDC_createVid, &CMFC_projectDlg::OnBnClickedcreatevid)
	ON_BN_CLICKED(IDC_Freeze, &CMFC_projectDlg::OnBnClickedFreeze)
	ON_BN_CLICKED(IDC_Save_img, &CMFC_projectDlg::OnBnClickedSaveimg)
	ON_BN_CLICKED(IDC_Mea_pre, &CMFC_projectDlg::OnBnClickedMeapre)
END_MESSAGE_MAP()


// CMFC_projectDlg message handlers

BOOL CMFC_projectDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();


	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	

	// TODO: Add extra initialization here
	hdc		= 0;
	MemDc	= 0;
	hBitmap = 0;

	ImageWidth	= 512;
	ImageHeight = 512;
	channelCount= 3;
	pixels	= NULL;

	REDvalue	= 0;
	GREENvalue	= 0;
	BLUEvalue	= 0;
	
	REDCtrl.SetRange(0,255,TRUE);
	REDCtrl.SetPos(0);

	GREENCtrl.SetRange(0, 255, TRUE);
	GREENCtrl.SetPos(0);

	BLUECtrl.SetRange(0, 255, TRUE);
	BLUECtrl.SetPos(0);

	UpdateData(FALSE);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CMFC_projectDlg::OnPaint()
{

		if (!hdc)	//Make this only once
	{
		pWnd = GetDlgItem(IDC_BMP);
		hdc = ::GetDC(pWnd->m_hWnd);
		MemDc = CreateCompatibleDC(hdc);
	}

	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CMFC_projectDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}



void CMFC_projectDlg::OnBnClickedCreateBmp()
{
	// TODO: Add your control notification handler code here

	if (!pixels) // if Array of bytes was not already dynamically allocated before..FIRST TIME ONLY
	{
		//Full size = width x height x Number of bytes for each pixel
		pixels = new BYTE[ImageWidth* ImageHeight * channelCount];

		//Fill array with zeros
		memset(pixels, 0, ImageWidth* ImageHeight * channelCount);

	}
	
	for (int i = 0; i < ImageWidth * ImageHeight; i++)
	{
		// BGR (not RGB) image.
		pixels[(i*channelCount) + 0] = BLUEvalue;       
		pixels[(i*channelCount) + 1] = GREENvalue;
		pixels[(i*channelCount) + 2] = REDvalue;	
	}

	//File Header
	BITMAPINFOHEADER bmih;
	bmih.biSize = sizeof(BITMAPINFOHEADER);
	bmih.biWidth = ImageWidth;
	bmih.biHeight = ImageHeight;
	bmih.biPlanes = 1;//Must be = 1;
	bmih.biBitCount = 8 * channelCount;
	bmih.biCompression = BI_RGB;

	BITMAPINFO dbmi;
	ZeroMemory(&dbmi, sizeof(dbmi));
	dbmi.bmiHeader = bmih;

	hBitmap = CreateDIBitmap(hdc, &bmih, CBM_INIT, pixels, &dbmi, DIB_RGB_COLORS);
	if (hBitmap == NULL) 
	{
		MessageBox(_T("Could not Create image"));
		return;
	}

	SelectObject(MemDc, hBitmap);
	BitBlt(hdc, 0, 0, ImageWidth, ImageHeight, MemDc, 0, 0, SRCCOPY);

}


void CMFC_projectDlg::OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
	// TODO: Add your message handler code here and/or call default
	OnBnClickedCreateBmp();
	
		CDialogEx::OnHScroll(nSBCode, nPos, pScrollBar);

	

}


void CMFC_projectDlg::OnTimer(UINT_PTR nIDEvent)
{
	// TODO: Add your message handler code here and/or call default

	CDialogEx::OnTimer(nIDEvent);
	UpdateData(true);
	OnBnClickedcreatevid();
		BLUEvalue=BLUEvalue+1;
		REDvalue=REDvalue+1;
	
	
UpdateData(false);

}



void CMFC_projectDlg::OnBnClickedcreatevid()
{
	// TODO: Add your control notification handler code here

		if (!pixels) // if Array of bytes was not already dynamically allocated before..FIRST TIME ONLY
	{
		//Full size = width x height x Number of bytes for each pixel
		pixels = new BYTE[ImageWidth* ImageHeight * channelCount];

		//Fill array with zeros
		memset(pixels, 0, ImageWidth* ImageHeight * channelCount);

	}
	
	for (int i = 0; i < ImageWidth * ImageHeight; i++)
	{
		// BGR (not RGB) image.
		pixels[(i*channelCount) + 0] = BLUEvalue;       
		pixels[(i*channelCount) + 1] = GREENvalue;
		pixels[(i*channelCount) + 2] = REDvalue;	
	}

	//File Header
	BITMAPINFOHEADER bmih;
	bmih.biSize = sizeof(BITMAPINFOHEADER);
	bmih.biWidth = ImageWidth;
	bmih.biHeight = ImageHeight;
	bmih.biPlanes = 1;//Must be = 1;
	bmih.biBitCount = 8 * channelCount;
	bmih.biCompression = BI_RGB;

	BITMAPINFO dbmi;
	ZeroMemory(&dbmi, sizeof(dbmi));
	dbmi.bmiHeader = bmih;

	hBitmap = CreateDIBitmap(hdc, &bmih, CBM_INIT, pixels, &dbmi, DIB_RGB_COLORS);
	if (hBitmap == NULL) 
	{
		MessageBox(_T("Could not Create image"));
		return;
	}

	SelectObject(MemDc, hBitmap);
	BitBlt(hdc, 0, 0, ImageWidth, ImageHeight, MemDc, 0, 0, SRCCOPY);

	SetTimer (1,50,NULL);	

}


void CMFC_projectDlg::OnBnClickedFreeze()
{
	// TODO: Add your control notification handler code here
	KillTimer(1);
}

void CMFC_projectDlg::OnBnClickedSaveimg()
{
	// TODO: Add your control notification handler code here
	
	CString FileTypeFilters = _T("Image Files (*.bmp)|*.bmp|All Files (*.*)|*.*||");

	CFileDialog SaveFileDlg(FALSE, _T(".bmp"), _T("MyImage"), OFN_OVERWRITEPROMPT, FileTypeFilters);

	if (SaveFileDlg.DoModal() == IDOK)
	{
		CString ImagePath;
		ImagePath = SaveFileDlg.GetPathName();

		image.Attach(hBitmap);
		image.Save(ImagePath, Gdiplus::ImageFormatBMP);
		AfxMessageBox(_T("Image Saved"));
	
}
}



void CMFC_projectDlg::OnBnClickedMeapre()
{
	// TODO: Add your control notification handler code here
	unsigned int Last = 0;
	unsigned int Now = 0;
	unsigned int sum=0;
	Last = GetTickCount();
	for (int i =0;i<1000;i++)
		sum=sum+1;
	Now = GetTickCount();
	CString Msg;
	Msg.Format(_T("Elapsed Time in Milliseconds: %i",(Now-Last)));
	MessageBox(Msg);
}
