# Python Fear and Greed Scraper

A Python web scraper which scrapes the Fear and Greed index

![cicd cloud run workflow](https://github.com/MatthewCYLau/python-fear-greed-scraper/actions/workflows/cicd-cloud-run.yaml/badge.svg)

The list of repositories are as follow:

- Python Flask API repository [here](https://github.com/MatthewCYLau/python-fear-greed-api)
- React with Vite client repository [here](https://github.com/MatthewCYLau/python-fear-greed-client)
- Scraper and GCP infrastructure repository [here](https://github.com/MatthewCYLau/python-fear-greed-scraper)

## Run/build app locally

- Run app on host machine:

```bash
virtualenv -p /usr/bin/python3 venv
source venv/bin/activate
pip3 install -r requirements.txt
python3 manage.py
deactivate
```

- Run app as container:

```bash
docker compose up --build
```

### Install new packages

```bash
pip3 install boto
pip3 freeze > requirements.txt
```

### Command line tool

```
python3 df_playground.py generate-df 20 --int-only
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
