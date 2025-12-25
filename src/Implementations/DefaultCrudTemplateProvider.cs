using NDB.CodeGen.EF.Abstractions;
using NDB.CodeGen.EF.Models;

namespace NDB.CodeGen.EF.Implementations;

public sealed class DefaultCrudTemplateProvider : ICrudTemplateProvider
{
    public IReadOnlyList<CrudTemplate> GetTemplates() => new List<CrudTemplate>()
    {
        new("Active","Command", "Active{{Entity}}Handler.cs", "Active.tpl",CrudType.Command),
        new("Add","Command","Add{{Entity}}Handler.cs","Add.tpl",CrudType.Command),
        new("Edit","Command","Edit{{Entity}}Handler.cs","Edit.tpl",CrudType.Command),
        new("Delete","Command","Delete{{Entity}}Handler.cs","Delete.tpl",CrudType.Command),

        new("Export", "Query",   "Export{{Entity}}Handler.cs", "Export.tpl",CrudType.Query),
        new("GetById", "Query",   "Get{{Entity}}ByIdHandler.cs", "GetById.tpl",CrudType.Query),
        new("GetList", "Query",   "Get{{Entity}}ListHandler.cs","GetList.tpl",CrudType.Query),
        new("GetPaged","Query",   "Get{{Entity}}PagedHandler.cs","GetPaged.tpl",CrudType.Query),

        new("ExportDto", "Object",  "{{Entity}}ExportDto.cs",       "ExportDto.tpl",CrudType.Query),
        new("Request", "Object",  "{{Entity}}Request.cs",       "Request.tpl", CrudType.Command),
        new("Response","Object",  "{{Entity}}Response.cs",      "Response.tpl", CrudType.Query),
        new("Contract","Object",  "{{Entity}}Contract.cs",      "Contract.tpl", CrudType.Query),

        new("API","",  "{{Entity}}Controller.cs","API.tpl", CrudType.API),
    };
}
