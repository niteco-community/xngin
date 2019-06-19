namespace HtmlCache
{
    public interface IRenderingContextResolver
    {
        IRenderingContext Current { get; }
    }
}
