import streamlit as st
import pandas as pd
import psycopg2
import plotly.express as px

# Sayfa Ayarları
st.set_page_config(page_title="F1 Pit-Stop Analizi", page_icon="🏎️", layout="wide")

# Başlık ve Açıklama
st.title("🏎️ Formula 1 Operasyonel Veri Analizi")
st.markdown("Bu dashboard, takımların pit-stop performanslarını ve yarış stratejilerini analiz eder.")

# Veritabanı Bağlantı Fonksiyonu (Performans için önbelleğe alıyoruz)
@st.cache_data
def get_data(query):
    # Kendi PostgreSQL bilgilerine göre burayı düzenle:
    conn = psycopg2.connect(
        host="localhost",
        database="f1_optimization",
        user="postgres", # Genelde varsayılan kullanıcı adı budur
        password=3678, # pgAdmin şifren
        port="5432"
    )
    df = pd.read_sql(query, conn)
    conn.close()
    return df

# --- BÖLÜM 1: TAKIM PERFORMANSLARI ---
st.header("🏆 Takımların Ortalama Pit-Stop Hızları (2023)")

# PostgreSQL'den veriyi çeken SQL sorgumuz (Adım 2'de yazdığımızın aynısı)
sql_query = """
    SELECT 
        c.name AS takim_adi,
        COUNT(p.stop) AS toplam_pit_sayisi,
        ROUND(AVG(p.milliseconds) / 1000.0, 2) AS ortalama_pit_suresi_sn
    FROM pit_stops p
    JOIN races r ON p.raceId = r.raceId
    JOIN results res ON p.raceId = res.raceId AND p.driverId = res.driverId
    JOIN constructors c ON res.constructorId = c.constructorId
    WHERE r.year = 2023
    GROUP BY c.name
    ORDER BY ortalama_pit_suresi_sn ASC;
"""

# Veriyi çek ve Pandas DataFrame'e dönüştür
df_teams = get_data(sql_query)

# Ekranı iki kolona böl (Sol tarafta tablo, sağ tarafta grafik)
col1, col2 = st.columns(2)

with col1:
    st.dataframe(df_teams, use_container_width=True)

with col2:
    # Plotly ile interaktif bar grafiği çizimi
    fig = px.bar(
        df_teams, 
        x='takim_adi', 
        y='ortalama_pit_suresi_sn',
        title="Takımlara Göre Ortalama Pit-Stop Süresi (Saniye)",
        labels={'takim_adi': 'Takım', 'ortalama_pit_suresi_sn': 'Ortalama Süre (sn)'},
        color='ortalama_pit_suresi_sn',
        color_continuous_scale='Reds_r' # Hızlı olanlar (düşük süre) daha koyu kırmızı olsun
    )
    st.plotly_chart(fig, use_container_width=True)

st.success("Veriler PostgreSQL veritabanından anlık olarak çekilmektedir.")