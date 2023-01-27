CREATE TABLE `transport_status_codes` (
	`id`	int	NOT NULL,
	`status_code`	varchar(20)	NOT NULL,
	
	PRIMARY KEY (`id`)
);

CREATE TABLE `transports` (
	`id`	bigint	NOT NULL,
	`reception_datetime`	datetime	NOT NULL,
	`completion_datetime`	datetime	NULL,
	`order_id`	bigint	NOT NULL,
	`tracking_no`	varchar(255)	NOT NULL,
	`transport_status_code_id`	int	NOT NULL,
	
	PRIMARY KEY (`id`),
  CONSTRAINT `transports_tracking_no_unique` UNIQUE (`tracking_no`),
  CONSTRAINT `transports_status_ref` FOREIGN KEY (`transport_status_code_id`) REFERENCES `transport_status_codes` (`id`)
);

INSERT INTO `transport_status_codes`
VALUES (1, 'INPROGRESS');
INSERT INTO `transport_status_codes`
VALUES (2, 'COMPLETE');
