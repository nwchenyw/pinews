using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Advertisement
{
    public int Id { get; set; }

    public string? Type { get; set; }

    public int? Img_Id { get; set; }

    public string? Link { get; set; }

    public string? Title { get; set; }

    public bool? Show_T { get; set; }

    public DateTime? Upd_Time { get; set; }

    public int? User_Id { get; set; }

    public string? Remark { get; set; }

    public int? odr { get; set; }

    public string? video_url { get; set; }

    public string? video_type { get; set; }
}
