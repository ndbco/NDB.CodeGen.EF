using {{ns}}.Data;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NDB.Abstraction.Results;
using NDB.Audit.EF.Abstractions;
using NDB.Audit.EF.Extensions;
using NDB.Kit.Ef;
using System.ComponentModel.DataAnnotations;
using System.Text.Json;

namespace {{ns}}.Core.{{Entity}}.Command
{
    public sealed record Active{{Entity}}Command({{PkType}} {{PkName}},bool Active) : IRequest<Result>;

    internal class Active{{Entity}}Handler : IRequestHandler<Active{{Entity}}Command, Result>
    {
        private readonly ILogger _logger;
        private readonly IAuditContext _audit;
        private readonly ApplicationDBContext _db;

        public Active{{Entity}}Handler(
            ILogger<Active{{Entity}}Handler> logger,
            IAuditContext audit,
            ApplicationDBContext db)
        {
            _logger = logger;
            _audit = audit;
            _db = db;
        }

        public async Task<Result> Handle(Active{{Entity}}Command request, CancellationToken cancellationToken)
        {
            try
            {
                var item = await _db.{{Entity}}.Where(d => d.{{PkName}} == request.{{PkName}}).ForAudit().FirstOrDefaultAsync(cancellationToken);

                if (item == null)
                    return Result.Fail(ResultStatus.NotFound,$"Id {{Entity}} {request.{{PkName}}} Not Found!");

                item.Active = request.Active;
                item.UpdateBy = _audit.Actor;
                item.UpdateDate = DateTime.Now;

                var save = await _db.SaveWithAuditResultAsync(cancellationToken);
                if (!save.Success)
                {
                    _logger.LogError(save.Exception,"Failed Active {{Entity}} : {request}",JsonSerializer.Serialize(request));
                    return Result.Fail(ResultStatus.BadRequest, save.Message);
                }
                _logger.LogInformation("Success Active {{Entity}} : {log}",JsonSerializer.Serialize(save.AuditEntries));
                return Result.Ok();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed Active {{Entity}}");
                return Result.Fail(ResultStatus.Error,$"Failed Active {{Entity}} : {ex.Message}");
            }
        }
    }
}
