ALTER TABLE `players`
	ADD COLUMN `rewardTimer` timestamp NULL DEFAULT current_timestamp(),
	ADD COLUMN `rewardPlaytime` int(11) DEFAULT 0