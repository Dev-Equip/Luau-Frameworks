shared["_db/info"] = {
	datastorename = "Donation Board v4",
	reconnecttimer = 2.5,
	minimumgrouprank = 254,
	version = 4.0,
}

shared["_db/keys"] = {
	settingsdata = "donationboard@settings",
	donationsdata = "donationboard@donations",
	transferreddata = "donationboard@transferreddata",
}

shared["_db/environment"] = {
	context = game:GetService("RunService"):IsClient() and "Client" or "Server",
	state = game:GetService("RunService"):IsRunning() and "Running" or "Stopped",
	runmode = game:GetService("RunService"):IsRunMode(),
	studiomode = game:GetService("RunService"):IsStudio(),
	debugmode = true,
}

shared["_db/receipts"] = {}
shared["_db/processors"] = {}
shared["_db/memory"] = {}
shared["_db/autosavetimer"] = 10

if (not shared["_db/environment"]) then
	game:GetService("MessagingService"):PublishAsync("_db/shared", {
		["_db/info"] = shared["_db/info"],
		["_db/keys"] = shared["_db/keys"],
	})
end
