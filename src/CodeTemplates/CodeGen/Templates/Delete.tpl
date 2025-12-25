using {{ns}}.Data;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NDB.Abstraction.Results;
using NDB.Kit.Ef;
using NDB.Audit.EF.Abstractions;
using NDB.Audit.EF.Extensions;
using System.Text.Json;

namespace {{ns}}.Core.{{Entity}}.Command
{
    public sealed record Delete{{Entity}}Command({{PkType}} {{PkName}}) : IRequest<Result>;

    internal class Delete{{Entity}}Handler : IRequestHandler<Delete{{Entity}}Command, Result>
    {
        private readonly ILogger _logger;
        private readonly IAuditContext _audit;
        private readonly ApplicationDBContext _db;

        public Delete{{Entity}}Handler(
            ILogger<Delete{{Entity}}Handler> logger,
            IAuditContext audit,
            ApplicationDBContext db)
        {
            _logger = logger;
            _audit = audit;
            _db = db;
        }

        public async Task<Result> Handle(Delete{{Entity}}Command request, CancellationToken cancellationToken)
        {
            try
            {
                var item = await _db.{{Entity}}.Where(d => d.{{PkName}} == request.{{PkName}}).ForAudit().FirstOrDefaultAsync(cancellationToken);

                if (item == null)
                    return Result.Fail(ResultStatus.NotFound,$"Id {{Entity}} {request.{{PkName}}} Not Found!");

                _db.Remove(item);
                var save = await _db.SaveWithAuditResultAsync(cancellationToken);
                if (!save.Success)
                {
                    _logger.LogError(save.Exception,"Failed Delete {{Entity}} : {request}",JsonSerializer.Serialize(request));
                    return Result.Fail(ResultStatus.BadRequest, save.Message);
                }
                _logger.LogInformation("Success Delete By {user} {{Entity}} : {log}",_audit.Actor,JsonSerializer.Serialize(save.AuditEntries));
                return Result.Ok();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed Delete {{Entity}}");
                return Result.Fail(ResultStatus.Error,$"Failed Delete {{Entity}} : {ex.Message}");
            }
        }
    }
}
