@isTest
private class ContactMaskBatchTest {

	@TestSetup
	static void setupData() {
		Contact george = new Contact(
			LastName = 'Costanza',
			Email = 'gCostanza@gmail.com');
		insert george;
	}

	static TestMethod void batch_givenMask_shouldAppendMaskToContactEmail() {
		Contact preGeorge = queryOneContact();
		String preGeorgeEmail = preGeorge.Email;

		String orgId = UserInfo.getOrganizationId();
		String orgName = UserInfo.getOrganizationName().trim().replace(' ', '').toLowerCase();

		Test.startTest();

			Database.executeBatch(new ContactMaskBatch(orgName), 1);

		Test.stopTest();

		Contact postGeorge = queryOneContact();

		System.assertNotEquals(preGeorgeEmail, postGeorge.Email, 'Email should have been updated.');
		System.assert(postGeorge.Email.endsWith('.' + orgName), 'New Email ends with (dot)' + orgName + '.' + ' Actual: ' + postGeorge.Email);
	}

	static TestMethod void finish_shouldSendEmail() {

		String orgName = UserInfo.getOrganizationName().trim().replace(' ', '').toLowerCase();
		ContactMaskBatch cmb = new ContactMaskBatch(orgName);

		Test.startTest();

			cmb.finish(null);

			Integer sentEmails = Limits.getEmailInvocations();
		Test.stopTest();

		System.assertEquals(1, sentEmails, 'Should have sent one Email.');
	}

	private static Contact queryOneContact() {
		return [
			SELECT Email
			FROM Contact
			LIMIT 1];
	}
}