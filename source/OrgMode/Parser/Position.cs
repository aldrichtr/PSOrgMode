
namespace Orgmode.Parser {
  public class Position {
    public int index;
    public int line;
    public int column;

    public Position() {
      column = 0;
      line = 0;
      index = 0;
    }

    public void Advance(int col = 0, int ln = 0, int idx = 0) {
      index += idx;
      line += ln;
      column += col;
    }
  }
}
