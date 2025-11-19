using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Banner
{
    public int Id { get; set; }

    public int? Image_Id { get; set; }

    public string? Title { get; set; }

    public string? Link { get; set; }

    public int? Article_Id { get; set; }

    public string? font_size { get; set; }

    public string? font_name { get; set; }

    public string? color { get; set; }

    public int? odr { get; set; }

    public bool? active { get; set; }

    public bool? isVideo { get; set; }

    public string? Video_type { get; set; }

    public string? Video_url { get; set; }
}
