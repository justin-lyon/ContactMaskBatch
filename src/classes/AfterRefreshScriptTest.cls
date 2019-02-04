@isTest
private class AfterRefreshScriptTest {

	static TestMethod void contactMaskBatch_givenMask_shouldAppendMaskToContactEmail() {
		String orgId = UserInfo.getOrganizationId();
		String orgName = UserInfo.getOrganizationName().trim().replace(' ', '').toLowerCase();

		AfterRefreshScript afs = new AfterRefreshScript();

		Test.startTest();

			Test.testSandboxPostCopyScript(
				afs,
				orgId,
				orgId,
				orgName);

		Test.stopTest();

		System.assertEquals(orgName, afs.Context.sandboxName());
	}
}