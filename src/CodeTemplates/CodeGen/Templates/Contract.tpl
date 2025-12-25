namespace {{ns}}.Core.Contract
{
    public static class {{Entity}}ListContract
    {
        public static readonly IReadOnlySet<string> AllowedFields =
            new HashSet<string>
            {
{{ContractAttributes}}
            };
    }
}
