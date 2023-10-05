create table fact_splits
(
  id tbigident not null,
  dt  timestamp,
  avaya tbigcode,
  split_n ttext64,
  acdcalls integer,
  ringtime integer,
  acdtime integer,
  acwtime integer,
  holdacdtime integer,
  constraint pk_fact_splits primary key (id)
);


create table plan_splits
(
  id integer not null,
  split_n ttext64,
  plan_n float,
  constraint pk_plan_splits primary key (id)
);


-- Вторую таблицу ручками набил

INSERT INTO plan_splits (ID,split_n,plan_n) VALUES (1,'BLOCK',       159   );      
INSERT INTO plan_splits (ID,split_n,plan_n) VALUES (2,'Expert ERKC', 267   );      
INSERT INTO plan_splits (ID,split_n,plan_n) VALUES (3,'General',     191.5 );        
INSERT INTO plan_splits (ID,split_n,plan_n) VALUES (4,'Invest',      222   );      
INSERT INTO plan_splits (ID,split_n,plan_n) VALUES (5,'Kredit',      213   );      
INSERT INTO plan_splits (ID,split_n,plan_n) VALUES (6,'NPF',         265   );      
INSERT INTO plan_splits (ID,split_n,plan_n) VALUES (7,'Premier',     241.6 );        
INSERT INTO plan_splits (ID,split_n,plan_n) VALUES (8,'VIP ERKC',    255   );      
         

--   Запросы

select avaya,split_n, /* cbo = obo/acdcalls */ sum((/*obo*/ ringtime + acdtime + acwtime + holdacdtime)/acdcalls) cbo
  from fact_splits
 group by 1,2


select ff.*, round(ff.cbo/p.plan_n*100,2) proc_done
  from ( select f.avaya,f.split_n, /* cbo = obo/acdcalls */
                sum((/*obo*/ f.ringtime + f.acdtime + f.acwtime + f.holdacdtime)/f.acdcalls) cbo
           from fact_splits f
          group by 1,2) ff
left join plan_splits p using(split_n)


