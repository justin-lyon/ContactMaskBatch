/**
 * Invoke any Post Refresh Apex here.
 */
global class AfterRefreshScript implements SandboxPostCopy {
	public SandboxContext Context {get;set;}
	private Integer chunkSize = 5000;

	global void runApexClass(SandboxContext ctx) {
		this.Context = ctx;
		//System.debug('Organization Id: ' + ctx.organizationId());
		//System.debug('Sandbox Id: ' + ctx.sandboxId());
		//System.debug('Sandbox Name: ' + ctx.sandboxName());

		Database.executeBatch(new ContactMaskBatch(ctx), chunkSize);
	}
}