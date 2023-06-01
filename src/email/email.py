import sendgrid
import os
from sendgrid.helpers.mail import Mail, Email, To, Content

def send_email(index):
    sg = sendgrid.SendGridAPIClient(api_key=os.environ.get('SENDGRID_API_KEY'))
    from_email = Email("lau.cy.matthew@gmail.com") 
    to_email = To("lau.cy.matthew@gmail.com")
    subject = "Python Fear and Greed Index notification"
    content = Content("text/plain", "Fear and greed index is: {}".format(index))
    mail = Mail(from_email, to_email, subject, content)

    mail_json = mail.get()

    response = sg.client.mail.send.post(request_body=mail_json)
    print(response.status_code)
    print(response.headers)