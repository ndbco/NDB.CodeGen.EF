// File: CodeGenOptions.cs
namespace NDB.CodeGen.EF;
public sealed class CodeGenOptions
{
    public string RootNamespace { get; init; } = default!;
    public string ModelNamespace { get; init; } = default!;
    public string OutputFolder { get; init; } = "Generated";
}
