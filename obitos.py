import logging
from pathlib import Path
from time import sleep

import pandas as pd
from seleniumbase import SB

logging.getLogger(__file__)
logging.basicConfig(filename="logs.log", encoding="utf-8", level=logging.DEBUG)

TIMEOUT = 60
SHORT_SLEEP = 3
BIG_SLEEP = 5

dir = Path(__file__).parent
data_dir = dir / "data" / "obitos"
downloads_dir = dir / "downloaded_files"


city_selector = "#aba3-tab"

year_filter_selector = "//h6[@aria-label='Ano']"
week_filter_selector = "//h6[@aria-label='Semana Epidemiológica']"
clear_filter_selector = ".actions-toolbar-clear"
leave_filter_selector = ".MuiBackdrop-root"
year_selector = "//*[@title='2020']"
search_week_selector = ".njs-28fc-InputBase-input"
week_selector = "div.RowColumn-barContainer:nth-child(1)"
download_selector = "#exportar-dados-Tab-03"

columns = [
    "",
    "UF",
    "Município",
    "População",
    "Casos novos notificados na semana epidemiológica",
    "Casos Acumulados",
    "Incidência covid-19 (100 mil hab)",
    "Óbitos novos notificados na semana epidemiológica",
    "Óbitos Acumulados",
    "Taxa mortalidade (100 mil hab)",
    "Semana Epidemiológica",
]


def get_missing_files():
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


def save_data(year, week):
    week_year = f"{week}-{year}"
    data_path = data_dir / f"{week_year}.csv"

    excel_path = list(downloads_dir.glob("*.xlsx"))[0]
    print(f"Saving data for {excel_path}.")

    df = pd.DataFrame(pd.read_excel(excel_path))

    df["Semana Epidemiológica"] = week_year

    df.to_csv(data_path, index=False, columns=columns)

    print(f"Data saved in {data_path}. Deleting xlsx file.")

    return excel_path.unlink()


def main():
    with SB(uc=True) as sb:
        sb.open(
            "https://infoms.saude.gov.br/extensions/covid-19_html/covid-19_html.html#"
        )
        sb.click(city_selector, timeout=TIMEOUT)
        sleep(BIG_SLEEP)

        for week, year in get_missing_files():
            sb.click(year_filter_selector, timeout=TIMEOUT)
            sleep(SHORT_SLEEP)
            sb.click(clear_filter_selector, timeout=TIMEOUT)
            sleep(SHORT_SLEEP)
            sb.click(f"//div[@title='{year}']", timeout=TIMEOUT)
            sleep(SHORT_SLEEP)

            sb.click(leave_filter_selector, timeout=TIMEOUT)
            sleep(SHORT_SLEEP)

            try:
                logging.debug(f"Trying to get data for year {year} week {week}.")
                sb.click(week_filter_selector, timeout=TIMEOUT)
                sleep(SHORT_SLEEP)
                sb.click(clear_filter_selector, timeout=TIMEOUT)
                sleep(SHORT_SLEEP)
                sb.type(search_week_selector, f"{week}", timeout=TIMEOUT)
                sleep(BIG_SLEEP)
                sb.click(week_selector, timeout=TIMEOUT)
                sleep(SHORT_SLEEP)

                sb.click(leave_filter_selector, timeout=TIMEOUT)

                expected = [f"{week}{year}", f"{year}{week}"]

                verify = (
                    sb.get_text("#tagselections")
                    .replace(" X", "")
                    .replace("Semana: ", "")
                    .replace("Ano: ", "")
                )

                if verify in expected:
                    logging.debug(f"Successfully selected parameters {verify}.")

                    sleep(BIG_SLEEP)
                    sb.click(download_selector, timeout=TIMEOUT)
                    sleep(BIG_SLEEP)

                    save_data(year, week)
                else:
                    logging.error(
                        f"Incorrect parameters. Got {verify} instead of {expected[0]}"
                    )
            except Exception:
                logging.error(f"Error while getting data for year {year} week {week}")

    return


if __name__ == "__main__":
    while get_missing_files():
        main()
