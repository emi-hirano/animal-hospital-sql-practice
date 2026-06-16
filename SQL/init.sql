-- 動物病院をテーマにしたSQL練習用データベース
-- MySQL 8.4で実行できます。

CREATE DATABASE IF NOT EXISTS animal_hospital
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE animal_hospital;

-- 外部キーで参照されるテーブルがあるため、削除は子テーブルから行います。
DROP TABLE IF EXISTS visit_treatments;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS pets;
DROP TABLE IF EXISTS owners;

-- 飼い主
CREATE TABLE owners (
  owner_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  owner_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  city VARCHAR(100) NOT NULL,
  registered_at DATE NOT NULL
) ENGINE = InnoDB;

-- ペット
CREATE TABLE pets (
  pet_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  owner_id INT UNSIGNED NOT NULL,
  pet_name VARCHAR(100) NOT NULL,
  species VARCHAR(30) NOT NULL,
  breed VARCHAR(100),
  sex ENUM('オス', 'メス', '不明') NOT NULL DEFAULT '不明',
  birth_date DATE,
  CONSTRAINT fk_pets_owner
    FOREIGN KEY (owner_id) REFERENCES owners(owner_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 獣医師
CREATE TABLE doctors (
  doctor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  doctor_name VARCHAR(100) NOT NULL,
  specialty VARCHAR(100) NOT NULL,
  hired_at DATE NOT NULL
) ENGINE = InnoDB;

-- 診察
CREATE TABLE visits (
  visit_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  pet_id INT UNSIGNED NOT NULL,
  doctor_id INT UNSIGNED NOT NULL,
  visited_at DATETIME NOT NULL,
  symptom VARCHAR(255) NOT NULL,
  diagnosis VARCHAR(255),
  consultation_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  CONSTRAINT chk_visits_fee
    CHECK (consultation_fee >= 0),
  CONSTRAINT fk_visits_pet
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_visits_doctor
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 処置マスター
CREATE TABLE treatments (
  treatment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  treatment_name VARCHAR(100) NOT NULL,
  standard_price DECIMAL(10, 2) NOT NULL,
  CONSTRAINT chk_treatments_price
    CHECK (standard_price >= 0)
) ENGINE = InnoDB;

-- 1回の診察で複数の処置を行えるため、中間テーブルで関連付けます。
CREATE TABLE visit_treatments (
  visit_id INT UNSIGNED NOT NULL,
  treatment_id INT UNSIGNED NOT NULL,
  quantity INT UNSIGNED NOT NULL DEFAULT 1,
  actual_price DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (visit_id, treatment_id),
  CONSTRAINT chk_visit_treatments_quantity
    CHECK (quantity > 0),
  CONSTRAINT chk_visit_treatments_price
    CHECK (actual_price >= 0),
  CONSTRAINT fk_visit_treatments_visit
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_visit_treatments_treatment
    FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 練習用データ ------------------------------------------------------------

INSERT INTO owners (owner_id, owner_name, phone, city, registered_at) VALUES
  (1, '佐藤 花子', '090-1111-2222', '東京都世田谷区', '2023-04-10'),
  (2, '鈴木 一郎', '080-2222-3333', '東京都杉並区', '2023-07-21'),
  (3, '高橋 美咲', '090-3333-4444', '東京都世田谷区', '2024-01-15'),
  (4, '田中 健',   '070-4444-5555', '東京都練馬区', '2024-03-03'),
  (5, '伊藤 葵',   '080-5555-6666', '東京都杉並区', '2024-06-18'),
  (6, '渡辺 翔太', '090-6666-7777', '東京都中野区', '2025-02-11'),
  (7, '山本 結衣', '070-7777-8888', '東京都練馬区', '2025-05-09'),
  (8, '中村 直樹', '080-8888-9999', '東京都中野区', '2025-08-20');

INSERT INTO pets
  (pet_id, owner_id, pet_name, species, breed, sex, birth_date)
VALUES
  (1,  1, 'ココ',   '犬',     'トイプードル',       'メス', '2019-05-12'),
  (2,  1, 'ミント', '猫',     'スコティッシュフォールド', 'オス', '2021-09-03'),
  (3,  2, 'レオ',   '犬',     '柴犬',               'オス', '2018-11-20'),
  (4,  3, 'モモ',   'うさぎ', 'ネザーランドドワーフ', 'メス', '2022-02-14'),
  (5,  4, 'ソラ',   '猫',     '雑種',               'オス', '2020-07-07'),
  (6,  5, 'ハナ',   '犬',     'ゴールデンレトリバー', 'メス', '2017-03-25'),
  (7,  5, 'マロン', 'うさぎ', 'ホーランドロップ',   'オス', '2023-06-01'),
  (8,  6, 'ルナ',   '猫',     'アメリカンショートヘア', 'メス', '2022-12-19'),
  (9,  7, 'ポンタ', 'ハムスター', 'ゴールデンハムスター', 'オス', '2024-10-05'),
  (10, 8, 'ベル',   '犬',     'チワワ',             'メス', '2021-01-30'),
  (11, 3, 'キナコ', '猫',     'マンチカン',         'メス', '2024-04-08');

INSERT INTO doctors
  (doctor_id, doctor_name, specialty, hired_at)
VALUES
  (1, '山田 太郎', '内科',       '2018-04-01'),
  (2, '小林 彩',   '外科',       '2020-10-01'),
  (3, '加藤 誠',   '皮膚科',     '2022-04-01'),
  (4, '吉田 愛',   'エキゾチックアニマル', '2024-04-01');

INSERT INTO treatments
  (treatment_id, treatment_name, standard_price)
VALUES
  (1, '血液検査',       5000.00),
  (2, 'レントゲン検査', 7000.00),
  (3, 'ワクチン接種',   4000.00),
  (4, '点滴',           3500.00),
  (5, '投薬',           2000.00),
  (6, '傷口の消毒',     1500.00),
  (7, '爪切り',         1000.00),
  (8, '超音波検査',     8000.00),
  (9, '歯石除去',      12000.00);

INSERT INTO visits
  (visit_id, pet_id, doctor_id, visited_at, symptom, diagnosis, consultation_fee)
VALUES
  (1,  1,  1, '2025-01-10 09:30:00', '食欲がない',       '軽い胃腸炎',       3000.00),
  (2,  3,  2, '2025-01-15 14:00:00', '足を引きずる',     '右前足の捻挫',     3500.00),
  (3,  4,  4, '2025-02-02 10:15:00', '歯が伸びている',   '不正咬合',         3000.00),
  (4,  2,  3, '2025-02-20 16:30:00', '皮膚をかゆがる',   'アレルギー性皮膚炎', 3000.00),
  (5,  6,  1, '2025-03-05 11:00:00', '元気がない',       '貧血の疑い',       3000.00),
  (6,  5,  3, '2025-03-18 15:45:00', '耳をかゆがる',     '外耳炎',           3000.00),
  (7,  1,  1, '2025-04-12 09:00:00', '予防接種希望',     '健康',             2000.00),
  (8,  7,  4, '2025-04-25 13:20:00', '爪が伸びている',   '健康',             2000.00),
  (9,  8,  1, '2025-05-06 10:40:00', '嘔吐した',         '毛球症',           3000.00),
  (10, 3,  2, '2025-05-20 17:10:00', '歯の汚れ',         '歯周病',           3500.00),
  (11, 9,  4, '2025-06-01 12:00:00', '頬が腫れている',   '頬袋の炎症',       3000.00),
  (12, 2,  3, '2025-06-14 09:50:00', '皮膚炎の再診',     '症状改善',         2000.00),
  (13, 6,  1, '2025-07-03 14:30:00', '定期検査',         '経過良好',         2500.00),
  (14, 10, 1, '2025-07-22 11:15:00', '下痢をしている',   '消化不良',         3000.00),
  (15, 1,  2, '2025-08-08 16:00:00', '切り傷',           '浅い裂傷',         3500.00),
  (16, 5,  1, '2025-08-30 10:00:00', '予防接種希望',     '健康',             2000.00);

-- actual_priceは1回あたりの実際の価格です。
-- 処置費の合計は actual_price * quantity で求められます。
INSERT INTO visit_treatments
  (visit_id, treatment_id, quantity, actual_price)
VALUES
  (1,  1, 1, 5000.00),
  (1,  4, 1, 3500.00),
  (1,  5, 1, 2000.00),
  (2,  2, 1, 7000.00),
  (2,  5, 1, 2000.00),
  (3,  5, 1, 1800.00),
  (4,  1, 1, 5000.00),
  (4,  5, 2, 2000.00),
  (5,  1, 1, 5000.00),
  (5,  8, 1, 8000.00),
  (6,  5, 1, 2000.00),
  (7,  3, 1, 4000.00),
  (8,  7, 1, 1000.00),
  (9,  4, 1, 3500.00),
  (9,  5, 1, 2000.00),
  (10, 9, 1, 12000.00),
  (11, 5, 1, 2000.00),
  (12, 5, 1, 2000.00),
  (13, 1, 1, 5000.00),
  (14, 4, 1, 3500.00),
  (14, 5, 1, 2000.00),
  (15, 6, 1, 1500.00),
  (15, 5, 1, 2000.00),
  (16, 3, 1, 4000.00);
