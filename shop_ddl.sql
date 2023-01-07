CREATE TABLE `accessors`
(
    `id`              BIGINT      NOT NULL AUTO_INCREMENT,
    `ip`              VARCHAR(20) NOT NULL,
    `domain`          VARCHAR(60) NOT NULL,
    `browser`         VARCHAR(30) NOT NULL,
    `access_device`   VARCHAR(60) NOT NULL,
    `access_datetime` DATETIME    NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `files`
(
    `id`              BIGINT      NOT NULL AUTO_INCREMENT,
    `uuid`            VARCHAR(50) NOT NULL,
    `extension`       VARCHAR(10) NOT NULL,
    `upload_datetime` DATETIME    NOT NULL DEFAULT NOW(),
    PRIMARY KEY (`id`)
);

CREATE TABLE `member_gender_codes`
(
    `id`     INT        NOT NULL,
    `gender` VARCHAR(6) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `member_grades`
(
    `id`                INT         NOT NULL,
    `name`              VARCHAR(15) NOT NULL,
    `base_order_amount` BIGINT      NOT NULL,
    `base_given_point`  BIGINT      NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `members`
(
    `id`              BIGINT       NOT NULL AUTO_INCREMENT,
    `nickname`        VARCHAR(15)  NOT NULL,
    `name`            VARCHAR(50)  NOT NULL,
    `login_id`        VARCHAR(15)  NOT NULL,
    `login_password`  VARCHAR(255) NOT NULL,
    `birth_year`      INT          NOT NULL,
    `birth_month`     INT          NOT NULL,
    `birth_day`       INT          NOT NULL,
    `email`           VARCHAR(100) NOT NULL,
    `sign_up_date`    DATE         NOT NULL,
    `withdrawal_date` DATE         NULL,
    `is_withdrawal`   BOOLEAN      NOT NULL DEFAULT FALSE,
    `is_blocked`      BOOLEAN      NOT NULL DEFAULT FALSE,
    `point`           BIGINT       NOT NULL,
    `member_grade_id` INT          NOT NULL,
    `gender_code`     INT          NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `members_nickname_unique` UNIQUE (`nickname`),
    CONSTRAINT `members_login_id_unique` UNIQUE (`login_id`),
    CONSTRAINT `members_email_unique` UNIQUE (`email`),
    CONSTRAINT `members_grade_ref` FOREIGN KEY (`member_grade_id`) REFERENCES `member_grades` (`id`),
    CONSTRAINT `members_gender_ref` FOREIGN KEY (`gender_code`) REFERENCES `member_gender_codes` (`id`)
);

CREATE TABLE `member_grade_histories`
(
    `id`                   BIGINT NOT NULL AUTO_INCREMENT,
    `update_date`          DATE   NOT NULL,
    `previous_paid_amount` BIGINT NOT NULL,
    `grade_id`             INT    NOT NULL,
    `member_id`            BIGINT NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `member_grade_histories_grade_ref` FOREIGN KEY (`grade_id`) REFERENCES `member_grades` (`id`),
    CONSTRAINT `member_grade_histories_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `point_codes`
(
    `id`   INT         NOT NULL,
    `point_code` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `point_histories`
(
    `created_datetime`      DATETIME NOT NULL,
    `member_id`             BIGINT   NOT NULL,
    `amount`                BIGINT   NOT NULL,
    `point_history_code_id` INT      NOT NULL,
    PRIMARY KEY (`created_datetime`, `member_id`),
    CONSTRAINT `point_histories_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
    CONSTRAINT `point_histories_point_code_ref` FOREIGN KEY (`point_history_code_id`) REFERENCES `point_codes` (`id`)
);

CREATE TABLE `roles`
(
    `id`   INT         NOT NULL,
    `name` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `member_roles`
(
    `id`        BIGINT NOT NULL AUTO_INCREMENT,
    `role_id`   INT    NOT NULL,
    `member_id` BIGINT NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `member_roles_role_ref` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
    CONSTRAINT `member_roles_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `chatting_rooms`
(
    `id`                 BIGINT   NOT NULL AUTO_INCREMENT,
    `created_datetime`   DATETIME NOT NULL,
    `finished_datetime`  DATETIME NULL,
    `last_chat_datetime` DATETIME NULL,
    `member_manager_id`  BIGINT   NOT NULL,
    `member_id`          BIGINT   NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `chatting_rooms_manager_ref` FOREIGN KEY (`member_manager_id`) REFERENCES `members` (`id`),
    CONSTRAINT `chatting_rooms_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `chatting_messages`
(
    `id`        BIGINT NOT NULL AUTO_INCREMENT,
    `order`     INT    NOT NULL,
    `content`   TEXT   NOT NULL,
    `chat_id`   BIGINT NOT NULL,
    `member_id` BIGINT NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `catting_messages_chatting_room_ref` FOREIGN KEY (`chat_id`) REFERENCES `chatting_rooms` (`id`),
    CONSTRAINT `catting_messages_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `admin_posts_codes`
(
    `id`        INT         NOT NULL,
    `post_code` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `admin_posts`
(
    `id`               BIGINT       NOT NULL AUTO_INCREMENT,
    `title`            VARCHAR(100) NOT NULL,
    `content`          TEXT         NOT NULL,
    `written_datetime` DATETIME     NOT NULL,
    `notice_code_id`   INT          NOT NULL,
    `member_id`        BIGINT       NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `admin_posts_posts_code_ref` FOREIGN KEY (`notice_code_id`) REFERENCES `admin_posts_codes` (`id`),
    CONSTRAINT `admin_posts_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `inquiry_codes`
(
    `id`           BIGINT      NOT NULL AUTO_INCREMENT,
    `inquiry_type` VARCHAR(15) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE `inquiries`
(
    `id`               BIGINT       NOT NULL AUTO_INCREMENT,
    `title`            VARCHAR(100) NOT NULL,
    `content`          TEXT         NOT NULL,
    `written_datetime` DATETIME     NOT NULL,
    `reply_id`         BIGINT       NOT NULL,
    `member_id`        BIGINT       NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `inquiries_reply_ref` FOREIGN KEY (`reply_id`) REFERENCES `inquiries` (`id`),
    CONSTRAINT `inquiries_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `inquiry_comments`
(
    `id`               BIGINT   NOT NULL AUTO_INCREMENT,
    `content`          TEXT     NOT NULL,
    `written_datetime` DATETIME NOT NULL,
    `inquiry_id`       BIGINT   NOT NULL,
    `comment_id`       BIGINT   NOT NULL,
    `member_id`        BIGINT   NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `inquiry_comments_comment_ref` FOREIGN KEY (`comment_id`) REFERENCES `inquiry_comments` (`id`),
    CONSTRAINT `inquiry_comments_inquiry_ref` FOREIGN KEY (`inquiry_id`) REFERENCES `inquiries` (`id`),
    CONSTRAINT `inquiry_comments_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `publishers`
(
    `id`   BIGINT      NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `product_saving_method_codes`
(
    `id`            INT         NOT NULL,
    `saving_method` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `product_type_codes`
(
    `id`   INT         NOT NULL,
    `type` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `total_discount_rates`
(
    `id`            INT NOT NULL,
    `discount_rate` INT NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `subscribe_products`
(
    `id`   BIGINT     NOT NULL,
    `ISSN` VARCHAR(9) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `products`
(
    `id`                            BIGINT       NOT NULL AUTO_INCREMENT,
    `ISBN`                          VARCHAR(50)  NOT NULL,
    `title`                         VARCHAR(255) NOT NULL,
    `contents`                      TEXT         NOT NULL,
    `description`                   TEXT         NOT NULL,
    `actual_price`                  BIGINT       NOT NULL,
    `discount_rate`                 INT          NULL,
    `is_separately_discount`        BOOLEAN      NOT NULL DEFAULT FALSE,
    `given_point_rate`              INT          NOT NULL,
    `is_given_point`                BOOLEAN      NOT NULL,
    `subscribe_product_id`          BIGINT       NULL,
    `is_subscription_available`     BOOLEAN      NOT NULL,
    `is_sale`                       BOOLEAN      NOT NULL DEFAULT TRUE,
    `is_forced_out_of_stock`        BOOLEAN      NOT NULL DEFAULT FALSE,
    `quantity`                      BIGINT       NOT NULL,
    `published_date`                DATE         NULL,
    `preferential_show_ranking`     INT          NOT NULL,
    `publisher_id`                  BIGINT       NOT NULL,
    `file_id`                       BIGINT       NOT NULL,
    `product_type_code_id`          INT          NOT NULL,
    `discount_rate_id`              INT          NULL,
    `product_saving_method_code_id` INT          NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `products_isbn_unique` UNIQUE (`ISBN`),
    CONSTRAINT `products_subscribe_product_ref` FOREIGN KEY (`subscribe_product_id`) REFERENCES `subscribe_products` (`id`),
    CONSTRAINT `products_publisher_ref` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`id`),
    CONSTRAINT `products_file_ref` FOREIGN KEY (`file_id`) REFERENCES `files` (`id`),
    CONSTRAINT `products_type_code_ref` FOREIGN KEY (`product_type_code_id`) REFERENCES `product_type_codes` (`id`),
    CONSTRAINT `products_discount_rate_ref` FOREIGN KEY (`discount_rate_id`) REFERENCES `total_discount_rates` (`id`),
    CONSTRAINT `products_saving_method_code_ref` FOREIGN KEY (`product_saving_method_code_id`) REFERENCES `product_saving_method_codes` (`id`)
);


CREATE TABLE `categories`
(
    `id`        BIGINT      NOT NULL,
    `name`      VARCHAR(30) NOT NULL,
    `is_shown`  BOOLEAN     NOT NULL DEFAULT TRUE,
    `order`     INT         NULL,
    `parent_id` BIGINT      NULL,
    `depth`     INT         NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `categories_parent_ref` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`)
);

CREATE TABLE `product_categories`
(
    `category_id` BIGINT NOT NULL,
    `product_id`  BIGINT NOT NULL,
    PRIMARY KEY (`category_id`, `product_id`),
    CONSTRAINT `product_categories_category_ref` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
    CONSTRAINT `product_categories_product_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
);

CREATE TABLE `tags`
(
    `id`   BIGINT      NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `product_tags`
(
    `product_id` BIGINT NOT NULL,
    `tag_id`     BIGINT NOT NULL,
    PRIMARY KEY (`product_id`, `tag_id`),
    CONSTRAINT `product_tags_product_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `product_tags_tag_ref` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
);

CREATE TABLE `related_products`
(
    `product_main_id` BIGINT NOT NULL,
    `product_sub_id`  BIGINT NOT NULL,
    PRIMARY KEY (`product_main_id`, `product_sub_id`),
    CONSTRAINT `related_products_main_ref` FOREIGN KEY (`product_main_id`) REFERENCES `products` (`id`),
    CONSTRAINT `related_products_sub_ref` FOREIGN KEY (`product_sub_id`) REFERENCES `products` (`id`)
);

CREATE TABLE `writing`
(
    `id`          BIGINT      NOT NULL AUTO_INCREMENT,
    `author_name` VARCHAR(50) NOT NULL,
    `product_id`  BIGINT      NOT NULL,
    `member_id`   BIGINT      NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `writing_product_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `writing_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);


CREATE TABLE `wishlists`
(
    `id`                  BIGINT   NOT NULL AUTO_INCREMENT,
    `registered_datetime` DATETIME NOT NULL DEFAULT NOW(),
    `product_id`          BIGINT   NOT NULL,
    `member_id`           BIGINT   NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `wishlists_product_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `wishlists_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `restock_notifications`
(
    `product_id`  BIGINT  NOT NULL,
    `member_id`   BIGINT  NOT NULL,
    `is_notified` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`product_id`, `member_id`),
    CONSTRAINT `restock_notifications_product_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `restock_notifications_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `product_inquiries`
(
    `id`         BIGINT  NOT NULL AUTO_INCREMENT,
    `is_public`  BOOLEAN NOT NULL,
    `question`   TEXT    NOT NULL,
    `answer`     TEXT    NULL,
    `product_id` BIGINT  NOT NULL,
    `member_id`  BIGINT  NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `product_inquiries_product_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `product_inquiries_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `coupon_codes`
(
    `id`          INT         NOT NULL,
    `coupon_type` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `coupons`
(
    `id`                  BIGINT      NOT NULL AUTO_INCREMENT,
    `name`                VARCHAR(50) NOT NULL,
    `min_order_amount`    INT         NOT NULL,
    `max_discount_amount` INT         NOT NULL,
    `discount_amount`     INT         NULL,
    `discount_rate`       INT         NULL,
    `duplicatable`        BOOLEAN     NOT NULL,
    `coupon_type_code_id` INT         NOT NULL,
    `file_id`             BIGINT      NOT NULL,
    `issuance_code_id`    INT         NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `coupons_type_code_ref` FOREIGN KEY (`coupon_type_code_id`) REFERENCES `coupon_codes` (`id`),
    CONSTRAINT `coupons_file_ref` FOREIGN KEY (`file_id`) REFERENCES `files` (`id`),
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
    `id`                   BIGINT NOT NULL,
    `product_id`           BIGINT NULL,
    `category_id`          BIGINT NULL,
    `coupon_bound_code_id` INT    NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `coupon_bounds_coupon_ref` FOREIGN KEY (`id`) REFERENCES `coupons` (`id`),
    CONSTRAINT `coupon_bounds_product_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `coupon_bounds_category_ref` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
    CONSTRAINT `coupon_bounds_code_ref` FOREIGN KEY (`coupon_bound_code_id`) REFERENCES `coupon_bound_codes` (`id`)
);

CREATE TABLE `coupon_issuances`
(
    `id`              BIGINT      NOT NULL AUTO_INCREMENT,
    `code`            VARCHAR(20) NOT NULL,
    `is_used`         BOOLEAN     NOT NULL DEFAULT FALSE,
    `issue_datetime`  DATETIME    NOT NULL,
    `duration`        INT         NULL,
    `expiration_date` DATE        NOT NULL,
    `use_datetime`    DATETIME    NULL,
    `member_id`       BIGINT      NOT NULL,
    `coupon_id`       BIGINT      NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `coupon_issuances_code_unique` UNIQUE (`code`),
    CONSTRAINT `coupon_issuances_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
    CONSTRAINT `coupon_issuances_coupon_ref` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`)
);

CREATE TABLE `member_addresses`
(
    `id`         BIGINT       NOT NULL AUTO_INCREMENT,
    `address`    VARCHAR(255) NOT NULL,
    `is_default` BOOLEAN      NOT NULL,
    `member_id`  BIGINT       NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `member_addresses_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `order_codes`
(
    `id`         INT         NOT NULL,
    `order_code` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `orders`
(
    `id`                      BIGINT      NOT NULL AUTO_INCREMENT,
    `order_number`            VARCHAR(18) NOT NULL,
    `order_datetime`          DATETIME    NOT NULL,
    `expected_transport_date` DATE        NOT NULL,
    `is_hidden`               BOOLEAN     NOT NULL DEFAULT FALSE,
    `used_point`              BIGINT      NOT NULL,
    `shipping_fee`            INT         NOT NULL,
    `wrapping_fee`            INT         NOT NULL,
    `order_code_id`           INT         NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `orders_order_number_unique` UNIQUE (`order_number`)
);

CREATE TABLE `non_member_orders`
(
    `order_id`     BIGINT       NOT NULL,
    `address`      VARCHAR(255) NOT NULL,
    `name`         VARCHAR(20)  NOT NULL,
    `phone_number` VARCHAR(13)  NOT NULL,
    PRIMARY KEY (`order_id`),
    CONSTRAINT `non_member_orders_order_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
);

CREATE TABLE `member_orders`
(
    `order_id`          BIGINT NOT NULL,
    `member_address_id` BIGINT NOT NULL,
    `member_id`         BIGINT NOT NULL,
    PRIMARY KEY (`order_id`),
    CONSTRAINT `member_orders_order_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
    CONSTRAINT `member_orders_member_address_ref` FOREIGN KEY (`member_address_id`) REFERENCES `member_addresses` (`id`),
    CONSTRAINT `member_orders_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `subscribes`
(
    `id`                   BIGINT NOT NULL AUTO_INCREMENT,
    `interval_month`       INT    NOT NULL,
    `next_renewal_date`    DATE   NOT NULL,
    `member_address_id`    BIGINT NOT NULL,
    `member_id`            BIGINT NOT NULL,
    `subscribe_product_id` BIGINT NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `subscribes_member_address_ref` FOREIGN KEY (`member_address_id`) REFERENCES `member_addresses` (`id`),
    CONSTRAINT `subscribes_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
    CONSTRAINT `subscribes_subscribe_product_ref` FOREIGN KEY (`subscribe_product_id`) REFERENCES `subscribe_products` (`id`)
);

CREATE TABLE `order_products`
(
    `id`          BIGINT  NOT NULL AUTO_INCREMENT,
    `quantity`    INT     NOT NULL,
    `is_canceled` BOOLEAN NOT NULL DEFAULT FALSE,
    `product_id`  BIGINT  NOT NULL,
    `order_id`    BIGINT  NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `order_products_product_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `order_products_order_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
);

CREATE TABLE `order_status_codes`
(
    `id`     INT         NOT NULL,
    `status` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `order_status_change_logs`
(
    `change_datetime`      DATETIME NOT NULL,
    `order_id`             BIGINT   NOT NULL,
    `order_status_code_id` INT      NOT NULL,
    PRIMARY KEY (`change_datetime`, `order_id`),
    CONSTRAINT `order_status_change_logs_order_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
    CONSTRAINT `order_status_change_logs_status_code_ref` FOREIGN KEY (`order_status_code_id`) REFERENCES `order_status_codes` (`id`)
);

CREATE TABLE `order_used_coupons`
(
    `order_id`           BIGINT NOT NULL,
    `coupon_issuance_id` BIGINT NOT NULL,
    PRIMARY KEY (`order_id`, `coupon_issuance_id`),
    CONSTRAINT `order_used_coupons_order_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
    CONSTRAINT `order_used_coupons_coupon_issuance_ref` FOREIGN KEY (`coupon_issuance_id`) REFERENCES `coupon_issuances` (`id`)
);

CREATE TABLE `subscribe_orders`
(
    `order_id`       BIGINT  NOT NULL,
    `subscribe_id`   BIGINT  NOT NULL,
    `is_transported` BOOLEAN NOT NULL,
    `expected_date`   DATE    NOT NULL,
    PRIMARY KEY (`order_id`, `subscribe_id`),
    CONSTRAINT `subscribe_orders_order_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
    CONSTRAINT `subscribe_orders_subscribe_ref` FOREIGN KEY (`subscribe_id`) REFERENCES `subscribes` (`id`)
);

CREATE TABLE `reviews`
(
    `id`               BIGINT       NOT NULL AUTO_INCREMENT,
    `order_product_id` BIGINT       NOT NULL,
    `comment`          VARCHAR(255) NOT NULL,
    `gpa`              INT          NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `reviews_order_product_ref` FOREIGN KEY (`order_product_id`) REFERENCES `order_products` (`id`)
);

CREATE TABLE `review_image_groups`
(
    `id`        BIGINT NOT NULL AUTO_INCREMENT,
    `file_id`   BIGINT NOT NULL,
    `review_id` BIGINT NOT NULL,
    `order`     INT    NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `review_image_groups_file_ref` FOREIGN KEY (`file_id`) REFERENCES `files` (`id`),
    CONSTRAINT `review_image_groups_review_ref` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`id`)
);

CREATE TABLE `payment_codes`
(
    `id`           INT         NOT NULL,
    `payment_code` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `payments`
(
    `id`                   VARCHAR(200) NOT NULL,
    `last_transaction_key` VARCHAR(64)  NOT NULL,
    `order_name`           VARCHAR(100) NOT NULL,
    `method`               VARCHAR(50)  NOT NULL,
    `currency`             CHAR(3)      NOT NULL,
    `total_amount`         BIGINT       NOT NULL,
    `balance_amount`       BIGINT       NOT NULL,
    `supplied_amount`      BIGINT       NOT NULL,
    `tax_free_amount`      BIGINT       NOT NULL,
    `vat`                  BIGINT       NOT NULL,
    `status`               VARCHAR(20)  NOT NULL,
    `requested_datetime`   DATETIME     NOT NULL,
    `approved_datetime`    DATETIME     NOT NULL,
    `order_id`             BIGINT       NOT NULL,
    `payment_code_id`      INT          NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `payments_order_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
    CONSTRAINT `payments_code_id` FOREIGN KEY (`payment_code_id`) REFERENCES `payment_codes` (`id`)
);

CREATE TABLE `payment_cards`
(
    `payment_id`              VARCHAR(200) NOT NULL,
    `amount`                  BIGINT       NOT NULL,
    `issuer_code`             VARCHAR(50)  NOT NULL,
    `acquirer_code`           VARCHAR(50)  NOT NULL,
    `number`                  VARCHAR(20)  NOT NULL,
    `installment_plan_months` INT          NOT NULL,
    `approve_no`              VARCHAR(8)   NOT NULL,
    `use_card_point`          BOOLEAN      NOT NULL,
    `acquire_status`          VARCHAR(20)  NOT NULL,
    `is_interest_free`        BOOLEAN      NOT NULL,
    `interest_payer`          VARCHAR(20)  NOT NULL,
    `card_code_id`            INT          NOT NULL,
    `owner_code_id`           INT          NOT NULL,
    PRIMARY KEY (`payment_id`),
    CONSTRAINT `payment_cards_payment_ref` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`),
    CONSTRAINT `payment_cards_card_code_ref` FOREIGN KEY (`card_code_id`) REFERENCES `payment_codes` (`id`),
    CONSTRAINT `payment_cards_owner_code_ref` FOREIGN KEY (`owner_code_id`) REFERENCES `payment_codes` (`id`)
);

CREATE TABLE `payment_cancels`
(
    `payment_id`               VARCHAR(200) NOT NULL,
    `cancel_amount`            BIGINT       NOT NULL,
    `cancel_reason`            VARCHAR(200) NOT NULL,
    `tax_free_amount`          BIGINT       NOT NULL,
    `tax_exemption_amount`     BIGINT       NOT NULL,
    `refundable_amount`        BIGINT       NOT NULL,
    `easy_pay_discount_amount` BIGINT       NOT NULL,
    `canceled_datetime`        DATETIME     NOT NULL,
    `transaction_key`          VARCHAR(64)  NOT NULL,
    PRIMARY KEY (`payment_id`),
    CONSTRAINT `payment_cancels_payment_ref` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`)
);

#=======================================================================================================================

# 회원 등급
INSERT INTO `member_grades`
VALUES (1, 'WHITE', 100000, 1000);
INSERT INTO `member_grades`
VALUES (2, 'SILVER', 200000, 2000);
INSERT INTO `member_grades`
VALUES (3, 'GOLD', 300000, 5000);
INSERT INTO `member_grades`
VALUES (4, 'PLATINUM', 500000, 10000);

# 회원 성별
INSERT INTO `member_gender_codes`
VALUES (1, 'MALE');
INSERT INTO `member_gender_codes`
VALUES (2, 'FEMALE');

# 권한
INSERT INTO `roles`
VALUES (1, 'ROLE_USER');
INSERT INTO `roles`
VALUES (2, 'ROLE_AUTHOR');
INSERT INTO `roles`
VALUES (3, 'ROLE_ADMIN');

# 관리자용 글 코드
INSERT INTO `admin_posts_codes`
VALUES (1, 'FAQ');
INSERT INTO `admin_posts_codes`
VALUES (2, 'NOTICE');

# 문의 불량 코드
INSERT INTO `inquiry_codes`
VALUES (1, 'QUESTION');
INSERT INTO `inquiry_codes`
VALUES (2, 'DEFECT');

# 포인트 코드
INSERT INTO `point_codes`
VALUES (1, 'USE');
INSERT INTO `point_codes`
VALUES (2, 'SAVE');

# 쿠폰 코드
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

# 쿠폰 적용범위 코드
INSERT INTO `coupon_bound_codes`
VALUES (1, 'ALL');
INSERT INTO `coupon_bound_codes`
VALUES (2, 'CATEGORY');
INSERT INTO `coupon_bound_codes`
VALUES (3, 'INDIVIDUAL');

# 상품 적립 방식 코드
INSERT INTO `product_saving_method_codes`
VALUES (1, 'ACTUAL_PURCHASE_PRICE');
INSERT INTO `product_saving_method_codes`
VALUES (2, 'SELLING_PRICE');

# 상품 유형 코드
INSERT INTO `product_type_codes`
VALUES (1, 'BESTSELLER');
INSERT INTO `product_type_codes`
VALUES (2, 'RECOMMENDATION');
INSERT INTO `product_type_codes`
VALUES (3, 'NEWBOOK');
INSERT INTO `product_type_codes`
VALUES (4, 'POPULARITY');
INSERT INTO `product_type_codes`
VALUES (5, 'DISCOUNTS');
INSERT INTO `product_type_codes`
VALUES (6, 'NULL');

# 주문 코드
INSERT INTO `order_codes`
VALUES (1, 'NON_MEMBER_ORDER');
INSERT INTO `order_codes`
VALUES (2, 'MEMBER_ORDER');
INSERT INTO `order_codes`
VALUES (3, 'MEMBER_SUBSCRIBE');

# 주문 상태 코드
INSERT INTO `order_status_codes`
VALUES (1, 'ORDER');
INSERT INTO `order_status_codes`
VALUES (2, 'DEPOSIT');
INSERT INTO `order_status_codes`
VALUES (3, 'READY');
INSERT INTO `order_status_codes`
VALUES (4, 'DELIVERY');
INSERT INTO `order_status_codes`
VALUES (5, 'COMPLETE');
INSERT INTO `order_status_codes`
VALUES (6, 'REFUND');

# 결제 코드
INSERT INTO `payment_codes`
VALUES (1, 'INDIVIDUAL');
INSERT INTO `payment_codes`
VALUES (2, 'COMPANY');
INSERT INTO `payment_codes`
VALUES (3, 'CREDIT');
INSERT INTO `payment_codes`
VALUES (4, 'CHECK');
INSERT INTO `payment_codes`
VALUES (5, 'NORMAL');
INSERT INTO `payment_codes`
VALUES (6, 'AUTO');