object Form1: TForm1
  Left = 0
  Top = 0
  Width = 434
  Height = 563
  AutoScroll = True
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object header: TPanel
    Left = 0
    Top = 0
    Width = 418
    Height = 44
    Align = alTop
    AutoSize = True
    Padding.Top = 5
    Padding.Bottom = 5
    TabOrder = 0
    object textBtn: TButton
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Cargar Texto'
      TabOrder = 0
      OnClick = textBtnClick
    end
    object audioBtn: TButton
      AlignWithMargins = True
      Left = 115
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Cargar Audio'
      TabOrder = 1
      OnClick = audioBtnClick
    end
    object saveBtn: TButton
      Left = 221
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Guardar'
      TabOrder = 2
      OnClick = saveBtnClick
    end
    object exportBtn: TButton
      Left = 328
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Exportar'
      TabOrder = 3
      OnClick = exportBtnClick
    end
  end
  object footer: TPanel
    Left = 0
    Top = 479
    Width = 418
    Height = 45
    Align = alBottom
    AutoSize = True
    Padding.Top = 5
    Padding.Bottom = 5
    TabOrder = 1
    object MediaPlayer1: TMediaPlayer
      Left = 81
      Top = 6
      Width = 253
      Height = 33
      ColoredButtons = [btPlay, btPause, btStop]
      EnabledButtons = [btPlay, btPause, btStop]
      DoubleBuffered = True
      Visible = False
      ParentDoubleBuffered = False
      TabOrder = 3
    end
    object rewindBtn: TButton
      Left = 115
      Top = 13
      Width = 44
      Height = 25
      Caption = '-3 seg'
      ModalResult = 1
      TabOrder = 1
      OnClick = rewindBtnClick
    end
    object playpauseBtn: TButton
      Left = 184
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Play/Pause'
      TabOrder = 2
      OnClick = playpauseBtnClick
    end
    object passBtn: TButton
      Left = 282
      Top = 13
      Width = 44
      Height = 25
      Caption = '+3 seg'
      ModalResult = 1
      TabOrder = 0
      OnClick = passBtnClick
    end
  end
  object paragrapghBtns: TPanel
    Left = 0
    Top = 44
    Width = 418
    Height = 41
    Align = alTop
    Padding.Top = 5
    Padding.Bottom = 5
    TabOrder = 2
    object joinBtn: TButton
      Left = 115
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Juntar'
      TabOrder = 0
      OnClick = joinBtnClick
    end
    object divideBtn: TButton
      Left = 221
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Dividir'
      TabOrder = 1
      OnClick = divideBtnClick
    end
  end
  object content: TPanel
    Left = 0
    Top = 85
    Width = 418
    Height = 394
    Align = alClient
    Caption = 'Texto aun no Cargado'
    TabOrder = 3
  end
  object audioDialog: TOpenDialog
    Filter = 'MP3 Audio|*.mp3'
    Left = 109
    Top = 8
  end
  object textDialog: TOpenDialog
    Filter = 'JSON Content|*.json'
    Left = 5
    Top = 8
  end
  object exportDialog: TSaveDialog
    Left = 320
    Top = 8
  end
end
