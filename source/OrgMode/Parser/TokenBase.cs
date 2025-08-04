
using System.Text;


namespace Orgmode.Parser {
  public abstract class TokenBase {
    public required Position start;
    public required Position end;
    public StringBuilder? content;
  }
}
