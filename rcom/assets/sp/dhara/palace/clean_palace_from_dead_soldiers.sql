CREATE PROCEDURE clean_palace_from_dead_soldiers (IN in_member_id INT)
BEGIN
	DELETE FROM first_file_members
	WHERE member_id = in_member_id;
END