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
    Left = 0
    Top = 486
    Width = 253
    Height = 30
    ColoredButtons = [btPlay, btPause, btStop]
    EnabledButtons = [btPlay, btPause, btStop]
    DoubleBuffered = True
    Visible = False
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
    Top = 40
    Width = 417
    Height = 448
    TabOrder = 3
    ExplicitTop = 40
    ExplicitWidth = 417
    ExplicitHeight = 448
    inherited Panel1: TPanel
      Width = 417
    end
    inherited Panel2: TPanel
      Width = 417
      Height = 407
    end
  end
  object playpauseBtn: TButton
    Left = 178
    Top = 510
    Width = 75
    Height = 25
    Caption = 'Play/Pause'
    TabOrder = 4
    OnClick = playpauseBtnClick
  end
  object rewindBtn: TButton
    Left = 128
    Top = 510
    Width = 44
    Height = 25
    Caption = '-5 seg'
    ModalResult = 1
    TabOrder = 5
    OnClick = rewindBtnClick
  end
  object passBtn: TButton
    Left = 259
    Top = 510
    Width = 44
    Height = 25
    Caption = '+5 seg'
    ModalResult = 1
    TabOrder = 6
    OnClick = passBtnClick
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
