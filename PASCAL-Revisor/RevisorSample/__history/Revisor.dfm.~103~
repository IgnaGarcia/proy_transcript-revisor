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
    Height = 43
    Align = alTop
    AutoSize = True
    Padding.Top = 5
    Padding.Bottom = 5
    TabOrder = 0
    object chargeBtn: TButton
      AlignWithMargins = True
      Left = 63
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Cargar'
      TabOrder = 0
      OnClick = chargeBtnClick
    end
    object saveBtn: TButton
      Left = 171
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Guardar'
      TabOrder = 1
      OnClick = saveBtnClick
    end
    object exportBtn: TButton
      Left = 280
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Exportar'
      TabOrder = 2
      OnClick = exportBtnClick
    end
  end
  object footer: TPanel
    Left = 0
    Top = 478
    Width = 418
    Height = 46
    Align = alBottom
    AutoSize = True
    Padding.Top = 5
    Padding.Bottom = 5
    TabOrder = 1
    object MediaPlayer1: TMediaPlayer
      Left = 82
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
      Left = 82
      Top = 14
      Width = 44
      Height = 25
      Caption = '-3 seg'
      ModalResult = 1
      TabOrder = 1
      OnClick = rewindBtnClick
    end
    object playpauseBtn: TButton
      Left = 171
      Top = 13
      Width = 75
      Height = 27
      Caption = 'Play/Pause'
      TabOrder = 2
      OnClick = playpauseBtnClick
    end
    object passBtn: TButton
      Left = 291
      Top = 14
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
    Top = 43
    Width = 418
    Height = 41
    Align = alTop
    Padding.Top = 5
    Padding.Bottom = 5
    TabOrder = 2
    object joinBtn: TButton
      Left = 118
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Juntar'
      TabOrder = 0
      OnClick = joinBtnClick
    end
    object divideBtn: TButton
      Left = 224
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Dividir'
      TabOrder = 1
      OnClick = divideBtnClick
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 84
    Width = 418
    Height = 394
    Align = alClient
    TabOrder = 3
  end
  object textDialog: TOpenDialog
    Filter = 'JSON Content|*.json'
    Left = 61
    Top = 8
  end
  object exportDialog: TSaveDialog
    Left = 296
    Top = 8
  end
  object saveDialog: TSaveDialog
    Left = 176
    Top = 8
  end
  object audioDialog: TOpenDialog
    Filter = 'MP3 Audio|*.mp3'
    Left = 61
    Top = 24
  end
end
