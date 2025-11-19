using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class ArticleStatsView
{
    public int Id { get; set; }

    public string? Title { get; set; }

    public int? Front_Img_Id { get; set; }

    public string? Author { get; set; }

    public int? Member_Img_Id { get; set; }

    public string? t { get; set; }

    public int TotalViews { get; set; }

    public int TotalLikes { get; set; }

    public int LastWeekViews { get; set; }

    public int LastMonthViews { get; set; }

    public int LastYearViews { get; set; }

    public int LastWeekLikes { get; set; }

    public int LastMonthLikes { get; set; }

    public int LastYearLikes { get; set; }

    public int? Rec_cat_id { get; set; }
}
