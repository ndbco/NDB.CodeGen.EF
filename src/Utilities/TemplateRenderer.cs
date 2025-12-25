namespace NDB.CodeGen.EF.Utilities;

public static class TemplateRenderer
{
    public static string Render(
        string template,
        Dictionary<string, string> tokens)
    {
        foreach (var kv in tokens)
        {
            if (kv.Key == "Block" || kv.Key == "IsView")
                template = ApplyBlock(template, "block", kv.Value == "true");

            template = template.Replace($"{{{{{kv.Key}}}}}", kv.Value);
        }

        return template;
    }
    private static string ApplyBlock(
        string code,
        string block,
        bool enabled)
    {
        if (enabled)
            return code
                .Replace($"{{{{>{block}}}}}", "")
                .Replace($"{{{{<{block}}}}}", "");

        return RemoveText(
            code,
            $"{{{{>{block}}}}}",
            $"{{{{<{block}}}}}");
    }

    private static string RemoveText(
    string text,
    string startMarker,
    string endMarker)
    {
        var startIndex = text.IndexOf(startMarker, StringComparison.Ordinal);
        var endIndex = text.IndexOf(endMarker, StringComparison.Ordinal);

        if (startIndex < 0 || endIndex < 0)
            return text;

        if (endIndex < startIndex)
            return text;

        var contentStart = startIndex + startMarker.Length;
        var length = endIndex - contentStart;

        if (length < 0)
            return text;

        return text
            .Remove(contentStart, length)
            .Replace(startMarker, "")
            .Replace(endMarker, "");
    }
}
