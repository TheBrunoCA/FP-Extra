
class FPGui{
    __New() {
        this.gui                    := Gui("-MaximizeBox +OwnDialogs", gitRepo " v" VERSION)
        this.configButton           := this.gui.AddButton("xm", "Configuracoes")
        this._openConfigCallback    := ObjBindMethod(this, "_openConfigMenu")
        this.configButton           .OnEvent("Click", this._openConfigCallback)
        this.gui                    .AddText(, "Data da receita")
        this.calendar               := this.gui.AddMonthCal()
        this.calcButton             := this.gui.AddButton("Default", "Calcular validade")
        this._calcDateCallback              := ObjBindMethod(this, "_calcDate")
        this.calcButton             .OnEvent("Click", this._calcDateCallback)
    }

    _openConfigMenu(args*){

    }

    _calcDate(args*){
        prescDate   := this.calendar.Value
        this.calendar.Value := A_Now

        validUntil := DateAdd(prescDate, 179, "Days") ;TODO: Make every possible thing configurable
        validUntil := FormatTime(validUntil, "LongDate")

        MsgBox("A receita e valida ate " validUntil)
    }

    Show(boolean := true){
        if boolean{
            this.gui.Show
            return
        }
        this.gui.Hide
    }

    Destroy(){
        this.gui.Destroy
    }
}