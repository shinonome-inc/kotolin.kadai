package com.example.qiitaapi

data class dataItem(
    val body: String,
    val id: Int,
    val rendered_body: String,
    val tags: List<Tag>,
    val title: String,
    val url: String,
    val user: User
)

data class Tag(
    val name: String,
    val versions: List<Any>
)

data class User(
    val id: String,
    val linkedin_id: String,
    val name: String,
    val permanent_id: Int
)


