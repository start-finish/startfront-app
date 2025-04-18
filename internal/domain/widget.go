package domain

type Widget struct {
	ID         int    `db:"id" json:"id"`
	ScreenID   int    `db:"screen_id" json:"screen_id"`
	ParentID   *int   `db:"parent_id" json:"parent_id"`
	Type       string `db:"type" json:"type"`
	Props      string `db:"props" json:"props"`
	ChildIndex *int   `db:"child_index" json:"child_index"`
	AuthBy     *int   `db:"auth_by" json:"auth_by"`
}
