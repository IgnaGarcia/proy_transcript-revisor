object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 217
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object btnAddAudio: TButton
    Left = 24
    Top = 168
    Width = 75
    Height = 30
    Caption = 'Cargar'
    TabOrder = 0
    OnClick = btnAddAudioClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 402
    Height = 154
    ItemHeight = 13
    TabOrder = 1
  end
  object MediaPlayer1: TMediaPlayer
    Left = 136
    Top = 168
    Width = 253
    Height = 30
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
  end
  object diag1: TOpenDialog
    Filter = 'mp3|*.mp3'
    Left = 24
    Top = 168
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 104
    Top = 168
  end
end
