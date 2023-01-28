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
    `id`              BIGINT       NOT NULL AUTO_INCREMENT,
    `url`             VARCHAR(180) NOT NULL,
    `upload_datetime` DATETIME     NOT NULL DEFAULT NOW(),
    PRIMARY KEY (`id`),
    CONSTRAINT `files_url_unique` UNIQUE (`url`)
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
    `phone`           VARCHAR(11)  NOT NULL,
    `sign_up_date`    DATE         NOT NULL,
    `withdrawal_date` DATE         NULL,
    `is_withdrawal`   BOOLEAN      NOT NULL DEFAULT FALSE,
    `is_blocked`      BOOLEAN      NOT NULL DEFAULT FALSE,
    `blocked_reason`  VARCHAR(255) NULL,
    `blocked_date`    DATE         NULL,
    `unblocked_date`  DATE         NULL,
    `member_grade_id` INT          NOT NULL,
    `gender_code`     INT          NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `members_nickname_unique` UNIQUE (`nickname`),
    CONSTRAINT `members_login_id_unique` UNIQUE (`login_id`),
    CONSTRAINT `members_email_unique` UNIQUE (`email`),
    CONSTRAINT `members_phone_unique` UNIQUE (`phone`),
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

CREATE TABLE `member_coupons`
(
    `id`                BIGINT      NOT NULL AUTO_INCREMENT,
    `member_id`         BIGINT      NOT NULL,
    `coupon_code`       VARCHAR(20) NOT NULL,
    `coupon_group_code` CHAR(36)    NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `member_coupons_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
    CONSTRAINT `member_coupons_code_unique` UNIQUE (`coupon_code`)
);

CREATE TABLE `member_addresses`
(
    `id`         BIGINT       NOT NULL AUTO_INCREMENT,
    `address`    VARCHAR(255) NOT NULL,
    `is_default` BOOLEAN      NOT NULL,
    `is_deleted` BOOLEAN      NOT NULL,
    `member_id`  BIGINT       NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `member_addresses_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `point_codes`
(
    `id`   INT         NOT NULL,
    `code` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `point_histories`
(
    `id`               BIGINT   NOT NULL AUTO_INCREMENT,
    `amount`           BIGINT   NOT NULL,
    `created_datetime` DATETIME NOT NULL,
    `member_id`        BIGINT   NOT NULL,
    `point_code_id`    INT      NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `point_histories_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
    CONSTRAINT `point_histories_point_code_ref` FOREIGN KEY (`point_code_id`) REFERENCES `point_codes` (`id`)
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
    PRIMARY KEY (`id`)
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
    `id`   BIGINT     NOT NULL AUTO_INCREMENT,
    `ISSN` VARCHAR(9) NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `subscribe_products_issn_unique` UNIQUE (`ISSN`)
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
    `preferential_show_ranking`     INT          NOT NULL,
    `thumbnail_file_id`             BIGINT       NOT NULL,
    `ebook_file_id`                 BIGINT       NULL,
    `product_type_code_id`          INT          NOT NULL,
    `discount_rate_id`              INT          NULL,
    `product_saving_method_code_id` INT          NOT NULL,
    `is_deleted`                    BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    CONSTRAINT `products_isbn_unique` UNIQUE (`ISBN`),
    CONSTRAINT `products_subscribe_product_ref` FOREIGN KEY (`subscribe_product_id`) REFERENCES `subscribe_products` (`id`),
    CONSTRAINT `products_thumbnail_file_ref` FOREIGN KEY (`thumbnail_file_id`) REFERENCES `files` (`id`),
    CONSTRAINT `products_ebook_file_ref` FOREIGN KEY (`ebook_file_id`) REFERENCES `files` (`id`),
    CONSTRAINT `products_type_code_ref` FOREIGN KEY (`product_type_code_id`) REFERENCES `product_type_codes` (`id`),
    CONSTRAINT `products_discount_rate_ref` FOREIGN KEY (`discount_rate_id`) REFERENCES `total_discount_rates` (`id`),
    CONSTRAINT `products_saving_method_code_ref` FOREIGN KEY (`product_saving_method_code_id`) REFERENCES `product_saving_method_codes` (`id`)
);


CREATE TABLE `publish`
(
    `product_id`     BIGINT NOT NULL,
    `publisher_id`   BIGINT NOT NULL,
    `published_date` DATE   NOT NULL,
    PRIMARY KEY (`product_id`, `publisher_id`),
    CONSTRAINT `publish_products_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `publish_publishers_ref` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`id`)
);


CREATE TABLE `categories`
(
    `id`        BIGINT      NOT NULL,
    `name`      VARCHAR(30) NOT NULL,
    `is_shown`  BOOLEAN     NOT NULL DEFAULT TRUE,
    `order`     INT         NULL,
    `parent_id` BIGINT      NULL,
    `depth`     INT         NOT NULL,
    `disable`   BOOLEAN     NOT NULL DEFAULT FALSE,
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

CREATE TABLE `authors`
(
    `id`        BIGINT      NOT NULL AUTO_INCREMENT,
    `name`      VARCHAR(50) NOT NULL,
    `member_id` BIGINT      NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `author_member_ref` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
);

CREATE TABLE `writing`
(
    `product_id` BIGINT NOT NULL,
    `author_id`  BIGINT NOT NULL,
    PRIMARY KEY (`product_id`, `author_id`),
    CONSTRAINT `writing_product_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `writing_author_ref` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`)
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

CREATE TABLE `order_codes`
(
    `id`         INT         NOT NULL,
    `order_code` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `orders`
(
    `id`                      BIGINT       NOT NULL AUTO_INCREMENT,
    `order_number`            VARCHAR(18)  NOT NULL,
    `name`                    VARCHAR(255) NOT NULL,
    `order_datetime`          DATETIME     NOT NULL,
    `expected_transport_date` DATE         NULL,
    `is_hidden`               BOOLEAN      NOT NULL DEFAULT FALSE,
    `used_point`              BIGINT       NOT NULL,
    `shipping_fee`            INT          NOT NULL,
    `wrapping_fee`            INT          NOT NULL,
    `order_code_id`           INT          NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `orders_order_number_unique` UNIQUE (`order_number`)
);

CREATE TABLE `non_member_orders`
(
    `order_id`     BIGINT       NOT NULL,
    `address`      VARCHAR(255) NOT NULL,
    `name`         VARCHAR(20)  NOT NULL,
    `phone_number` VARCHAR(11)  NOT NULL,
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

CREATE TABLE `order_products`
(
    `id`          BIGINT  NOT NULL AUTO_INCREMENT,
    `quantity`    INT     NOT NULL,
    `is_canceled` BOOLEAN NOT NULL DEFAULT FALSE,
    `product_id`  BIGINT  NOT NULL,
    `order_id`    BIGINT  NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `order_products_product_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `order_products_member_order_ref` FOREIGN KEY (`order_id`) REFERENCES `member_orders` (`order_id`)
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
    `member_order_id`  BIGINT NOT NULL,
    `member_coupon_id` BIGINT NOT NULL,
    PRIMARY KEY (`member_order_id`, `member_coupon_id`),
    CONSTRAINT `order_used_coupons_member_order_ref` FOREIGN KEY (`member_order_id`) REFERENCES `member_orders` (`order_id`),
    CONSTRAINT `order_used_coupons_coupon_issuance_ref` FOREIGN KEY (`member_coupon_id`) REFERENCES `member_coupons` (`id`)
);

CREATE TABLE `subscribes`
(
    `order_id`             BIGINT NOT NULL,
    `expected_day`         INT    NOT NULL,
    `interval_month`       INT    NOT NULL,
    `next_renewal_date`    DATE   NOT NULL,
    `subscribe_product_id` BIGINT NOT NULL,
    PRIMARY KEY (`order_id`),
    CONSTRAINT `subscribe_orders_member_order_ref` FOREIGN KEY (`order_id`) REFERENCES `member_orders` (`order_id`),
    CONSTRAINT `subscribe_orders_subscribe_product_ref` FOREIGN KEY (`subscribe_product_id`) REFERENCES `subscribe_products` (`id`)
);

CREATE TABLE `subscribe_order_lists`
(
    `id`                 BIGINT  NOT NULL AUTO_INCREMENT,
    `is_transported`     BOOLEAN NOT NULL,
    `subscribe_order_id` BIGINT  NOT NULL,
    `member_order_id`    BIGINT  NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `subscribes_member_order_ref` FOREIGN KEY (`member_order_id`) REFERENCES `member_orders` (`order_id`),
    CONSTRAINT `subscribes_subscribe_order_ref` FOREIGN KEY (`subscribe_order_id`) REFERENCES `subscribes` (`order_id`)
);

CREATE TABLE `reviews`
(
    `id`               BIGINT NOT NULL AUTO_INCREMENT,
    `order_product_id` BIGINT NOT NULL,
    `comment`          TEXT   NOT NULL,
    `gpa`              INT    NOT NULL,
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

CREATE TABLE `payment_card_acquirer_codes`
(
    `id`            INT         NOT NULL,
    `code`          VARCHAR(3)  NOT NULL,
    `acquirer_name` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `payments`
(
    `id`                   VARCHAR(200) NOT NULL,
    `last_transaction_key` VARCHAR(64)  NULL,
    `order_name`           VARCHAR(100) NOT NULL,
    `currency`             CHAR(3)      NOT NULL,
    `total_amount`         BIGINT       NOT NULL,
    `balance_amount`       BIGINT       NOT NULL,
    `supplied_amount`      BIGINT       NOT NULL,
    `tax_free_amount`      BIGINT       NOT NULL,
    `vat`                  BIGINT       NOT NULL,
    `requested_datetime`   DATETIME     NOT NULL,
    `approved_datetime`    DATETIME     NOT NULL,
    `order_id`             BIGINT       NOT NULL,
    `payment_code_id`      INT          NOT NULL,
    `method_code_id`       INT          NOT NULL,
    `status_code_id`       INT          NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `payments_order_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
    CONSTRAINT `payments_payment_code_ref` FOREIGN KEY (`payment_code_id`) REFERENCES `payment_codes` (`id`),
    CONSTRAINT `payments_method_code_ref` FOREIGN KEY (`method_code_id`) REFERENCES `payment_codes` (`id`),
    CONSTRAINT `payments_status_code_ref` FOREIGN KEY (`status_code_id`) REFERENCES `payment_codes` (`id`)
);

CREATE TABLE `payment_cards`
(
    `payment_id`              VARCHAR(200) NOT NULL,
    `amount`                  BIGINT       NOT NULL,
    `number`                  VARCHAR(20)  NOT NULL,
    `installment_plan_months` INT          NOT NULL,
    `approve_no`              VARCHAR(8)   NOT NULL,
    `use_card_point`          BOOLEAN      NOT NULL,
    `is_interest_free`        BOOLEAN      NOT NULL,
    `interest_payer`          VARCHAR(20)  NULL,
    `card_code_id`            INT          NOT NULL,
    `owner_code_id`           INT          NOT NULL,
    `acquire_status_code_id`  INT          NOT NULL,
    `issuer_code_id`          INT          NOT NULL,
    `acquirer_code_id`        INT          NOT NULL,
    PRIMARY KEY (`payment_id`),
    CONSTRAINT `payment_cards_payment_ref` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`),
    CONSTRAINT `payment_cards_card_code_ref` FOREIGN KEY (`card_code_id`) REFERENCES `payment_codes` (`id`),
    CONSTRAINT `payment_cards_owner_code_ref` FOREIGN KEY (`owner_code_id`) REFERENCES `payment_codes` (`id`),
    CONSTRAINT `payment_acquire_status_code_ref` FOREIGN KEY (`acquire_status_code_id`) REFERENCES `payment_codes` (`id`),
    CONSTRAINT `payment_cards_issuer_code_ref` FOREIGN KEY (`issuer_code_id`) REFERENCES `payment_card_acquirer_codes` (`id`),
    CONSTRAINT `payment_cards_acquirer_code_ref` FOREIGN KEY (`acquirer_code_id`) REFERENCES `payment_card_acquirer_codes` (`id`)
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

#회원등급
INSERT INTO `member_grades`
VALUES (1, 'WHITE', 0, 0);
INSERT INTO `member_grades`
VALUES (2, 'BRONZE', 100000, 1000);
INSERT INTO `member_grades`
VALUES (3, 'SILVER', 200000, 2000);
INSERT INTO `member_grades`
VALUES (4, 'GOLD', 300000, 5000);
INSERT INTO `member_grades`
VALUES (5, 'PLATINUM', 500000, 10000);

#회원성별
INSERT INTO `member_gender_codes`
VALUES (1, 'MALE');
INSERT INTO `member_gender_codes`
VALUES (2, 'FEMALE');

#권한
INSERT INTO `roles`
VALUES (1, 'ROLE_USER');
INSERT INTO `roles`
VALUES (2, 'ROLE_AUTHOR');
INSERT INTO `roles`
VALUES (3, 'ROLE_ADMIN');

#관리자용글코드
INSERT INTO `admin_posts_codes`
VALUES (1, 'FAQ');
INSERT INTO `admin_posts_codes`
VALUES (2, 'NOTICE');

#문의불량코드
INSERT INTO `inquiry_codes`
VALUES (1, 'QUESTION');
INSERT INTO `inquiry_codes`
VALUES (2, 'DEFECT');

#포인트코드
INSERT INTO `point_codes`
VALUES (1, 'USE');
INSERT INTO `point_codes`
VALUES (2, 'SAVE');
INSERT INTO `point_codes`
VALUES (3, 'SUM');

#상품적립방식코드
INSERT INTO `product_saving_method_codes`
VALUES (1, 'ACTUAL_PURCHASE_PRICE');
INSERT INTO `product_saving_method_codes`
VALUES (2, 'SELLING_PRICE');

#상품유형코드
INSERT INTO `product_type_codes`
VALUES (1, 'NONE');
INSERT INTO `product_type_codes`
VALUES (2, 'BESTSELLER');
INSERT INTO `product_type_codes`
VALUES (3, 'RECOMMENDATION');
INSERT INTO `product_type_codes`
VALUES (4, 'NEWBOOK');
INSERT INTO `product_type_codes`
VALUES (5, 'POPULARITY');
INSERT INTO `product_type_codes`
VALUES (6, 'DISCOUNTS');

#주문코드
INSERT INTO `order_codes`
VALUES (1, 'NON_MEMBER_ORDER');
INSERT INTO `order_codes`
VALUES (2, 'MEMBER_ORDER');
INSERT INTO `order_codes`
VALUES (3, 'MEMBER_SUBSCRIBE');

#주문상태코드
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

#결제코드
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
VALUES (6, 'BILLING');
INSERT INTO `payment_codes`
VALUES (7, 'CARD');
INSERT INTO `payment_codes`
VALUES (8, 'SIMPLE_PAY');
INSERT INTO `payment_codes`
VALUES (9, 'READY');
INSERT INTO `payment_codes`
VALUES (10, 'DONE');
INSERT INTO `payment_codes`
VALUES (11, 'CANCELED');
INSERT INTO `payment_codes`
VALUES (12, 'PARTIAL_CANCELED');
INSERT INTO `payment_codes`
VALUES (13, 'ABORTED');
INSERT INTO `payment_codes`
VALUES (14, 'COMPLETED');

#카드사 코드
INSERT INTO `payment_card_acquirer_codes`
VALUES (1, '3K', 'BC카드-IBK');
INSERT INTO `payment_card_acquirer_codes`
VALUES (2, '46', '광주은행');
INSERT INTO `payment_card_acquirer_codes`
VALUES (3, '71', '롯데카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (4, '30', 'KDB산업은행');
INSERT INTO `payment_card_acquirer_codes`
VALUES (5, '31', 'BC카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (6, '51', '삼성카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (7, '38', '새마을금고');
INSERT INTO `payment_card_acquirer_codes`
VALUES (8, '41', '신한카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (9, '62', '신협');
INSERT INTO `payment_card_acquirer_codes`
VALUES (10, '36', '씨티카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (11, '33', '우리카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (12, '37', '우체국예금보험');
INSERT INTO `payment_card_acquirer_codes`
VALUES (13, '39', '저축은행중앙회');
INSERT INTO `payment_card_acquirer_codes`
VALUES (14, '35', '전북은행');
INSERT INTO `payment_card_acquirer_codes`
VALUES (15, '42', '제주은행');
INSERT INTO `payment_card_acquirer_codes`
VALUES (16, '15', '카카오뱅크');
INSERT INTO `payment_card_acquirer_codes`
VALUES (17, '3A', '케이뱅크');
INSERT INTO `payment_card_acquirer_codes`
VALUES (18, '24', '토스뱅크');
INSERT INTO `payment_card_acquirer_codes`
VALUES (19, '21', '하나카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (20, '61', '현대카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (21, '11', 'KB국민카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (22, '91', 'NH농협카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (23, '34', 'Sh수협은행');
INSERT INTO `payment_card_acquirer_codes`
VALUES (24, '6D', '다이너스 클럽');
INSERT INTO `payment_card_acquirer_codes`
VALUES (25, '6I', '디스커버');
INSERT INTO `payment_card_acquirer_codes`
VALUES (26, '4M', '마스터카드');
INSERT INTO `payment_card_acquirer_codes`
VALUES (27, '3C', '유니온페이');
INSERT INTO `payment_card_acquirer_codes`
VALUES (28, '7A', '아메리칸 익스프레스');
INSERT INTO `payment_card_acquirer_codes`
VALUES (29, '4J', 'JCB');
INSERT INTO `payment_card_acquirer_codes`
VALUES (30, '4V', 'VISA');

#전체할인율초기설정
INSERT INTO `total_discount_rates`
VALUES (1, 10);
