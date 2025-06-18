
using System.Text;

namespace Orgmode.Parser
{
  public class Token
  {
    public string type;
    public Position start;
    public Position end;
    public StringBuilder content;

    public Token()
    {
      type = "unknown";
      start = new Position();
      end = new Position();
      content = new StringBuilder();
    }

    public override string ToString()
    {
      return content.ToString();
    }
  }
}
