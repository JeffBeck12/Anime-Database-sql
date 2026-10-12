from pathlib import Path
import json, csv
from PIL import Image, ImageDraw, ImageFont
ROOT=Path(__file__).resolve().parents[1]
data=json.loads((ROOT/'data/sample_data.json').read_text())
OUT=ROOT/'visualizations'; OUT.mkdir(exist_ok=True)
def font(size):
    for name in ['DejaVuSans.ttf','C:/Windows/Fonts/arial.ttf']:
        try: return ImageFont.truetype(name,size)
        except OSError: pass
    return ImageFont.load_default(size=size)
def bars(filename,title,labels,values,unit):
    im=Image.new('RGB',(1400,900),'#f6f8fc'); d=ImageDraw.Draw(im)
    d.text((65,45),title,font=font(36),fill='#14253d')
    d.text((65,105),'SYNTHETIC SAMPLE DATA | Fictional portfolio demonstration',font=font(23),fill='#58667c')
    x0,x1=420,1280; top=205; bottom=750; maxv=max(values)*1.12
    for tick in range(6):
        value=maxv*tick/5; x=x0+(x1-x0)*tick/5
        d.line((x,top-15,x,bottom),fill='#dce2eb',width=2)
        d.text((x-15,bottom+12),f'{value:.1f}',font=font(20),fill='#58667c')
    step=(bottom-top)/len(labels)
    for i,(label,value) in enumerate(zip(labels,values)):
        y=top+i*step
        d.text((65,y+7),label,font=font(22),fill='#14253d')
        d.rounded_rectangle((x0,y,x0+value/maxv*(x1-x0),y+step*0.65),radius=5,fill='#5271df')
        d.text((x0+value/maxv*(x1-x0)+12,y+5),f'{value:g}',font=font(22),fill='#14253d')
    d.text((420,815),unit+' | Axis starts at zero',font=font(21),fill='#58667c')
    im.save(OUT/filename)
    with (OUT/(Path(filename).stem+'.csv')).open('w',newline='',encoding='utf-8') as f:
        w=csv.writer(f); w.writerow(['category',unit]); w.writerows(zip(labels,values))
series=data['Anime_Series']
bars('series_by_genre.png','Series by primary genre',[g[1] for g in data['Genres']],[sum(a[3]==g[0] for a in series) for g in data['Genres']],'Series count')
bars('series_by_studio.png','Series produced by studio',[s[1] for s in data['Studio']],[sum(a[2]==s[0] for a in series) for s in data['Studio']],'Series count')
bars('mean_rating_by_genre.png','Mean synthetic rating by primary genre',[g[1] for g in data['Genres']],[round(sum(a[5] for a in series if a[3]==g[0])/sum(a[3]==g[0] for a in series),2) for g in data['Genres']],'Mean rating (0–10)')
years=sorted(set(a[4] for a in series))
bars('series_by_year.png','Series released by year',[str(y) for y in years],[sum(a[4]==y for a in series) for y in years],'Series count')
