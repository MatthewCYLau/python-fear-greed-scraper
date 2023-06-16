import sendgrid
import os
import logging
from sendgrid.helpers.mail import Mail, Email, To, Content


def send_email(to_email: str = "", index: int = 0):
    sg = sendgrid.SendGridAPIClient(api_key=os.environ.get("SENDGRID_API_KEY"))
    from_email = Email("lau.cy.matthew@gmail.com")
    to_email = To(to_email)
    subject = "Python Fear and Greed Index notification"
    content = Content("text/plain", "Fear and greed index is: {}".format(index))
    mail = Mail(from_email, to_email, subject, content)

    mail_json = mail.get()

    response = sg.client.mail.send.post(request_body=mail_json)
    logging.info(response.status_code)
    logging.info(response.headers)
