unit Unit1;
{----------------------------------------------------------------------------
  测试两个根据 IP 地址获取物理位置的 API

  通过 http 请求获取结果，返回是 Json，分析 Jaon 获得国家、城市名称。

  一个是淘宝的 API
  一个是 ip-api 的 API

  Delphi 10.3 测试通过.

  pcplayer
  2020-3-11
------------------------------------------------------------------------------}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    Button1: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    function ReadIPAreaFromIP_API(const IP: string): string;
    function ParseIPAddressFromTaoBaoJSON(const JSONStr: string;
  var country, area, region, city: string): Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses System.JSON;

{$R *.dfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  Country, area, region, city: string;
  S: string;
begin
//  Memo1.Lines.Clear;
//  Memo1.Lines.Add(ReadIPAreaFromIP_API(Edit1.Text));

  S := ReadIPAreaFromIP_API(Edit1.Text);

  Self.ParseIPAddressFromTaoBaoJSON(S, Country, area, region, city);

  Memo1.Lines.Add('');
  Memo1.Lines.Add('City is: ' + City);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  S: string;
  City, Country, area, region: string;
begin
  S := Self.ReadIPAreaFromIP_API(Edit1.Text);

  Self.ParseIPAddressFromTaoBaoJSON(S, Country, area, region, city);

  Memo1.Lines.Add('');
  Memo1.Lines.Add('Country = ' + Country);
  Memo1.Lines.Add('City = ' + City);
end;

function TForm1.ParseIPAddressFromTaoBaoJSON(const JSONStr: string; var country,
  area, region, city: string): Boolean;
var
  Obj: TJSONValue;
  AValue: TJSONValue;
begin
  try
    Obj := TJSONObject.ParseJSONValue(JSONStr);

//    if Obj is TJSONObject then
//    begin
//      AValue := TJSONObject(Obj).Values['data'];
//    end
//    else Exit;


    if not (Obj is TJSONObject) then Exit;

//    if AValue is TJSONObject then
//    begin
      country := TJSONObject(Obj).Values['country'].ToString;
//      area := TJSONObject(Obj).Values['area'].ToString;
//      region := TJSONObject(Obj).Values['region'].ToString;
      city := TJSONObject(Obj).Values['city'].ToString;

      Result := True;
//    end;
  except
  end;
end;

function TForm1.ReadIPAreaFromIP_API(const IP: string): string;
var
  S: string;
begin
  S := 'http://ip-api.com/json/';

  Result := IdHTTP1.Get(S + IP);
end;

end.
