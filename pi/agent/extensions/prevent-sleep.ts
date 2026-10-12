import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { spawn, type ChildProcess } from "node:child_process";

let inhibitor: ChildProcess | undefined;

function startInhibitor() {
	if (inhibitor && !inhibitor.killed) return;

	const parentPid = String(process.pid);
	inhibitor = spawn(
		"systemd-inhibit",
		[
			"--what=sleep:idle",
			"--mode=block",
			"--who=Pi coding agent",
			"--why=Pi agent is actively working",
			"bash",
			"-lc",
			'while kill -0 "$1" 2>/dev/null; do sleep 30; done',
			"_",
			parentPid,
		],
		{ stdio: "ignore" },
	);

	inhibitor.once("exit", () => {
		inhibitor = undefined;
	});
}

function stopInhibitor() {
	if (inhibitor && !inhibitor.killed) {
		inhibitor.kill("SIGTERM");
	}
	inhibitor = undefined;
}

export default function (pi: ExtensionAPI) {
	// Start blocking sleep only when an agent turn begins.
	pi.on("before_agent_start", async () => {
		startInhibitor();
	});

	// Release once Pi is fully settled and will not auto-continue.
	pi.on("agent_settled", async () => {
		stopInhibitor();
	});

	// Safety cleanup for reloads, exits, and cancelled sessions.
	pi.on("session_shutdown", async () => {
		stopInhibitor();
	});

	pi.registerCommand("sleep-inhibit", {
		description: "Show whether Pi's sleep inhibitor is active",
		handler: async (_args, ctx) => {
			const active = !!inhibitor && !inhibitor.killed;
			ctx.ui.notify(
				active ? "Sleep inhibitor is active; this Pi agent is working" : "Sleep inhibitor is inactive; this Pi agent is idle",
				active ? "info" : "info",
			);
		},
	});
}
