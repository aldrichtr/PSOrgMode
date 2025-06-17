
class Position {
  [int]$Index
  [int]$Line
  [int]$Column


  # --------------------------------------------------------------------------------
  #region Constructors

  Position() {
    $this.Index = $this.Line = $this.Column = 0
  }

  Position([int]$i, [int]$l, [int]$c) {
    $this.Index = $i
    $this.Line = $l
    $this.Column = $c
  }

  #endregion Constructors
  # --------------------------------------------------------------------------------

  # --------------------------------------------------------------------------------
  #region Methods

  [void] Advance([int]$c = 1) {
    $this.Column += $c
    $this.Index += $c
  }

  [void] NewLine() {
    $this.Column = 1
    $this.Line += 1
  }

  [void] AddLines([int]$l = 1) {
    $this.Line += $l
  }

  [string]ToString() {
    return ('{0}-{1}:{2}' -f $this.Index, $this.Line, $this.Column)
  }
  #endregion Methods
  # --------------------------------------------------------------------------------

}
