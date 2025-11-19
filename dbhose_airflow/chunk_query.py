from re import split


pattern = r";(?=(?:[^']*'[^']*')*[^']*$)"


def query_part(query: str) -> tuple[str]:
    """Chunk multiquery to parts."""

    return (
        part.strip(";").strip()
        for part in split(pattern, query)
        if part.strip(";").strip()
    )
