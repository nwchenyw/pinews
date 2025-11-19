using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Article_View
{
    public int Id { get; set; }

    public DateTime? date { get; set; }

    public int? visitor { get; set; }

    public int? user { get; set; }
}
