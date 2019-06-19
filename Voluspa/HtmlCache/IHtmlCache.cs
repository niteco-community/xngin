using System;

namespace HtmlCache
{
    public interface IHtmlCache
    {
        string GetOrAdd(string key, Func<IRenderingContext, string> renderingCallback);
        RenderingContextResult BeginContext(string key);
        void CompleteContext(IRenderingContext context, string result);
    }
}
