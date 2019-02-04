global class ContactMaskBatch implements Database.Batchable<sObject>, Database.Stateful {

	private String mask;
	private List<Error> errors = new List<Error>();

	global ContactMaskBatch(String mask) {
		this.mask = mask.trim().replace(' ', '').toLowerCase();
	}

	global ContactMaskBatch(SandboxContext ctx) {
		this(ctx.sandboxName());
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([
			SELECT Email
			FROM Contact
			WHERE Email != null]);
	}

	global void execute(Database.BatchableContext BC, List<Contact> scope) {

		List<Contact> maskedContacts = new List<Contact>();
		for(Contact con : scope) {
			con.Email = con.Email.unescapeHtml4() + '.' + mask;
			maskedContacts.add(con);
		}

		List<Database.SaveResult> saveResults = Database.update(maskedContacts, false);
		for(Database.SaveResult sr : saveResults) {
			if (!sr.isSuccess()) {
				for(Database.Error err : sr.getErrors()) {
					errors.add(new Error(sr.getId(), err));
				}
			}
		}
	}

	global void finish(Database.BatchableContext BC) {
		String alert = 'Errors on ContactMaskBatch for ' + mask + '.';
		List<String> content = new List<String>();
		content.add(alert + '\n');
		for(Error err : errors) {
			content.add(err.toString());
		}

		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.setToAddresses(new List<Id>{ UserInfo.getUserId() });
		message.setSubject(alert);
		message.setPlainTextBody(String.join(content, '\n'));
		Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ message });
	}

	public class Error {
		public Id recordId {get;set;}
		public String message {get;set;}

		public Error(Id recordId, Database.Error err) {
			this.recordId = recordId;
			this.message = String.join(new List<String> {
				String.valueOf(err.getStatusCode()),
				err.getMessage(),
				String.valueOf(err.getFields())
			}, ' - ');
		}

		public override String toString() {
			return this.recordId + ' : ' + this.message + '\n';
		}
	}
}