package com.example.jankenapp

import android.graphics.drawable.AnimationDrawable
import android.os.Bundle
import android.os.Handler
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {
    private val mHandler = Handler()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

        enum class HandType(val id: Int) {
            rock(0), scisser(1), paper(2),
        }

        fun rockButton(view: View) {
            main(HandType.rock)
        }

        fun paperButton(view: View) {
            main(HandType.paper)
        }

        fun scisserButton(view: View) {
            main(HandType.scisser)
        }

        fun randomAnimation(quit: Boolean) {
            imageView2.setImageResource(R.drawable.spin_animation)
            val frameAnimation = imageView2.drawable as AnimationDrawable
            frameAnimation.start()
            if (quit) {
                frameAnimation.stop()
            }
        }



        fun main(hand: HandType) {
            var cp = (0..2).shuffled().first()
            randomAnimation(quit = false)
            resulttext.text = "result"

            Handler().postDelayed(Runnable {
                randomAnimation(quit = true)

                when(cp){
                    0 -> imageView2.setImageResource(R.drawable.rock)
                    1 -> imageView2.setImageResource(R.drawable.scissers)
                    2 -> imageView2.setImageResource(R.drawable.paper)
                }

                when {
                    hand.id == cp ->
                        resulttext.text = "draw"

                    (hand.id + 1) % 3 == cp ->
                        resulttext.text = "win!"

                    else ->
                        resulttext.text = "lose..."
                }
            }, 2000)
        }
    }
