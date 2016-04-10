bool is_iPhone4()
{
    return (is_iPhone() && (MAX_DIMENTION == 480));
}

bool is_iPhone5()
{
    return (is_iPhone() && (MAX_DIMENTION == 568));
}

bool is_iPhone6()
{
    return (is_iPhone() && (MAX_DIMENTION == 667));
}

bool is_iPhone6Plus()
{
    return (is_iPhone() && (MAX_DIMENTION == 736));
}

bool is_iPad()
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

bool is_iPhone()
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}