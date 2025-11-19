using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class ArticleDailyStat
{
    public int ArticleId { get; set; }

    public DateOnly StatsDate { get; set; }

    public int? ViewCount { get; set; }

    public int? LikeCount { get; set; }

    public int? UniqueViewers { get; set; }

    public int? UniqueLikers { get; set; }

    public DateTime? LastUpdated { get; set; }

    public virtual Article Article { get; set; } = null!;
}
