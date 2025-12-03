BEGIN
    noter_livre(73, '0195153448', 4);
END;
/



SELECT * FROM RATINGS
WHERE user_id = 73
  AND isbn = '0195153448';
  
  

  
