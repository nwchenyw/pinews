using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class ArticleTotalStat
{
    public int ArticleId { get; set; }

    public int? TotalViews { get; set; }

    public int? TotalLikes { get; set; }

    public int? TotalUniqueViewers { get; set; }

    public int? TotalUniqueLikers { get; set; }

    public int? LastWeekViews { get; set; }

    public int? LastMonthViews { get; set; }

    public int? LastYearViews { get; set; }

    public int? LastWeekLikes { get; set; }

    public int? LastMonthLikes { get; set; }

    public int? LastYearLikes { get; set; }

    public DateTime? LastUpdated { get; set; }

    public virtual Article Article { get; set; } = null!;
}
