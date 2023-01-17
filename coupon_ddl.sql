USE `yesaladin_coupon_prod`;

CREATE TABLE `coupon_codes`
(
    `id`          INT         NOT NULL,
    `coupon_type` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `coupon_issue_target_code`
(
    `id`           INT         NOT NULL,
    `issue_target` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `coupons`
(
    `id`                   BIGINT       NOT NULL AUTO_INCREMENT,
    `name`                 VARCHAR(50)  NOT NULL,
    `quantity`             INT          NOT NULL DEFAULT -1,
    `min_order_amount`     INT          NOT NULL,
    `max_discount_amount`  INT          NOT NULL,
    `discount_rate`        INT          NULL,
    `discount_amount`      INT          NULL,
    `can_be_overlapped`    BOOLEAN      NOT NULL,
    `file_uri`             VARCHAR(255) NULL,
    `open_datetime`        DATETIME     NOT NULL DEFAULT NOW(),
    `duration`             INT          NULL,
    `expiration_date`      DATE         NULL,
    `issuance_code_id`     INT          NOT NULL,
    `coupon_type_code_id`  INT          NOT NULL,
    `issue_target_code_id` INT          NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `coupons_type_code_ref` FOREIGN KEY (`coupon_type_code_id`) REFERENCES `coupon_codes` (`id`),
    CONSTRAINT `coupons_issuance_code_ref` FOREIGN KEY (`issuance_code_id`) REFERENCES `coupon_codes` (`id`),
    CONSTRAINT `coupons_issuance_target_code_ref` FOREIGN KEY (`issue_target_code_id`) REFERENCES `coupon_issue_target_code` (`id`)
);

CREATE TABLE `coupon_bound_codes`
(
    `id`    INT         NOT NULL,
    `bound` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `coupon_bounds`
(
    `coupon_id`            BIGINT      NOT NULL,
    `ISBN`                 VARCHAR(50) NOT NULL,
    `category_id`          BIGINT      NULL,
    `coupon_bound_code_id` INT         NOT NULL DEFAULT 1,
    PRIMARY KEY (`coupon_id`),
    CONSTRAINT `coupon_bounds_coupon_ref` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`),
    CONSTRAINT `coupon_bounds_code_ref` FOREIGN KEY (`coupon_bound_code_id`) REFERENCES `coupon_bound_codes` (`id`)
);

CREATE TABLE `coupon_issuances`
(
    `id`               BIGINT   NOT NULL AUTO_INCREMENT,
    `coupon_code`      CHAR(36) NOT NULL,
    `created_datetime` DATETIME NOT NULL,
    `is_given`         BOOLEAN  NOT NULL DEFAULT FALSE,
    `coupon_id`        BIGINT   NOT NULL,
    `expiration_date`  DATE     NOT NULL,

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
VALUES (1, 'FIXED_PRICE'),
       (2, 'FIXED_RATE'),
       (3, 'POINT'),
       (4, 'USER_DOWNLOAD'),
       (5, 'AUTO_ISSUANCE');

#쿠폰적용범위코드
INSERT INTO `coupon_bound_codes`
VALUES (1, 'ALL'),
       (2, 'CATEGORY'),
       (3, 'PRODUCT');

#쿠폰이벤트코드
INSERT INTO `coupon_event_codes`(`id`, `event`)
VALUES (1, 'SIGN_UP'),
       (2, 'BIRTHDAY'),
       (3, 'COUPON_OF_THE_MONTH'),
       (4, 'MEMBER_GRADE');

#쿠폰발급대상코드
INSERT INTO `coupon_issue_target_code`(`id`, `issue_target`)
VALUES (1, 'ALL'),
       (2, 'MEMBER_GRADE_WHITE'),
       (3, 'MEMBER_GRADE_BRONZE'),
       (4, 'MEMBER_GRADE_SILVER'),
       (5, 'MEMBER_GRADE_GOLD'),
       (6, 'MEMBER_GRADE_PLATINUM');
