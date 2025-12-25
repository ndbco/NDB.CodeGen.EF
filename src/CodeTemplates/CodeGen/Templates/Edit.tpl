using {{ns}}.Core.Request;
using {{ns}}.Data;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NDB.Abstraction.Results;
using NDB.Audit.EF.Extensions;
using NDB.Kit.Ef;
using System.ComponentModel.DataAnnotations;
using NDB.Audit.EF.Abstractions;
using System.Text.Json;

namespace {{ns}}.Core.{{Entity}}.Command
{
    #region Request
    public class Edit{{Entity}}Command : {{Entity}}Request, IRequest<Result>
    {
        [Required]
        public {{PkType}} {{PkName}} { get; set; }
    }
    #endregion

    internal class Edit{{Entity}}Handler : IRequestHandler<Edit{{Entity}}Command, Result>
    {
        private readonly ILogger _logger;
        private readonly IAuditContext _audit;
        private readonly ApplicationDBContext _db;

        public Edit{{Entity}}Handler(
            ILogger<Edit{{Entity}}Handler> logger,
            IAuditContext audit,
            ApplicationDBContext db)
        {
            _logger = logger;
            _audit = audit;
            _db = db;
        }

        public async Task<Result> Handle(Edit{{Entity}}Command request, CancellationToken cancellationToken)
        {
            try
            {
                var item = await _db.{{Entity}}.Where(d => d.{{PkName}} == request.{{PkName}}).ForAudit().FirstOrDefaultAsync(cancellationToken);
                if (item == null)
                    return Result.Fail(ResultStatus.NotFound,$"Id {{Entity}} {request.{{PkName}}} Not Found!");

{{EditAttributes}}
                item.UpdateBy = _audit.Actor;
                item.UpdateDate = DateTime.Now;

                var save = await _db.SaveWithAuditResultAsync(cancellationToken);
                if (!save.Success)
                {
                    _logger.LogError(save.Exception,"Failed Update {{Entity}} : {request}",JsonSerializer.Serialize(request));
                    return Result.Fail(ResultStatus.BadRequest, save.Message);
                }
                _logger.LogInformation("Success Update {{Entity}} : {log}",JsonSerializer.Serialize(save.AuditEntries));
                return Result.Ok();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed Update {{Entity}}");
                return Result.Fail(ResultStatus.Error,$"Failed Update {{Entity}} : {ex.Message}");
            }
        }
    }
}
