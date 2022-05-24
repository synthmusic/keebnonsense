; test()
do := DisplayObject()
do.test()

; m := Msg()
; m.add("hi")
; m.add("hi")
; m.box()

; m2 = {
;     msg := "m2"
; }

; obj

; test() {
;     display(data) {
;         MsgBox(data)
;     }
;     display("works")

;     displayVar := display
;     displayVar("works")

;     displayBound := display.Bind("works")
;     displayBound()
; }

class DisplayObject {
    var := "works"
    test() {
        this.DOdisplay("direct" "works")

        DOdisplayVar := this.DOdisplay.Bind(this, "l" this.var)
        MsgBox(Type(DOdisplayVar))
        DOdisplayVar()
        SetTimer DOdisplayVar, -100
        Hotkey "q", DOdisplayVar


        DOdisplayBound := this.DOdisplay.Bind(this, "works")
        DOdisplayBound()

        DOdisplayBoundThis := this.DOdisplay.Bind(this)
        DOdisplayBoundThis("works")
    }

    DOdisplay(data, ignore := "") {
        MsgBox(data ignore)

    }
}



class Msg {
    msg := ""
    add(data) {
        this.msg := this.msg . data . "`n"
    }
    box() {
        MsgBox(this.msg)
        this.msg := ""
    }
}
