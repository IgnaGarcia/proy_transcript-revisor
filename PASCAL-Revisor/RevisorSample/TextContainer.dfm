object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 347
  Height = 302
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 347
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    ExplicitLeft = 64
    ExplicitTop = 3
    ExplicitWidth = 185
  end
  object joinBtn: TButton
    Left = 120
    Top = 10
    Width = 115
    Height = 25
    Caption = 'join'
    TabOrder = 0
    OnClick = joinBtnClick
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 347
    Height = 261
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 2
    ExplicitLeft = 80
    ExplicitTop = 128
    ExplicitWidth = 185
    ExplicitHeight = 41
  end
end
