using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Menu
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string? Link { get; set; }

    public int? odr { get; set; }
}
