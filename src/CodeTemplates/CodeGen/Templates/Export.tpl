using AutoMapper;
using {{ns}}.Core.Export;
using {{ns}}.Core.Response;
using MediatR;
using Microsoft.Extensions.Logging;
using NDB.Abstraction.Requests;
using NDB.Abstraction.Results;
using NDB.Kit.Excel;
using NDB.Abstraction.Common;

namespace {{ns}}.Core.{{Entity}}.Query;

public sealed record Export{{Entity}}Query(ListRequest Request) : IRequest<Result>;
internal sealed class Export{{Entity}}Handler : IRequestHandler<Export{{Entity}}Query, Result>
{
    private readonly ILogger _logger;
    private readonly IMapper _mapper;
    private readonly IMediator _mediator;
    private readonly ExcelExporter _excelExporter;

    public Export{{Entity}}Handler(
        ILogger<Export{{Entity}}Handler> logger,
        IMapper mapper,
        IMediator mediator,
        ExcelExporter excelExporter)
    {
        _logger = logger;
        _mapper = mapper;
        _mediator = mediator;
        _excelExporter = excelExporter;
    }

    public async Task<Result> Handle(Export{{Entity}}Query request,CancellationToken cancellationToken)
    {
        try
        {
            var data = await _mediator.Send(new Get{{Entity}}PagedQuery(request.Request));
            if (data.Succeeded)
            {
                var result = (PagedResult<{{Entity}}Response>)data;
                var exportData = _mapper.Map<List<{{Entity}}ExportDto>>(result.Items);
                var bytes = _excelExporter.Export(
                    exportData,
                    sheetName: "{{Entity}}");

                return Result<FileByteObject>.Ok(new FileByteObject
                {
                    Filename = $"{{Entity}}_{DateTime.UtcNow:yyyyMMdd_HHmmss}.xlsx",
                    MimeType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    File = bytes
                });
            }
            else
                return data;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed Export {{Entity}}");
            return Result.Fail(ResultStatus.Error,$"Failed Export {{Entity}}: {ex.Message}");
        }
    }
}
