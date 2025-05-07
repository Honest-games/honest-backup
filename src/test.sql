CREATE DATABASE KEK4;
\connect KEK4;
CREATE TABLE public.ai_generated_questions_history (
                                                       id integer NOT NULL,
                                                       question_text character varying NOT NULL,
                                                       level_id character varying NOT NULL,
                                                       client_id character varying NOT NULL,
                                                       created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
                                                       deleted boolean DEFAULT false
);

select * from public.ai_generated_questions_history;