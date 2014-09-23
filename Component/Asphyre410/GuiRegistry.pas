unit GuiRegistry;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 SysUtils, GuiObjects;

//---------------------------------------------------------------------------
function CreateGuiClass(ClassName: string; Owner: TGuiObject): TGuiObject;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 GuiForms, GuiEdit, GuiButton;

//---------------------------------------------------------------------------
function CreateGuiClass(ClassName: string; Owner: TGuiObject): TGuiObject;
begin
 ClassName:= LowerCase(ClassName);

 Result:= nil;
 if (ClassName = 'tguiform') then Result:= TGuiForm.Create(Owner);
 if (ClassName = 'tguiedit') then Result:= TGuiEdit.Create(Owner);
 if (ClassName = 'tguibutton') then Result:= TGuiButton.Create(Owner);
end;

//---------------------------------------------------------------------------
end.
