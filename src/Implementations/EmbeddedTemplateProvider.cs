using System.Reflection;
using NDB.CodeGen.EF.Abstractions;

namespace NDB.CodeGen.EF.Implementations;

public sealed class EmbeddedTemplateProvider : ITemplateProvider
{
    public string Load(string templateName)
    {
        var asm = Assembly.GetExecutingAssembly();
        var res = asm.GetManifestResourceNames()
            .Single(n => n.EndsWith(templateName));

        using var s = asm.GetManifestResourceStream(res)!;
        using var r = new StreamReader(s);
        return r.ReadToEnd();
    }
}
