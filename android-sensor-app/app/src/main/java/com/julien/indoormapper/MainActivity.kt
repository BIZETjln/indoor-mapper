package com.julien.indoormapper

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

/**
 * Point d'entrée de l'app Android.
 *
 * Pour l'instant affiche juste un écran "Hello" : c'est la base sur laquelle
 * tu vas construire US-01 (affichage IMU), US-02 (caméra), US-04 (WebSocket).
 */
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            // MaterialTheme fournit les couleurs et typos par défaut à tous les composables enfants.
            MaterialTheme {
                Surface(modifier = Modifier.fillMaxSize()) {
                    HomeScreen()
                }
            }
        }
    }
}

@Composable
fun HomeScreen() {
    // Column = un layout vertical, comme un VStack en SwiftUI ou flex-direction:column en CSS.
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Text(
            text = "Indoor Mapper",
            style = MaterialTheme.typography.headlineMedium,
        )
        Text(
            text = "v0.1.0",
            style = MaterialTheme.typography.bodyMedium,
        )
    }
}

// L'annotation @Preview permet à Android Studio d'afficher un aperçu sans lancer l'app.
@Preview(showBackground = true)
@Composable
fun HomeScreenPreview() {
    MaterialTheme {
        HomeScreen()
    }
}
