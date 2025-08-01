
using System.Collections;
using Orgmode.Parser;

namespace OrgMode.Parser {
  /// <summary>
  /// An OrgMode Heading
  /// </summary>
  public class HeadingToken : TokenBase {
    public int level;
    public string? keyword;
    public ArrayList? tags;
    public string? priority;
    public string? title;

    public string? tracking;
    public HeadingToken() {
      level = 0;
      tags = [];
      start = new Position();
      end = new Position();
      content = new System.Text.StringBuilder();
    }
  }
}
