namespace NDB.CodeGen.EF.Models;

public sealed record CrudTemplate(
    string Name,
    string Folder,
    string FilePattern,
    string TemplateFile,
    CrudType Type);
