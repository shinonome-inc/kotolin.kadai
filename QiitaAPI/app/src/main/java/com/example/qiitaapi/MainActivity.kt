package com.example.qiitaapi

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.ArrayAdapter
import android.widget.ListView
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val listButton: ListView = findViewById(R.id.newslist)
        listButton.setOnItemClickListener {parent, view, position, id ->
            val fragmentManager = supportFragmentManager
            val fragmentTransaction = fragmentManager.beginTransaction()

            fragmentTransaction.addToBackStack(null)

            fragmentTransaction.add(
                R.id.web,
                WebFragment.newInstance()
            )

            fragmentTransaction.commit()
        }
    }

    private val itemInterface by lazy { createService() }

    interface ItemInterface {
        @GET("v2/items?page=1&per_page=10")
        fun items(): retrofit2.Call<List<DataItem>>
    }

    fun createService(): ItemInterface {
        val baseApiUrl = "https://qiita.com/api/"

        val httpLogging = HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY)
        val httpClientBuilder = OkHttpClient.Builder().addInterceptor(httpLogging)

        val retrofit = Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create())
            .baseUrl(baseApiUrl)
            .client(httpClientBuilder.build())
            .build()

        return retrofit.create(ItemInterface::class.java)
    }

    fun getText(v: View){
        itemInterface.items().enqueue(object : retrofit2.Callback<List<DataItem>> {
            override fun onFailure(call: retrofit2.Call<List<DataItem>>?, t: Throwable?) {
            }

            override fun onResponse(call: retrofit2.Call<List<DataItem>>?, response: retrofit2.Response<List<DataItem>>) {
                if (response.isSuccessful) {
                    response.body()?.let {

                        var items = mutableListOf<String>()
                        var res = response.body()?.iterator()

                        if (res != null) {
                            for (item in res) {
                                items.add(item.title)
                            }
                        }

                        //items = mutableListOf("a","b","c")

                        val list: ListView = findViewById(R.id.newslist)
                        val adapter = ArrayAdapter(this@MainActivity, android.R.layout.simple_list_item_1, items)
                        list.adapter = adapter
                    }
                }
            }
        })
    }

}
