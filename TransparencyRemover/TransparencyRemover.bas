B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.9
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private AffixTextField As TextField
	Private FilesListView As ListView
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(files As List)
	frm.Initialize("frm", 600, 250)
	frm.RootPane.LoadLayout("TransparencyRemover")
	FilesListView.Items.AddAll(files)
End Sub

Public Sub show
	frm.Show
End Sub

Private Sub ConvertButton_MouseClicked (EventData As MouseEvent)
	Dim index As Int
	For Each path As String In FilesListView.Items
		FilesListView.SelectedIndex = index
		Sleep(0)
		convert(path)
		index = index + 1
	Next
End Sub

Sub convert(path As String)
	Dim img As Image = fx.LoadImage(path,"")
	Dim rect As B4XRect
	rect.Initialize(0,0,img.Width,img.Height)
	Dim bc As BitmapCreator
	bc.Initialize(img.Width,img.Height)
	bc.DrawBitmap(img,rect,False)
	For x = 0 To img.Width - 1
		For y = 0 To img.Height - 1
			Dim color As ARGBColor
			bc.GetARGB(x,y,color)
			If color.a = 0 Then
				color.a = 255
				color.r = 255
				color.g = 255
				color.b = 255
			End If
			bc.SetARGB(x,y,color)
		Next
	Next
	Dim outputPath As String = path&AffixTextField.Text
	File.WriteBytes(outputPath,"",ImageToBytes(bc.Bitmap))
End Sub

Public Sub ImageToBytes(Image As B4XBitmap) As Byte()
	Dim out As OutputStream
	out.InitializeToBytesArray(0)
	Image.WriteToStream(out, 100, "JPEG")
	out.Close
	Return out.ToBytesArray
End Sub