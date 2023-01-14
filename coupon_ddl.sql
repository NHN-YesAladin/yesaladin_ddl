CREATE TABLE `coupon_codes`
(
    `id`          INT         NOT NULL,
    `coupon_type` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `coupons`
(
    `id`                  BIGINT       NOT NULL AUTO_INCREMENT,
    `name`                VARCHAR(50)  NOT NULL,
    `quantity`            INT          NOT NULL DEFAULT -1,
    `min_order_amount`    INT          NOT NULL,
    `max_discount_amount` INT          NOT NULL,
    `discount_rate`       INT          NULL,
    `discount_amount`     INT          NULL,
    `duplicatable`        BOOLEAN      NOT NULL,
    `file_uri`            VARCHAR(255) NULL,
    `coupon_type_code_id` INT          NOT NULL,
    `issuance_code_id`    INT          NOT NULL,
    `open_datetime`       DATETIME     NOT NULL DEFAULT NOW(),
    `duration`            INT          NULL,
    `expiration_date`     DATE         NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `coupons_type_code_ref` FOREIGN KEY (`coupon_type_code_id`) REFERENCES `coupon_codes` (`id`),
    CONSTRAINT `coupons_issuance_code_ref` FOREIGN KEY (`issuance_code_id`) REFERENCES `coupon_codes` (`id`)
);

CREATE TABLE `coupon_bound_codes`
(
    `id`     INT         NOT NULL,
    `bounds` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `coupon_bounds`
(
    `id`                   BIGINT      NOT NULL,
    `ISBN`                 VARCHAR(50) NOT NULL,
    `category_id`          BIGINT      NULL,
    `coupon_bound_code_id` INT         NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `coupon_bounds_coupon_ref` FOREIGN KEY (`id`) REFERENCES `coupons` (`id`),
    CONSTRAINT `coupon_bounds_code_ref` FOREIGN KEY (`coupon_bound_code_id`) REFERENCES `coupon_bound_codes` (`id`)
);

CREATE TABLE `coupon_issuances`
(
    `id`               BIGINT      NOT NULL AUTO_INCREMENT,
    `coupon_code`      VARCHAR(20) NOT NULL,
    `created_datetime` DATETIME    NOT NULL,
    `is_given`         BOOLEAN     NOT NULL DEFAULT FALSE,
    `coupon_id`        BIGINT      NOT NULL,
    `expiration_date`  DATE        NOT NULL,

    PRIMARY KEY (`id`),
    CONSTRAINT `coupon_issuances_code_unique` UNIQUE (`coupon_code`),
    CONSTRAINT `coupon_issuances_coupon_ref` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`)
);

CREATE TABLE `coupon_event_codes`
(
    `id`          INT          NOT NULL AUTO_INCREMENT,
    `event`       VARCHAR(100) NOT NULL,
    `description` VARCHAR(255) NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `coupon_events`
(
    `id`                   BIGINT NOT NULL AUTO_INCREMENT,
    `coupon_event_code_id` INT    NOT NULL,
    `coupon_id`            BIGINT NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `coupon_events_code_ref` FOREIGN KEY (`coupon_event_code_id`) REFERENCES `coupon_event_codes` (`id`),
    CONSTRAINT `coupon_events_coupon_ref` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`)
);

#쿠폰코드
INSERT INTO `coupon_codes`
VALUES (1, 'FIXED_PRICE');
INSERT INTO `coupon_codes`
VALUES (2, 'FIXED_RATE');
INSERT INTO `coupon_codes`
VALUES (3, 'POINT');
INSERT INTO `coupon_codes`
VALUES (4, 'USER_DOWNLOAD');
INSERT INTO `coupon_codes`
VALUES (5, 'AUTO_ISSUANCE');

#쿠폰적용범위코드
INSERT INTO `coupon_bound_codes`
VALUES (1, 'ALL');
INSERT INTO `coupon_bound_codes`
VALUES (2, 'CATEGORY');
INSERT INTO `coupon_bound_codes`
VALUES (3, 'INDIVIDUAL');