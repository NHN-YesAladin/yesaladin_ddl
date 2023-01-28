USE `yesaladin_coupon_prod`;

CREATE TABLE `coupon_type_codes`
(
    `id`          INT         NOT NULL,
    `coupon_type` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `coupons`
(
    `id`                  BIGINT       NOT NULL AUTO_INCREMENT,
    `name`                VARCHAR(50)  NOT NULL,
    `is_unlimited`        BOOLEAN      NOT NULL,
    `file_uri`            VARCHAR(255) NULL,
    `duration`            INT          NULL,
    `expiration_date`     DATE         NULL,
    `coupon_type_code_id` INT          NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `coupons_type_code_ref` FOREIGN KEY (`coupon_type_code_id`) REFERENCES `coupon_type_codes` (`id`)
);

CREATE TABLE `point_coupons`
(
    `id`                  BIGINT NOT NULL AUTO_INCREMENT,
    `charge_point_amount` INT    NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `point_coupons_coupon_ref` FOREIGN KEY (`id`) REFERENCES `coupons` (`id`)
);

CREATE TABLE `amount_coupons`
(
    `id`                BIGINT  NOT NULL AUTO_INCREMENT,
    `min_order_amount`  INT     NOT NULL,
    `discount_amount`   INT     NULL,
    `can_be_overlapped` BOOLEAN NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `amount_coupons_coupon_ref` FOREIGN KEY (`id`) REFERENCES `coupons` (`id`)
);

CREATE TABLE `rate_coupons`
(
    `id`                  BIGINT  NOT NULL AUTO_INCREMENT,
    `min_order_amount`    INT     NOT NULL,
    `max_discount_amount` INT     NOT NULL,
    `discount_rate`       INT     NULL,
    `can_be_overlapped`   BOOLEAN NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `rate_coupons_coupon_ref` FOREIGN KEY (`id`) REFERENCES `coupons` (`id`)
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
    `ISBN`                 VARCHAR(50) NULL,
    `category_id`          BIGINT      NULL,
    `coupon_bound_code_id` INT         NOT NULL DEFAULT 1,
    PRIMARY KEY (`coupon_id`),
    CONSTRAINT `coupon_bounds_coupon_ref` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`),
    CONSTRAINT `coupon_bounds_code_ref` FOREIGN KEY (`coupon_bound_code_id`) REFERENCES `coupon_bound_codes` (`id`)
);

CREATE TABLE `coupon_given_state_code`
(
    `id`    INT         NOT NULL,
    `state` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `coupon_usage_state_code`
(
    `id`    INT         NOT NULL,
    `state` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `issued_coupons`
(
    `id`                         BIGINT   NOT NULL AUTO_INCREMENT,
    `coupon_code`                CHAR(36) NOT NULL,
    `created_datetime`           DATETIME NOT NULL,
    `expiration_date`            DATE     NOT NULL,
    `given_datetime`             DATETIME NULL,
    `used_datetime`              DATETIME NULL,
    `coupon_id`                  BIGINT   NOT NULL,
    `coupon_given_state_code_id` INT      NOT NULL,
    `coupon_usage_state_code_id` INT      NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `issued_coupons_coupon_ref` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`),
    CONSTRAINT `issued_coupons_coupon_given_state_code_ref` FOREIGN KEY (`coupon_given_state_code_id`) REFERENCES `coupon_given_state_code` (`id`),
    CONSTRAINT `issued_coupons_coupon_usage_state_code_ref` FOREIGN KEY (`coupon_usage_state_code_id`) REFERENCES `coupon_usage_state_code` (`id`)
);

CREATE TABLE `trigger_type_codes`
(
    `id`           INT         NOT NULL AUTO_INCREMENT,
    `trigger_type` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `triggers`
(
    `id`              INT    NOT NULL AUTO_INCREMENT,
    `trigger_code_id` INT    NOT NULL,
    `coupon_id`       BIGINT NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `triggers_code_ref` FOREIGN KEY (`trigger_code_id`) REFERENCES `trigger_type_codes` (`id`),
    CONSTRAINT `triggers_coupon_ref` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`)
);

CREATE TABLE `coupon_of_the_month_policy`
(
    `id`        INT    NOT NULL AUTO_INCREMENT,
    `coupon_id` BIGINT NOT NULL,
    `open_date` INT    NOT NULL,
    `open_time` TIME   NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `coupon_of_the_month_policy_coupon_ref` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`)
);

#쿠폰타입코드
INSERT INTO `coupon_type_codes`
VALUES (1, 'FIXED_PRICE'),
       (2, 'FIXED_RATE'),
       (3, 'POINT');

#쿠폰적용범위코드
INSERT INTO `coupon_bound_codes`
VALUES (1, 'ALL'),
       (2, 'CATEGORY'),
       (3, 'PRODUCT');

#트리거코드
INSERT INTO `trigger_type_codes`
VALUES (1, 'SIGN_UP'),
       (2, 'BIRTHDAY'),
       (101, 'MEMBER_GRADE_WHITE'),
       (102, 'MEMBER_GRADE_BRONZE'),
       (103, 'MEMBER_GRADE_SILVER'),
       (104, 'MEMBER_GRADE_GOLD'),
       (105, 'MEMBER_GRADE_PLATINUM');

INSERT INTO `coupon_given_state_code`
VALUES (1, 'NOT_GIVEN'),
       (2, 'PENDING_GIVE'),
       (3, 'GIVEN');

INSERT INTO `coupon_usage_state_code`
VALUES (1, 'NOT_USED'),
       (2, 'PENDING_USE'),
       (3, 'USED');
