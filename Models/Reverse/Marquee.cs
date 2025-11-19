using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Marquee
{
    public int Id { get; set; }

    public string? Text { get; set; }

    public string? Link { get; set; }

    public DateTime? Add_Time { get; set; }

    public string? font_size { get; set; }

    public string? font_name { get; set; }

    public string? color { get; set; }

    public string? font_weight { get; set; }

    public int? odr { get; set; }

    public bool? active { get; set; }
}
