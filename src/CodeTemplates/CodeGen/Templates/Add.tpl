using {{ns}}.Core.Request;
using {{ns}}.Data;
using MediatR;
using Microsoft.Extensions.Logging;
using NDB.Abstraction.Results;
using NDB.Kit.Ef;
using System.ComponentModel.DataAnnotations;
using NDB.Audit.EF.Abstractions;
using System.Text.Json;

namespace {{ns}}.Core.{{Entity}}.Command
{
    #region Request
    public class Add{{Entity}}Command : {{Entity}}Request, IRequest<Result>
    {
    }
    #endregion

    internal class Add{{Entity}}Handler : IRequestHandler<Add{{Entity}}Command, Result>
    {
        private readonly ILogger _logger;
        private readonly IAuditContext _audit;
        private readonly ApplicationDBContext _db;

        public Add{{Entity}}Handler(
            ILogger<Add{{Entity}}Handler> logger,
            IAuditContext audit,
            ApplicationDBContext db)
        {
            _logger = logger;
            _audit = audit;
            _db = db;
        }

        public async Task<Result> Handle(Add{{Entity}}Command request, CancellationToken cancellationToken)
        {
            try
            {
                _db.Add(new Data.Model.{{Entity}}
                {
{{AddAttributes}}
{{>block}}                  Active = true,{{<block}}
                    CreateBy = _audit.Actor,
                    CreateDate = DateTime.Now
                });

                var save = await _db.SaveWithAuditResultAsync(cancellationToken);
                if (!save.Success)
                {
                    _logger.LogError(save.Exception,"Failed Add {{Entity}} : {request}",JsonSerializer.Serialize(request));
                    return Result.Fail(ResultStatus.BadRequest, save.Message);
                }
                _logger.LogInformation("Success Add {{Entity}} : {log}",JsonSerializer.Serialize(save.AuditEntries));
                return Result.Ok();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed Add {{Entity}}");
                return Result.Fail(ResultStatus.Error,$"Failed Add {{Entity}} : {ex.Message}");
            }
        }
    }
}
