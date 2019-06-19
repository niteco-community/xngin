using EPiServer.Core;
using System.Collections.Generic;

namespace HtmlCache
{
    public interface IRenderingContext
    {
        bool DependentOnAllContent { get; set; }
        void AddDependencies(IEnumerable<ContentReference> contentLinks);
        void AddChildrenListingDependency(ContentReference contentLink);
        bool PreventCache { get; set; }
        string Key { get; }
        IEnumerable<ContentReference> ContentItems { get; }
        IEnumerable<ContentReference> Listings { get; }
        IRenderingContext ParentContext { get; }
    }

    public static class RenderingContextExtensions
    {
        public static void AddDependency(this IRenderingContext context, ContentReference contentLink)
        {
            context.AddDependencies(new[] { contentLink });
        }
    }
}
