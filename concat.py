import pandas as pd
from pathlib import Path
import csv

dir = Path(__file__).parent
data_dir = dir / "data"
vaccines_dir = data_dir / "vacinas"
deaths_dir = data_dir / "obitos"

vaccines_output_path = data_dir / "vacinas.csv"
deaths_output_path = data_dir / "obitos.csv"

vaccines_columns = [
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

deaths_columns = [
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


def concat_data(
    input_path: Path,
    output_path: Path,
    columns: list[str],
    dropna_column: str | None = None,
):
    input_glob = input_path.glob("*.csv")

    with open(output_path, "w") as fp:
        writer = csv.writer(fp, lineterminator="\n")
        writer.writerow(columns)

    for file in input_glob:
        df = pd.DataFrame(pd.read_csv(file))
        print(f"Saving data from file {file} in {output_path}.")

        if dropna_column is not None:
            print(f"Droping missing values in column {dropna_column}.")
            df = df.dropna(subset=dropna_column)

        df.to_csv(output_path, index=False, columns=columns, header=False, mode="a")

    print(
        f"Successfully copied all data from csv files in {input_path} to {output_path}."
    )


concat_data(vaccines_dir, vaccines_output_path, vaccines_columns)
concat_data(deaths_dir, deaths_output_path, deaths_columns, "Município")
