
using System.Management.Automation;
using System.Text.RegularExpressions;

namespace Orgmode.Parser {
  public class Rule {
    public readonly Guid id;

    public string name;
    public bool enabled;
    public Regex pattern;
    public double weight;
    public ScriptBlock? callback;

    public Rule(string n) {
      id = Guid.NewGuid();
      name = n;
      enabled = true;
      pattern = new Regex("");
      weight = 0.0;
      callback = null;
    }
    public Rule(string n, string ptrn) {
      id = Guid.NewGuid();
      name = n;
      enabled = true;
      pattern = new Regex(ptrn);
      weight = 0.0;
      callback = null;
    }
    public Rule(string n, string ptrn, double wt = 0.0) {
      id = Guid.NewGuid();
      name = n;
      enabled = true;
      pattern = new Regex(ptrn);
      weight = wt;
      callback = null;
    }

    public MatchCollection Match(string content) {
      return pattern.Matches(content);
    }

    public void Enable() {
      enabled = true;
    }

    public void Disable() {
      enabled = false;
    }
  }
}
