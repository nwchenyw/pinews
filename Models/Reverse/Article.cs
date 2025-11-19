using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Article
{
    public int Id { get; set; }

    public string? Title { get; set; }

    public string? Content { get; set; }

    public int? Front_Img_Id { get; set; }

    public string? Category { get; set; }

    public string? Keyword { get; set; }

    public DateTime? DateTime { get; set; }

    public int? Status { get; set; }

    public int? Name_Status { get; set; }

    public DateTime? Active_Time { get; set; }

    public DateTime? inActive_Time { get; set; }

    public string? Author { get; set; }

    public string? Author_Email { get; set; }

    public string? Relate_Img { get; set; }

    public string? Recommand_Category { get; set; }

    public string? Description { get; set; }

    public int? User_Id { get; set; }

    public virtual ICollection<ArticleDailyStat> ArticleDailyStats { get; set; } = new List<ArticleDailyStat>();

    public virtual ArticleTotalStat? ArticleTotalStat { get; set; }
}
