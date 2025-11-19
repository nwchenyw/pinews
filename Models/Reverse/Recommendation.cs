using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Recommendation
{
    public int Id { get; set; }

    public string? Category_Name { get; set; }

    public int? Cat_Order { get; set; }

    public string? Art_Odr_Type { get; set; }

    public string? Art_Grouping { get; set; }

    public string? Art_Odr_Duration { get; set; }

    public string? font_color { get; set; }

    public string? font_name { get; set; }
}
