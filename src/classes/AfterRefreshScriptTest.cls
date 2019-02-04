@isTest
private class AfterRefreshScriptTest {

	@TestSetup
	static void setupData() {
		Contact george = new Contact(
			LastName = 'Costanza',
			Email = 'gCostanza@gmail.com');
		insert george;
	}

	static TestMethod void contactMaskBatch_givenMask_shouldAppendMaskToContactEmail() {
		Contact preCopyGeorge = queryOneContact();
		String preCopyGeorgeEmail = preCopyGeorge.Email;

		String orgId = UserInfo.getOrganizationId();
		String orgName = UserInfo.getOrganizationName().trim().replace(' ', '').toLowerCase();

		Test.startTest();

			Test.testSandboxPostCopyScript(
				new AfterRefreshScript(),
				orgId,
				orgId,
				orgName);

		Test.stopTest();

		Contact postCopyGeorge = queryOneContact();

		System.assertNotEquals(preCopyGeorgeEmail, postCopyGeorge.Email, 'Email should have been updated.');
		System.assert(postCopyGeorge.Email.endsWith('.' + orgName), 'New Email ends with (dot)' + orgName + '.' + ' Actual: ' + postCopyGeorge.Email);
	}

	private static Contact queryOneContact() {
		return [
			SELECT Email
			FROM Contact
			LIMIT 1];
	}
}