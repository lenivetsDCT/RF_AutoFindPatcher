object Form1: TForm1
  Left = 296
  Top = 89
  Caption = 'RF AutoFind'
  ClientHeight = 164
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 242
    Top = 148
    Width = 55
    Height = 13
    Caption = 'by Lenivets'
  end
  object Memo1: TMemo
    Left = 127
    Top = 95
    Width = 170
    Height = 52
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 153
    Height = 89
    Caption = #1055#1072#1090#1095' '#1054#1089#1072#1076#1086#1082
    TabOrder = 1
    object Button1: TButton
      Left = 11
      Top = 57
      Width = 139
      Height = 25
      Caption = #1055#1072#1090#1095' '#1054#1089#1072#1076#1082#1080
      TabOrder = 0
      OnClick = Button1Click
    end
    object CheckBox2: TCheckBox
      Left = 7
      Top = 34
      Width = 57
      Height = 17
      Caption = 'Speed'
      TabOrder = 1
    end
    object CheckBox5: TCheckBox
      Left = 7
      Top = 16
      Width = 57
      Height = 17
      Caption = 'Radius'
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 158
    Top = 0
    Width = 139
    Height = 89
    Caption = #1055#1072#1090#1095' '#1055#1059' '#1086#1088#1091#1078#1080#1103
    TabOrder = 2
    object Button3: TButton
      Left = 3
      Top = 60
      Width = 78
      Height = 26
      Caption = #1055#1072#1090#1095' '#1054#1088#1091#1078#1082#1080
      TabOrder = 0
      OnClick = Button3Click
    end
    object Edit2: TEdit
      Left = 3
      Top = 14
      Width = 126
      Height = 21
      TabOrder = 1
      Text = #1060#1091#1088#1080#1103' [3'
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 40
      Width = 41
      Height = 17
      Caption = #1043#1088#1077#1085
      TabOrder = 2
    end
    object CheckBox4: TCheckBox
      Left = 55
      Top = 41
      Width = 34
      Height = 16
      Caption = #1041#1041
      TabOrder = 3
    end
    object CheckBox6: TCheckBox
      Left = 89
      Top = 40
      Width = 40
      Height = 17
      Caption = #1055#1059
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 95
    Width = 121
    Height = 66
    Caption = 'Looter'
    TabOrder = 3
    object Button2: TButton
      Left = 56
      Top = 13
      Width = 57
      Height = 25
      Caption = 'Loot'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Edit1: TEdit
      Left = 6
      Top = 15
      Width = 44
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = #1050#1083#1072#1074#1080#1096#1072
      OnKeyDown = Edit1KeyDown
    end
    object CheckBox1: TCheckBox
      Left = 11
      Top = 42
      Width = 102
      Height = 17
      Caption = #1045#1097#1077' '#1073#1099#1089#1090#1088#1077'..'
      TabOrder = 2
    end
  end
  object Button4: TButton
    Left = 152
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 4
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 264
    Top = 96
  end
end
