import datetime
import logging
from pathlib import Path
from time import sleep

import pandas as pd
from seleniumbase import SB

logging.getLogger(__file__)
logging.basicConfig(filename="logs.log", encoding="utf-8", level=logging.DEBUG)

TIMEOUT = 60
SHORT_SLEEP = 1
BIG_SLEEP = 3

dir = Path(__file__).parent
data_dir = dir / "data" / "vacinas"
downloads_dir = dir / "downloaded_files"

date_file_template = "%d-%m-%Y.csv"
date_str_template = "%d/%m/%Y"

date_filter_selector = "//h6[@aria-label='Data da Vacina']"
clear_filter_selector = ".actions-toolbar-clear"
leave_filter_selector = ".MuiBackdrop-root"
search_date_selector = ".njs-28fc-InputBase-input"
date_selector = "div.RowColumn-barContainer:nth-child(1)"
download_selector = "#exportar-dados-QV22"

columns = [
    "",
    "COD IBGE",
    "Município",
    "Total de Doses Aplicadas",
    "1ª Dose",
    "2ª Dose",
    "3ª Dose",
    "Dose Reforço",
    "1° Dose Reforço",
    "2° Dose Reforço",
    "3° Dose Reforço",
    "Dose Adicional",
    "Dose Única",
    "Data",
]


def get_missing_dates() -> list[datetime.date]:
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


def save_data(date: datetime.date):
    date_str = date.strftime(date_str_template)
    data_path = data_dir / date.strftime(date_file_template)

    excel_path = list(downloads_dir.glob("*.xlsx"))[0]
    print(f"Saving data for {excel_path}.")

    df = pd.DataFrame(pd.read_excel(excel_path))

    df["Data"] = date_str

    df.to_csv(data_path, index=False, columns=columns)

    print(f"Data saved in {data_path}. Deleting xlsx file.")

    return excel_path.unlink()


def main():
    with SB(uc=True) as sb:
        sb.open(
            "https://infoms.saude.gov.br/extensions/SEIDIGI_DEMAS_Vacina_C19/SEIDIGI_DEMAS_Vacina_C19.html"
        )
        sleep(BIG_SLEEP)

        for date in get_missing_dates():
            try:
                date_str = date.strftime(date_str_template)

                logging.debug(f"Trying to get data for date {date_str}.")
                sb.click(date_filter_selector, timeout=TIMEOUT)
                sleep(SHORT_SLEEP)
                sb.click(clear_filter_selector, timeout=TIMEOUT)
                sleep(SHORT_SLEEP)
                sb.type(search_date_selector, f"{date_str}", timeout=TIMEOUT)
                sleep(BIG_SLEEP)
                sb.click(date_selector, timeout=TIMEOUT)
                sleep(SHORT_SLEEP)

                sb.click(leave_filter_selector, timeout=TIMEOUT)
                sleep(BIG_SLEEP)

                verify = (
                    sb.get_text("#tagselections")
                    .replace(" X", "")
                    .replace("dtvac: ", "")
                )

                if verify == date_str:
                    logging.debug(f"Successfully selected parameters {verify}.")

                    sb.click(download_selector, timeout=TIMEOUT)
                    sleep(BIG_SLEEP)

                    save_data(date)
                else:
                    logging.error(
                        f"Incorrect parameters. Got {verify} instead of {date_str}."
                    )

            except Exception:
                logging.error(
                    f"Error while getting data for date {date.strftime(date_str_template)}."
                )

    return


if __name__ == "__main__":
    while get_missing_dates():
        main()
