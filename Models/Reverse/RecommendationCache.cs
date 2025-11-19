using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class RecommendationCache
{
    public int RecCatId { get; set; }

    public string OrderType { get; set; } = null!;

    public string Duration { get; set; } = null!;

    public string? ArticleData { get; set; }

    public DateTime? LastUpdated { get; set; }
}
