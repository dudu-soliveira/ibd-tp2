from pathlib import Path
import datetime

dir = Path(__file__).parent


def get_missing_files():
    data_dir = dir / "data" / "obitos"

    files = [file.name for file in data_dir.glob("*.csv")]
    missing_files = []

    for year in range(2020, 2026):
        for week in range(1, 54):
            if (
                (year == 2020 and week < 13)
                or (year >= 2022 and week == 53)
                or (year == 2025 and week > 23)
            ):
                continue

            file = f"{week}-{year}.csv"

            if file not in files:
                missing_files.append((week, year))

    return missing_files


def get_missing_dates() -> list[datetime.date]:
    data_dir = dir / "data" / "vacinas"

    start = datetime.date(2021, 1, 17)
    end = datetime.date(2025, 6, 19)

    files = [file.name for file in data_dir.glob("*.csv")]
    missing_dates = []

    current_date = start

    while current_date <= end:
        if current_date.strftime("%d-%m-%Y.csv") not in files:
            missing_dates.append(current_date)

        current_date += datetime.timedelta(days=1)

    return missing_dates


print(get_missing_dates())
print(get_missing_files())
