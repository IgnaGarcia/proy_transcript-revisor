object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 548
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MediaPlayer1: TMediaPlayer
    Left = 77
    Top = 510
    Width = 253
    Height = 30
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
  end
  object audioBtn: TButton
    Left = 255
    Top = 1
    Width = 75
    Height = 25
    Caption = 'Cargar Audio'
    TabOrder = 1
    OnClick = audioBtnClick
  end
  object textBtn: TButton
    Left = 77
    Top = 1
    Width = 75
    Height = 25
    Caption = 'Cargar Texto'
    TabOrder = 2
    OnClick = textBtnClick
  end
  inline TFrame11: TFrame1
    Left = 0
    Top = 48
    Width = 417
    Height = 448
    AutoScroll = True
    TabOrder = 3
    ExplicitTop = 48
    ExplicitWidth = 417
    ExplicitHeight = 448
    inherited Memo1: TMemo
      Width = 417
    end
    inherited Memo2: TMemo
      Width = 417
    end
    inherited Memo4: TMemo
      Width = 417
    end
  end
  object audioDialog: TOpenDialog
    Filter = 'MP3 Audio|*.mp3'
    Left = 333
  end
  object textDialog: TOpenDialog
    Filter = 'JSON Content|*.json'
    Left = 149
  end
end